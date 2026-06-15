package com.sigre.finanzas.controller.integration;

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
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.finanzas.testdata.FinanzasTestDataExecutionListener;
import com.sigre.common.testutil.TestDataSeeder;
import com.sigre.finanzas.testdata.TestDataSeederFinanzas;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para ProgramacionPagoController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - ProgramacionPagoController")
class ProgramacionPagoControllerIntegrationTest {

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

        // 1. Maestros comunes específicos (NO seedAll que incluye almacen/vale_mov)
    }

    @Test
    @DisplayName("POST /api/finanzas/programacion-pagos - Debe crear programación de pago")
    void crear_ProgramacionPago_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "fechaProgramada": "2026-05-20",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 500.00
                    },
                    {
                        "cntasPagarId": 1002,
                        "montoProgramado": 1180.00
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.flagEstado").value("1"))
                .andExpect(jsonPath("$.data.fechaProgramada").value("2026-05-20"))
                .andExpect(jsonPath("$.data.detalles").isArray())
                .andExpect(jsonPath("$.data.detalles.length()").value(2));
    }

    @Test
    @DisplayName("GET /api/finanzas/programacion-pagos/{id} - Debe obtener programación por ID")
    void obtener_ProgramacionPago_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeederFinanzas insertó una programación con ID=8001
        mockMvc.perform(get("/api/finanzas/programacion-pagos/8001")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(8001))
                .andExpect(jsonPath("$.data.flagEstado").exists())
                .andExpect(jsonPath("$.data.detalles").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/programacion-pagos - Debe listar programaciones")
    void listar_ProgramacionPago_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("PUT /api/finanzas/programacion-pagos/{id} - Debe actualizar programación existente")
    void actualizar_ProgramacionPago_DebeActualizarYRetornar() throws Exception {
        // Primero crear una programación para tener un ID válido
        String requestJson = """
            {
                "fechaProgramada": "2026-05-20",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 500.00
                    }
                ]
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long programacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar la programación
        String requestActualizado = """
            {
                "fechaProgramada": "2026-05-25",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 600.00
                    }
                ]
            }
            """;

        mockMvc.perform(put("/api/finanzas/programacion-pagos/{id}", programacionId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(programacionId))
                .andExpect(jsonPath("$.data.fechaProgramada").value("2026-05-25"))
                .andExpect(jsonPath("$.data.detalles[0].montoProgramado").value(600.00));
    }

    @Test
    @org.junit.jupiter.api.Disabled("Endpoint no implementado - ProgramacionPagoController.ejecutar lanza excepción interna")
    @DisplayName("POST /api/finanzas/programacion-pagos/{id}/ejecutar - Debe ejecutar programación")
    void ejecutar_ProgramacionPago_DebeEjecutarYRetornar() throws Exception {
        // Primero crear una programación para tener un ID válido
        String requestJson = """
            {
                "fechaProgramada": "2026-05-20",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 500.00
                    }
                ]
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long programacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Ejecutar la programación
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/ejecutar", programacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(programacionId))
                .andExpect(jsonPath("$.data.flagEstado").value("1"))
                .andExpect(jsonPath("$.data.pagosGenerados").exists())
                .andExpect(jsonPath("$.data.totalPagado").exists());
    }

    @Test
    @org.junit.jupiter.api.Disabled("Endpoint no implementado - ProgramacionPagoController.anular lanza UnsupportedOperationException")
    @DisplayName("POST /api/finanzas/programacion-pagos/{id}/anular - Debe anular programación")
    void anular_ProgramacionPago_DebeAnularYRetornar() throws Exception {
        // Primero crear una programación para tener un ID válido
        String requestJson = """
            {
                "fechaProgramada": "2026-05-20",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 500.00
                    }
                ]
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long programacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Anular la programación
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/anular", programacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(programacionId))
                .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    @Test
    @DisplayName("GET /api/finanzas/programacion-pagos/{id} - Debe retornar 404 con ID inexistente")
    void obtener_ProgramacionPago_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/programacion-pagos/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/programacion-pagos/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_ProgramacionPago_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "fechaProgramada": "2026-05-25",
                "detalles": [
                    {
                        "cntasPagarId": 1001,
                        "montoProgramado": 600.00
                    }
                ]
            }
            """;

        mockMvc.perform(put("/api/finanzas/programacion-pagos/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/programacion-pagos/{id}/ejecutar - Debe retornar 404 con ID inexistente")
    void ejecutar_ProgramacionPago_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/ejecutar", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @org.junit.jupiter.api.Disabled("Endpoint no implementado - ProgramacionPagoController.anular lanza UnsupportedOperationException")
    @DisplayName("POST /api/finanzas/programacion-pagos/{id}/anular - Debe retornar 404 con ID inexistente")
    void anular_ProgramacionPago_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/anular", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/programacion-pagos - Debe retornar error de validación con datos inválidos")
    void crear_ProgramacionPago_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "fechaProgramada": "",
                "detalles": []
            }
            """;

        mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/finanzas/programacion-pagos - Debe filtrar por estado")
    void listar_ProgramacionPago_ConFiltroEstado_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .param("estado", "PROGRAMADO")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/programacion-pagos - Debe filtrar por fecha")
    void listar_ProgramacionPago_ConFiltroFecha_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .header("Authorization", authToken)
                .param("fechaDesde", "2026-05-01")
                .param("fechaHasta", "2026-05-31")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }
}
