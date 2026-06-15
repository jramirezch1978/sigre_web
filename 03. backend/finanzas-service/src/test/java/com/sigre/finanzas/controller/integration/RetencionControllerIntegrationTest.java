package com.sigre.finanzas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
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
import com.sigre.finanzas.testdata.TestDataSeederFinanzas;
import com.sigre.finanzas.testutil.TestDataFactory;

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
@DisplayName("Pruebas de Integración - RetencionController")
class RetencionControllerIntegrationTest {

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
    private Long retencionId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";

        Mockito.when(coreMaestrosClient.obtenerEntidadPorId(org.mockito.ArgumentMatchers.anyLong())).thenReturn(TestDataFactory.mockEntidadResponse());


        retencionId = jdbc.queryForObject(
            "INSERT INTO finanzas.retencion (cntas_pagar_id, nro_certificado, fecha_emision, proveedor_id, importe_doc, saldo_sol, saldo_dol, nro_reg_caja_ban, fec_pago, created_by, fec_creacion, flag_estado) VALUES (1001, 'RET-SEED', CURRENT_DATE, 1, 1000.00, 1000.00, 0.00, 2001, CURRENT_DATE, 1, NOW(), '0') RETURNING id",
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
    @DisplayName("GET /api/finanzas/retenciones - Debe listar retenciones paginado")
    void listar_Retenciones_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/retenciones - Debe filtrar por número de certificado")
    void listar_ConFiltroNroCertificado_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .param("nroCertificado", "RET-SEED")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/retenciones - Debe filtrar por cuentas por pagar")
    void listar_ConFiltroCntasPagar_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .param("cntasPagarId", "1001")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/retenciones - Debe filtrar por estado")
    void listar_ConFiltroEstado_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .param("flagEstado", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/retenciones/{id} - Debe obtener retención por ID")
    void obtenerPorId_RetencionExistente_DebeRetornar() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones/{id}", retencionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/finanzas/retenciones/{id} - Debe retornar 404 para ID inexistente")
    void obtenerPorId_RetencionInexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/retenciones/{id}", 99999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/retenciones - Debe crear retención")
    void crear_Retencion_DebeCrearYRetornar() throws Exception {
        performWithTenant(post("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearRetencionRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @DisplayName("PUT /api/finanzas/retenciones/{id} - Debe actualizar retención")
    void actualizar_Retencion_DebeActualizarYRetornar() throws Exception {
        String createResponse = performWithTenant(post("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearRetencionRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        Long nuevaId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        performWithTenant(put("/api/finanzas/retenciones/{id}", nuevaId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearRetencionRequestParaActualizar())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/retenciones/{id}/activar - Debe activar retención")
    void activar_Retencion_DebeActivarYRetornar() throws Exception {
        performWithTenant(patch("/api/finanzas/retenciones/{id}/activar", retencionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @org.junit.jupiter.api.Disabled("Requiere seed con flag_estado='1' (activo)")
    @DisplayName("PATCH /api/finanzas/retenciones/{id}/desactivar - Debe desactivar retención")
    void desactivar_Retencion_DebeDesactivarYRetornar() throws Exception {
        performWithTenant(patch("/api/finanzas/retenciones/{id}/desactivar", retencionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/finanzas/retenciones - Debe rechazar con datos inválidos")
    void crear_RetencionConDatosInvalidos_DebeRetornarError() throws Exception {
        String request = """
            {
                "importeDoc": -100.00
            }
            """;

        performWithTenant(post("/api/finanzas/retenciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(request))
                .andExpect(status().isBadRequest());
    }
}