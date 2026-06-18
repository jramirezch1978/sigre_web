package pe.restaurant.finanzas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
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
@DisplayName("Pruebas de Integración - LiquidacionController")
class LiquidacionControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;
    private Long liquidacionId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";

        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedMoneda();
        testDataSeeder.seedSucursal();
        testDataSeeder.seedEntidadContribuyente();
        testDataSeeder.seedCentrosCosto();

        // Seed solicitud_giro (FK requerida por liquidacion)
        jdbc.update("""
            INSERT INTO finanzas.solicitud_giro (id, sucursal_id, numero, fecha, monto, tipo_solicitud, created_by, fec_creacion, flag_estado)
            VALUES (1, 1, 'SG-TEST-001', CURRENT_DATE, 1000.00, 'O', 1, NOW(), '1')
            ON CONFLICT (id) DO NOTHING
            """);

        liquidacionId = jdbc.queryForObject(
            "INSERT INTO finanzas.liquidacion (solicitud_giro_id, nro_liquidacion, sucursal_id, proveedor_id, fecha_registro, concepto_financiero_id, importe_neto, tasa_cambio, observacion, anio, mes, created_by, fec_creacion, flag_estado) VALUES (1, 'LIQ-SEED', 1, 1, CURRENT_DATE, 1, 1000.00, 1.0, 'Seed', 2026, 5, 1, NOW(), '1') RETURNING id",
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
    @DisplayName("GET /api/finanzas/liquidaciones - Debe listar liquidaciones paginado")
    void listar_Liquidaciones_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/liquidaciones")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/liquidaciones/{id} - Debe obtener liquidación por ID")
    void obtenerPorId_LiquidacionExistente_DebeRetornarDetalle() throws Exception {
        performWithTenant(get("/api/finanzas/liquidaciones/{id}", liquidacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/finanzas/liquidaciones/{id} - Debe retornar 404 para ID inexistente")
    void obtenerPorId_LiquidacionInexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/liquidaciones/{id}", 99999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/finanzas/liquidaciones/{id}/validacion-cierre - Debe validar cierre")
    void validarCierre_Liquidacion_DebeRetornarValidacion() throws Exception {
        performWithTenant(get("/api/finanzas/liquidaciones/{id}/validacion-cierre", liquidacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/finanzas/liquidaciones - Debe rechazar con datos inválidos")
    void crear_LiquidacionConDatosInvalidos_DebeRetornarError() throws Exception {
        ObjectNode request = objectMapper.createObjectNode();
        request.put("importeNeto", -100.00);

        performWithTenant(post("/api/finanzas/liquidaciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }
}