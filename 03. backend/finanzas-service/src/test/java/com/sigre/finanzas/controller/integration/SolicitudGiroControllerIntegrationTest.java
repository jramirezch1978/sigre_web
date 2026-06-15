package com.sigre.finanzas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
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
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.finanzas.testdata.FinanzasTestDataExecutionListener;
import com.sigre.common.testutil.TestDataSeeder;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.SolicitudGiroRequest;
import com.sigre.finanzas.testutil.TestDataFactory;

import javax.sql.DataSource;
import java.math.BigDecimal;

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
@DisplayName("Pruebas de Integración - SolicitudGiroController")
class SolicitudGiroControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    @MockBean
    private CoreMaestrosClient coreMaestrosClient;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;
    private Long solicitudId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";

        Mockito.when(coreMaestrosClient.obtenerEntidadPorId(org.mockito.ArgumentMatchers.anyLong())).thenReturn(TestDataFactory.mockEntidadResponse());

        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedMoneda();
        testDataSeeder.seedSucursal();
        testDataSeeder.seedEntidadContribuyente();
        testDataSeeder.seedCentrosCosto();

        solicitudId = jdbc.queryForObject(
            "INSERT INTO finanzas.solicitud_giro (sucursal_id, solicitante_id, numero, fecha, monto, tipo_solicitud, created_by, fec_creacion, flag_estado) VALUES (1, 1, 'SG-SEED-01', CURRENT_DATE, 5000.00, 'O', 1, NOW(), '1') RETURNING id",
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
    @DisplayName("GET /api/finanzas/solicitudes-giro - Debe listar solicitudes paginado")
    void listar_Solicitudes_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/solicitudes-giro - Debe filtrar por proveedor")
    void listar_ConFiltroProveedor_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .param("proveedorId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/solicitudes-giro - Debe filtrar por estado")
    void listar_ConFiltroEstado_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .param("estado", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /api/finanzas/solicitudes-giro - Debe crear solicitud")
    void crear_Solicitud_DebeCrearYRetornar() throws Exception {
        performWithTenant(post("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearSolicitudGiroRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/solicitudes-giro/{id} - Debe obtener solicitud por ID")
    void obtenerPorId_SolicitudExistente_DebeRetornarDetalle() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro/{id}", solicitudId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/finanzas/solicitudes-giro/{id} - Debe retornar 404 para ID inexistente")
    void obtenerPorId_SolicitudInexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro/{id}", 99999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/solicitudes-giro/{id} - Debe actualizar solicitud")
    void actualizar_Solicitud_DebeActualizarYRetornar() throws Exception {
        String createResponse = performWithTenant(post("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearSolicitudGiroRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        Long nuevaId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        SolicitudGiroRequest updateReq = TestDataFactory.crearSolicitudGiroRequest();
        updateReq.setMonto(new BigDecimal("7500.00"));
        updateReq.setMotivo("Solicitud actualizada");
        performWithTenant(put("/api/finanzas/solicitudes-giro/{id}", nuevaId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateReq)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/finanzas/solicitudes-giro/pendientes-aprobacion - Debe listar pendientes")
    void listarPendientesAprobacion_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro/pendientes-aprobacion")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @Disabled("Endpoint GET /liquidaciones/{id}/devoluciones no implementado aún en SolicitudGiroController")
    @DisplayName("GET /api/finanzas/solicitudes-giro/liquidaciones/{id}/devoluciones - Debe listar devoluciones")
    void listarDevoluciones_LiquidacionExistente_DebeRetornarLista() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro/liquidaciones/{liquidacionId}/devoluciones", 1L)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray());
    }

    @Test
    @Disabled("Endpoint GET /devoluciones/pendientes no implementado aún en SolicitudGiroController")
    @DisplayName("GET /api/finanzas/solicitudes-giro/devoluciones/pendientes - Debe listar devoluciones pendientes")
    void listarDevolucionesPendientes_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/solicitudes-giro/devoluciones/pendientes")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /api/finanzas/solicitudes-giro - Debe rechazar con datos inválidos")
    void crear_SolicitudConDatosInvalidos_DebeRetornarError() throws Exception {
        String request = """
            {
                "monto": -500.00
            }
            """;

        performWithTenant(post("/api/finanzas/solicitudes-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(request))
                .andExpect(status().isBadRequest());
    }
}