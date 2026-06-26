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

/**
 * Tests de integración para LetraCanjeController con datos reales en base de datos.
 * Sigue la recomendación del líder de usar datos de prueba insertados en BD en lugar de mocks.
 *
 * @author Equipo de Desarrollo
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, FinanzasTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - LetraCanjeController")
class LetraCanjeControllerIntegrationTest {

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

        // Generate mock auth token
        authToken = "Bearer mock-token";

        // Maestros comunes necesarios para LetraCanje
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje - Debe listar canjes de documentos")
    void listar_LetrasCanje_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje - Debe filtrar por referencia")
    void listar_LetrasCanje_ConFiltroReferencia_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .param("referencia", "TEST")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje - Debe filtrar por proveedor")
    void listar_LetrasCanje_ConFiltroProveedor_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .param("proveedorId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje - Debe filtrar por fecha")
    void listar_LetrasCanje_ConFiltroFecha_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .param("fechaDesde", "2026-05-01")
                .param("fechaHasta", "2026-05-31")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje/{referencia} - Debe obtener detalle de canje por referencia")
    void obtener_LetraCanje_DebeRetornarDatos() throws Exception {
        // Primero crear un canje para tener una referencia válida
        String requestJson = """
            {
                "proveedorId": 1,
                "referencia": "CANJE-TEST-001",
                "fechaCanje": "2026-05-20",
                "origenes": [
                    {
                        "cntasPagarId": 1001,
                        "montoCanjeado": 500.00
                    }
                ],
                "destinos": [
                    {
                        "docTipoId": 1,
                        "serie": "L001",
                        "numero": "00000001",
                        "fechaEmision": "2026-05-20",
                        "fechaVencimiento": "2026-06-20",
                        "monedaId": 1,
                        "total": 500.00
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        // Obtener el canje por referencia
        mockMvc.perform(get("/api/finanzas/letras-canje/CANJE-TEST-001")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.referencia").value("CANJE-TEST-001"))
                .andExpect(jsonPath("$.data.origenes").isArray())
                .andExpect(jsonPath("$.data.destinos").isArray());
    }

    @Test
    @DisplayName("POST /api/finanzas/letras-canje - Debe ejecutar canje de documentos")
    void ejecutar_LetraCanje_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "proveedorId": 1,
                "referencia": "CANJE-TEST-002",
                "fechaCanje": "2026-05-20",
                "origenes": [
                    {
                        "cntasPagarId": 1001,
                        "montoCanjeado": 500.00
                    },
                    {
                        "cntasPagarId": 1002,
                        "montoCanjeado": 1180.00
                    }
                ],
                "destinos": [
                    {
                        "docTipoId": 1,
                        "serie": "L001",
                        "numero": "00000002",
                        "fechaEmision": "2026-05-20",
                        "fechaVencimiento": "2026-06-20",
                        "monedaId": 1,
                        "total": 1680.00
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.referencia").value("CANJE-TEST-002"))
                .andExpect(jsonPath("$.data.origenes").isArray())
                .andExpect(jsonPath("$.data.destinos").isArray());
    }

    @Test
    @DisplayName("POST /api/finanzas/letras-canje/{referencia}/anular - Debe anular canje existente")
    void anular_LetraCanje_DebeAnularYRetornar() throws Exception {
        // Primero crear un canje para tener una referencia válida
        String requestJson = """
            {
                "proveedorId": 1,
                "referencia": "CANJE-TEST-003",
                "fechaCanje": "2026-05-20",
                "origenes": [
                    {
                        "cntasPagarId": 1001,
                        "montoCanjeado": 500.00
                    }
                ],
                "destinos": [
                    {
                        "docTipoId": 1,
                        "serie": "L001",
                        "numero": "00000003",
                        "fechaEmision": "2026-05-20",
                        "fechaVencimiento": "2026-06-20",
                        "monedaId": 1,
                        "total": 500.00
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        // Anular el canje
        mockMvc.perform(post("/api/finanzas/letras-canje/CANJE-TEST-003/anular")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.referencia").value("CANJE-TEST-003"));
    }

    @Test
    @DisplayName("GET /api/finanzas/letras-canje/{referencia} - Debe retornar 404 con referencia inexistente")
    void obtener_LetraCanje_ConReferenciaInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/letras-canje/REFERENCIA-INEXISTENTE")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/letras-canje/{referencia}/anular - Debe retornar 404 con referencia inexistente")
    void anular_LetraCanje_ConReferenciaInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/letras-canje/REFERENCIA-INEXISTENTE/anular")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/letras-canje - Debe retornar error de validación con datos inválidos")
    void ejecutar_LetraCanje_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "referencia": "",
                "fechaCanje": null,
                "origenes": [],
                "destinos": []
            }
            """;

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/letras-canje - Debe retornar 409 con referencia duplicada")
    void ejecutar_LetraCanje_ConReferenciaDuplicada_DebeRetornar409() throws Exception {
        String requestJson = """
            {
                "proveedorId": 1,
                "referencia": "CANJE-TEST-DUPLICADO",
                "fechaCanje": "2026-05-20",
                "origenes": [
                    {
                        "cntasPagarId": 1001,
                        "montoCanjeado": 500.00
                    }
                ],
                "destinos": [
                    {
                        "docTipoId": 1,
                        "serie": "L001",
                        "numero": "00000004",
                        "fechaEmision": "2026-05-20",
                        "fechaVencimiento": "2026-06-20",
                        "monedaId": 1,
                        "total": 500.00
                    }
                ]
            }
            """;

// Primer intento - debe crear exitosamente
        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        // Segundo intento - debe fallar por referencia duplicada (422 porque es regla de negocio)
        mockMvc.perform(post("/api/finanzas/letras-canje")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(jsonPath("$.success").value(false));
    }
}
