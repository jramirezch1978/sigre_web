package pe.restaurant.finanzas.controller.integration;

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
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.testdata.FinanzasTestDataExecutionListener;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.AsientoContableResponse;
import pe.restaurant.finanzas.testdata.TestDataSeederFinanzas;
import pe.restaurant.finanzas.testutil.TestDataFactory;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, FinanzasTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class CntasPagarControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    @MockBean
    private CoreMaestrosClient coreMaestrosClient;

    @MockBean
    private ContabilidadClient contabilidadClient;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;
    private Long cxpId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";

        AsientoContableResponse asientoResponse = new AsientoContableResponse();
        asientoResponse.setId(1L);
        pe.restaurant.finanzas.dto.response.GenerarAsientoResponse generarResponse = new pe.restaurant.finanzas.dto.response.GenerarAsientoResponse();
        generarResponse.setAsientoId(1L);
        Mockito.when(contabilidadClient.generarAsientoCarteraPagos(any())).thenReturn(ApiResponse.ok(generarResponse));
        Mockito.when(contabilidadClient.anularAsiento(any())).thenReturn(ApiResponse.ok(asientoResponse));
        Mockito.when(coreMaestrosClient.obtenerEntidadPorId(anyLong())).thenReturn(TestDataFactory.mockEntidadResponse());
        Mockito.when(coreMaestrosClient.obtenerDocTipoPorId(anyLong())).thenReturn(TestDataFactory.mockDocTipoResponse());
        Mockito.when(coreMaestrosClient.obtenerMonedaPorId(anyLong())).thenReturn(TestDataFactory.mockMonedaResponse());


        cxpId = jdbc.queryForObject(
            "INSERT INTO finanzas.cntas_pagar (sucursal_id, proveedor_id, doc_tipo_id, serie, numero, fecha_emision, fecha_vencimiento, moneda_id, total, saldo, created_by, fec_creacion, flag_estado) VALUES (1, 1, 1, 'F001', 'CXP-SEED', CURRENT_DATE - 30, CURRENT_DATE + 15, 1, 1500.00, 1500.00, 1, NOW(), '1') RETURNING id",
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
    @DisplayName("GET /api/finanzas/cuentas-pagar - Debe listar paginado")
    void listar_DebeRetornarPaginado() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-pagar - Debe filtrar por proveedor")
    void listar_ConFiltroProveedor_DebeRetornarFiltrado() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .param("proveedorId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-pagar/{id} - Debe obtener por ID")
    void obtenerPorId_Existente_DebeRetornar() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-pagar/{id}", cxpId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cxpId));
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-pagar/{id} - Debe retornar 404 para ID inexistente")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-pagar/{id}", 99999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-pagar - Debe crear cuenta por pagar")
    void crear_DebeCrearYRetornar() throws Exception {
        performWithTenant(post("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(TestDataFactory.crearCntasPagarRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-pagar - Debe rechazar con datos inválidos")
    void crear_ConDatosInvalidos_DebeRetornarError() throws Exception {
        String request = """
            {"total": -100.00, "detalles": []}
            """;
        performWithTenant(post("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(request))
                .andExpect(status().isBadRequest());
    }
}