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
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.testdata.FinanzasTestDataExecutionListener;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.finanzas.testdata.TestDataSeederFinanzas;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {
        TenantContextTestExecutionListener.class,
        FinanzasTestDataExecutionListener.class
    },
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - ConciliacionBancariaController")
class ConciliacionBancariaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        authToken = "Bearer mock-token";
    }

    @Test
    @DisplayName("GET /api/finanzas/conciliaciones-bancarias - Debe listar paginado")
    void listar_Conciliaciones_DebeRetornarPaginado() throws Exception {
        mockMvc.perform(get("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/conciliaciones-bancarias/{id} - Debe retornar 404 con ID inexistente")
    void obtener_Conciliacion_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/conciliaciones-bancarias/99999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/conciliaciones-bancarias - Debe crear conciliación")
    void crear_Conciliacion_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "bancoCntaId": 1,
                "periodoAnio": 2025,
                "periodoMes": 1,
                "saldoBanco": 10000.00,
                "saldoLibros": 10000.00,
                "detalles": [
                    {
                        "cajaBancosId": 2001,
                        "conciliado": false,
                        "observacion": "Partida pendiente"
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.bancoCntaId").value(1));
    }

    @Test
    @DisplayName("GET /api/finanzas/conciliaciones-bancarias - Debe filtrar por cuenta bancaria")
    void listar_ConFiltroCuenta_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .param("bancoCntaId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/conciliaciones-bancarias - Debe filtrar por periodo")
    void listar_ConFiltroPeriodo_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .param("periodoAnio", "2026")
                .param("periodoMes", "5")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/conciliaciones-bancarias - Debe validar paginación")
    void listar_ConPaginacion_DebeRetornarPaginado() throws Exception {
        mockMvc.perform(get("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.page.size").value(5))
                .andExpect(jsonPath("$.data.page.number").value(0));
    }

    @Test
    @DisplayName("POST /api/finanzas/conciliaciones-bancarias - Debe retornar error con datos inválidos")
    void crear_Conciliacion_ConDatosInvalidos_DebeRetornarError() throws Exception {
        String requestInvalido = """
            {
                "bancoCntaId": null,
                "periodoAnio": null,
                "periodoMes": null,
                "detalles": []
            }
            """;

        mockMvc.perform(post("/api/finanzas/conciliaciones-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}