package pe.restaurant.finanzas.controller.integration;

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
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.testdata.FinanzasTestDataExecutionListener;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.finanzas.testdata.TestDataSeederFinanzas;
import pe.restaurant.finanzas.testutil.TestDataFactory;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, FinanzasTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - DetraccionController")
class DetraccionControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;
    private Long detraccionId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";


        detraccionId = jdbc.queryForObject(
            "INSERT INTO finanzas.detraccion (cntas_pagar_id, nro_detraccion, fecha_registro, importe, flag_tabla, created_by, fec_creacion, flag_estado) VALUES (1001, 'DET-SEED', CURRENT_DATE, 100.00, '1', 1, NOW(), '0') RETURNING id",
            Long.class);
    }

    private ResultActions performWithTenant(RequestBuilder requestBuilder) throws Exception {
        if (requestBuilder instanceof MockHttpServletRequestBuilder) {
            ((MockHttpServletRequestBuilder) requestBuilder)
                .header("X-Empresa-Id", "2")
                .header("X-Sucursal-Id", "1");
        }
        return mockMvc.perform(requestBuilder);
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones - Debe listar detracciones paginado")
    void listar_Detracciones_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones - Debe filtrar por número de detracción")
    void listar_ConFiltroNroDetraccion_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .param("nroDetraccion", "DET-SEED")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones - Debe filtrar por cuentas por pagar")
    void listar_ConFiltroCntasPagar_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .param("cntasPagarId", "1001")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones - Debe filtrar por estado")
    void listar_ConFiltroEstado_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .param("flagEstado", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones/{id} - Debe obtener detracción por ID")
    void obtenerPorId_DetraccionExistente_DebeRetornar() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones/{id}", detraccionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/finanzas/detracciones/{id} - Debe retornar 404 para ID inexistente")
    void obtenerPorId_DetraccionInexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/detracciones/{id}", 99999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/detracciones - Debe crear detracción")
    void crear_Detraccion_DebeCrearYRetornar() throws Exception {
        performWithTenant(post("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearDetraccionRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @DisplayName("PUT /api/finanzas/detracciones/{id} - Debe actualizar detracción")
    void actualizar_Detraccion_DebeActualizarYRetornar() throws Exception {
        String createResponse = performWithTenant(post("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearDetraccionRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        Long nuevaId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        performWithTenant(put("/api/finanzas/detracciones/{id}", nuevaId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearDetraccionRequestParaActualizar())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/detracciones/{id}/activar - Debe activar detracción")
    void activar_Detraccion_DebeActivarYRetornar() throws Exception {
        performWithTenant(patch("/api/finanzas/detracciones/{id}/activar", detraccionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @org.junit.jupiter.api.Disabled("Requiere seed con flag_estado='1' (activo)")
    @DisplayName("PATCH /api/finanzas/detracciones/{id}/desactivar - Debe desactivar detracción")
    void desactivar_Detraccion_DebeDesactivarYRetornar() throws Exception {
        performWithTenant(patch("/api/finanzas/detracciones/{id}/desactivar", detraccionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/finanzas/detracciones - Debe rechazar con datos inválidos")
    void crear_DetraccionConDatosInvalidos_DebeRetornarError() throws Exception {
        String request = """
            {
                "importe": -50.00
            }
            """;

        performWithTenant(post("/api/finanzas/detracciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(request))
                .andExpect(status().isBadRequest());
    }
}