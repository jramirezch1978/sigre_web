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

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CodigoFlujoCajaController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - CodigoFlujoCajaController")
class CodigoFlujoCajaControllerIntegrationTest {

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
    }

    @Test
    @DisplayName("GET /api/finanzas/codigos-flujo-caja - Debe listar códigos de flujo de caja")
    void listar_CodigosFlujoCaja_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/codigos-flujo-caja - Debe crear código de flujo de caja")
    void crear_CodigoFlujoCaja_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "CFC-TEST-001",
                "nombre": "Código de Flujo de Caja Prueba",
                "tipo": "INGRESO"
            }
            """;

        mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.codigo").value("CFC-TEST-001"))
                .andExpect(jsonPath("$.data.nombre").value("Código de Flujo de Caja Prueba"));
    }

    @Test
    @DisplayName("GET /api/finanzas/codigos-flujo-caja/{id} - Debe obtener código de flujo de caja por ID")
    void obtener_CodigoFlujoCaja_DebeRetornarDatos() throws Exception {
        // Primero crear un código para tener un ID válido
        String requestJson = """
            {
                "codigo": "CFC-TEST-002",
                "nombre": "Código de Flujo de Caja Test",
                "tipo": "EGRESO"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long codigoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Obtener el código por ID
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja/{id}", codigoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(codigoId))
                .andExpect(jsonPath("$.data.codigo").value("CFC-TEST-002"));
    }

    @Test
    @DisplayName("PUT /api/finanzas/codigos-flujo-caja/{id} - Debe actualizar código de flujo de caja existente")
    void actualizar_CodigoFlujoCaja_DebeActualizarYRetornar() throws Exception {
        // Primero crear un código para tener un ID válido
        String requestJson = """
            {
                "codigo": "CFC-TEST-003",
                "nombre": "Código Original",
                "tipo": "INGRESO"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long codigoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar el código
        String requestActualizado = """
            {
                "codigo": "CFC-TEST-003",
                "nombre": "Código Actualizado",
                "tipo": "INGRESO"
            }
            """;

        mockMvc.perform(put("/api/finanzas/codigos-flujo-caja/{id}", codigoId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(codigoId))
                .andExpect(jsonPath("$.data.nombre").value("Código Actualizado"));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/codigos-flujo-caja/{id} - Debe eliminar código de flujo de caja")
    void eliminar_CodigoFlujoCaja_DebeEliminarYRetornar() throws Exception {
        // Primero crear un código para tener un ID válido
        String requestJson = """
            {
                "codigo": "CFC-TEST-004",
                "nombre": "Código a Eliminar",
                "tipo": "EGRESO"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long codigoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Eliminar el código
        mockMvc.perform(delete("/api/finanzas/codigos-flujo-caja/{id}", codigoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/codigos-flujo-caja/{id}/activar - Debe activar código de flujo de caja")
    void activar_CodigoFlujoCaja_DebeActivarYRetornar() throws Exception {
        // Primero crear un código para tener un ID válido
        String requestJson = """
            {
                "codigo": "CFC-TEST-005",
                "nombre": "Código a Activar",
                "tipo": "INGRESO"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long codigoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Activar el código
        mockMvc.perform(patch("/api/finanzas/codigos-flujo-caja/{id}/activar", codigoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(codigoId));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/codigos-flujo-caja/{id}/desactivar - Debe desactivar código de flujo de caja")
    void desactivar_CodigoFlujoCaja_DebeDesactivarYRetornar() throws Exception {
        // Primero crear un código para tener un ID válido
        String requestJson = """
            {
                "codigo": "CFC-TEST-006",
                "nombre": "Código a Desactivar",
                "tipo": "EGRESO"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long codigoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar el código
        mockMvc.perform(patch("/api/finanzas/codigos-flujo-caja/{id}/desactivar", codigoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(codigoId));
    }

    @Test
    @DisplayName("GET /api/finanzas/codigos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void obtener_CodigoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/codigos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_CodigoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "codigo": "CFC-TEST-007",
                "nombre": "Código Inexistente",
                "tipo": "INGRESO"
            }
            """;

        mockMvc.perform(put("/api/finanzas/codigos-flujo-caja/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/codigos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_CodigoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(delete("/api/finanzas/codigos-flujo-caja/{id}", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/codigos-flujo-caja - Debe retornar error de validación con datos inválidos")
    void crear_CodigoFlujoCaja_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "codigo": "",
                "nombre": "",
                "tipo": ""
            }
            """;

        mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
