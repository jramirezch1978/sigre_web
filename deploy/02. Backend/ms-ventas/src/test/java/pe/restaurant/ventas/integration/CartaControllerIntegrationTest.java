package pe.restaurant.ventas.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.persistence.EntityManager;
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
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.testdata.VentasTestDataFactory;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — CartaController")
class CartaControllerIntegrationTest {

    @Autowired private WebApplicationContext webApplicationContext;
    @Autowired private DataSource dataSource;
    @Autowired private VentasTestDataFactory ventasFactory;
    @Autowired private EntityManager entityManager;

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
        ventasFactory.ensureVentasTransactionalData();
    }

    private CartaRequest baseRequest() {
        CartaRequest req = new CartaRequest();
        req.setNombre("TEST-CARTA-INTEGRACION");
        req.setDescripcion("Carta de prueba integración");
        return req;
    }

    private Long crearCarta(String nombre) throws Exception {
        CartaRequest req = new CartaRequest();
        req.setNombre(nombre);
        req.setDescripcion("test");
        String resp = mockMvc.perform(post("/api/ventas/cartas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(resp).get("data").get("id").asLong();
    }

    // ── GET / — Listar ──

    @Test
    @DisplayName("GET / — debe listar cartas paginadas")
    void listar_DebeRetornarPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/cartas")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.page.totalElements").isNumber());
    }

    // ── POST / — Crear ──

    @Test
    @DisplayName("POST / — debe crear carta")
    void crear_DebeCrearCarta() throws Exception {
        mockMvc.perform(post("/api/ventas/cartas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("TEST-CARTA-INTEGRACION"))
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    // ── GET /{id} ──

    @Test
    @DisplayName("GET /{id} — debe obtener carta por ID")
    void obtenerPorId_DebeRetornarCarta() throws Exception {
        Long id = crearCarta("CARTA-GET-TEST");

        mockMvc.perform(get("/api/ventas/cartas/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.nombre").value("CARTA-GET-TEST"));
    }

    @Test
    @DisplayName("GET /{id} — 404 si no existe")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/ventas/cartas/{id}", 99999999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound());
    }

    // ── GET /sucursal/{sucursalId} ──

    @Test
    @DisplayName("GET /sucursal/{id} — debe listar cartas activas por sucursal")
    void listarPorSucursal_DebeRetornarCartas() throws Exception {
        mockMvc.perform(get("/api/ventas/cartas/sucursal/{sucursalId}", 1)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── PUT /{id} — Actualizar ──

    @Test
    @DisplayName("PUT /{id} — debe actualizar carta")
    void actualizar_DebeModificar() throws Exception {
        Long id = crearCarta("CARTA-PUT-TEST");

        CartaRequest update = new CartaRequest();
        update.setNombre("CARTA-PUT-MODIFICADA");
        update.setDescripcion("modificada");

        mockMvc.perform(put("/api/ventas/cartas/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(update)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.nombre").value("CARTA-PUT-MODIFICADA"));
    }

    // ── DELETE /{id} ──

    @Test
    @DisplayName("DELETE /{id} — debe hacer baja lógica")
    void eliminar_DebeBajaLogica() throws Exception {
        Long id = crearCarta("CARTA-DEL-TEST");

        mockMvc.perform(delete("/api/ventas/cartas/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── PATCH activar/desactivar ──

    @Test
    @DisplayName("PATCH /{id}/desactivar — debe desactivar")
    void desactivar_DebeDesactivar() throws Exception {
        Long id = crearCarta("CARTA-DESACT-TEST");

        mockMvc.perform(patch("/api/ventas/cartas/{id}/desactivar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk());

        entityManager.flush();
        String estado = jdbc.queryForObject(
                "SELECT flag_estado FROM ventas.carta WHERE id = ?", String.class, id);
        org.assertj.core.api.Assertions.assertThat(estado).isEqualTo("0");
    }

    @Test
    @DisplayName("PATCH /{id}/activar — debe activar")
    void activar_DebeActivar() throws Exception {
        Long id = crearCarta("CARTA-ACT-TEST");

        jdbc.update("UPDATE ventas.carta SET flag_estado = '0' WHERE id = ?", id);
        entityManager.flush();
        entityManager.clear();

        mockMvc.perform(patch("/api/ventas/cartas/{id}/activar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }
}
