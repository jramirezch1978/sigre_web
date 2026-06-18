package pe.restaurant.ventas.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.ventas.dto.request.CierreCajaCerrarRequest;
import pe.restaurant.ventas.dto.request.CierreCajaRequest;
import pe.restaurant.ventas.dto.response.CierreCajaResponse;
import pe.restaurant.ventas.testdata.VentasTestDataFactory;

import javax.sql.DataSource;
import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CierreCajaController con datos reales en base de datos.
 * CierreCaja es el controller más simple: 4 endpoints, sin dependencias externas, sin Feign clients.
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — CierreCajaController")
class CierreCajaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private VentasTestDataFactory ventasFactory;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";

        // VentasTestDataFactory inserta sus propios datos y resuelve sus dependencias
        // (entidad_contribuyente, punto_venta, mesa, etc.). Para CierreCaja no se necesita
        // TestDataSeeder.seedAll() — el test más simple no depende de almacen/vale_mov.
        ventasFactory.ensureVentasTransactionalData();
    }

    // ─────────────────────────────────────────────
    // GET /api/ventas/cierre-caja — Listar cierres
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("GET / — debe listar cierres con paginación")
    void listar_DebeRetornarPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").isNumber());
    }

    @Test
    @DisplayName("GET /?turnoId= — debe filtrar por turno")
    void listar_FiltrarPorTurno_DebeRetornarFiltrado() throws Exception {
        mockMvc.perform(get("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .param("turnoId", "888001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content[0].turnoId").value(888001));
    }

    // ─────────────────────────────────────────────
    // GET /api/ventas/cierre-caja/{id} — Obtener por ID
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("GET /{id} — debe obtener cierre por ID")
    void obtenerPorId_DebeRetornarCierre() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.cierre_caja WHERE observaciones = 'FACTORY-CIERRE-ABIERTO' LIMIT 1",
                Long.class);
        assertThat(id).isNotNull();

        mockMvc.perform(get("/api/ventas/cierre-caja/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.turnoId").value(888001))
                .andExpect(jsonPath("$.data.fondoInicial").value(100.00))
                .andExpect(jsonPath("$.data.observaciones").value("FACTORY-CIERRE-ABIERTO"));
    }

    @Test
    @DisplayName("GET /{id} — 404 si no existe")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/ventas/cierre-caja/{id}", 99999999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound());
    }

    // ─────────────────────────────────────────────
    // POST /api/ventas/cierre-caja — Crear apertura
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("POST / — debe crear cierre abierto")
    void crear_DebeCrearApertura() throws Exception {
        CierreCajaRequest request = CierreCajaRequest.builder()
                .turnoId(888999L)
                .ventasEfectivo(new BigDecimal("50.0000"))
                .ventasTarjeta(new BigDecimal("0.0000"))
                .ventasDigital(new BigDecimal("0.0000"))
                .ventasTotal(new BigDecimal("50.0000"))
                .propinasTotal(new BigDecimal("0.0000"))
                .fondoInicial(new BigDecimal("200.0000"))
                .observaciones("test-integracion-apertura")
                .build();

        String response = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.turnoId").value(888999))
                .andExpect(jsonPath("$.data.fondoInicial").value(200.00))
                .andExpect(jsonPath("$.data.fondoFinal").doesNotExist())
                .andExpect(jsonPath("$.data.fechaCierre").doesNotExist())
                .andReturn().getResponse().getContentAsString();

        // Verificar en BD que se insertó realmente
        CierreCajaResponse resp = objectMapper.readValue(
                objectMapper.readTree(response).get("data").toString(),
                CierreCajaResponse.class);

        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM ventas.cierre_caja WHERE id = ? AND observaciones = 'test-integracion-apertura'",
                Integer.class, resp.getId());
        assertThat(count).isEqualTo(1);
    }

    @Test
    @DisplayName("POST / — 400 si ya existe cierre abierto para el mismo turno")
    void crear_TurnoDuplicado_DebeRetornar400() throws Exception {
        CierreCajaRequest request = CierreCajaRequest.builder()
                .turnoId(888001L) // mismo turno del seed data
                .ventasTotal(new BigDecimal("10.0000"))
                .fondoInicial(new BigDecimal("100.0000"))
                .build();

        mockMvc.perform(post("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errorCode").value("VEN-111"));
    }

    // ─────────────────────────────────────────────
    // PATCH /api/ventas/cierre-caja/{id}/cerrar — Cerrar turno
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("PATCH /{id}/cerrar — debe finalizar cierre abierto")
    void cerrar_DebeFinalizarCierre() throws Exception {
        // Crear nuevo cierre para cerrarlo (el del seed está en otra transacción)
        CierreCajaRequest createReq = CierreCajaRequest.builder()
                .turnoId(888777L)
                .ventasTotal(new BigDecimal("30.0000"))
                .fondoInicial(new BigDecimal("150.0000"))
                .observaciones("test-integracion-para-cerrar")
                .build();

        String created = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(createReq)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        CierreCajaCerrarRequest cerrarReq = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("180.0000"))
                .diferencia(new BigDecimal("0.0000"))
                .observaciones("cerrado-por-test")
                .build();

        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(cerrarReq)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.fondoFinal").value(180.00))
                .andExpect(jsonPath("$.data.fechaCierre").exists())
                .andExpect(jsonPath("$.data.observaciones").value("cerrado-por-test"));
    }

    @Test
    @DisplayName("PATCH /{id}/cerrar — 404 si no existe")
    void cerrar_Inexistente_DebeRetornar404() throws Exception {
        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("100.0000"))
                .build();

        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", 99999999L)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("PATCH /{id}/cerrar — 400 si ya fue cerrado")
    void cerrar_YaCerrado_DebeRetornar400() throws Exception {
        // Crear y cerrar
        CierreCajaRequest createReq = CierreCajaRequest.builder()
                .turnoId(888666L)
                .ventasTotal(new BigDecimal("20.0000"))
                .fondoInicial(new BigDecimal("100.0000"))
                .observaciones("test-doble-cierre")
                .build();

        String created = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(createReq)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        CierreCajaCerrarRequest cerrarReq = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("120.0000"))
                .build();

        // Primer cierre — debe funcionar
        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(cerrarReq)))
                .andExpect(status().isOk());

        // Segundo cierre — debe fallar (400)
        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(cerrarReq)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errorCode").value("VEN-111"));
    }
}
