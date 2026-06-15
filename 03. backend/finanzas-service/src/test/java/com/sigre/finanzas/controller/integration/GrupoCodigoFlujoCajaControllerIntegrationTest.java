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
 * Tests de integración para GrupoCodigoFlujoCajaController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - GrupoCodigoFlujoCajaController")
class GrupoCodigoFlujoCajaControllerIntegrationTest {

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
    @DisplayName("GET /api/finanzas/grupos-flujo-caja - Debe listar grupos de flujo de caja")
    void listar_GruposFlujoCaja_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/grupos-flujo-caja - Debe crear grupo de flujo de caja")
    void crear_GrupoFlujoCaja_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "GFC-TEST-001",
                "nombre": "Grupo de Flujo de Caja Prueba",
                "descripcion": "Descripción de prueba",
                "orden": 1
            }
            """;

        mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.codigo").value("GFC-TEST-001"))
                .andExpect(jsonPath("$.data.nombre").value("Grupo de Flujo de Caja Prueba"));
    }

    @Test
    @DisplayName("GET /api/finanzas/grupos-flujo-caja/{id} - Debe obtener grupo de flujo de caja por ID")
    void obtener_GrupoFlujoCaja_DebeRetornarDatos() throws Exception {
        // Primero crear un grupo para tener un ID válido
        String requestJson = """
            {
                "codigo": "GFC-TEST-002",
                "nombre": "Grupo de Flujo de Caja Test",
                "descripcion": "Descripción test",
                "orden": 2
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long grupoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Obtener el grupo por ID
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja/{id}", grupoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(grupoId))
                .andExpect(jsonPath("$.data.codigo").value("GFC-TEST-002"));
    }

    @Test
    @DisplayName("PUT /api/finanzas/grupos-flujo-caja/{id} - Debe actualizar grupo de flujo de caja existente")
    void actualizar_GrupoFlujoCaja_DebeActualizarYRetornar() throws Exception {
        // Primero crear un grupo para tener un ID válido
        String requestJson = """
            {
                "codigo": "GFC-TEST-003",
                "nombre": "Grupo Original",
                "descripcion": "Descripción original",
                "orden": 3
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long grupoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar el grupo
        String requestActualizado = """
            {
                "codigo": "GFC-TEST-003",
                "nombre": "Grupo Actualizado",
                "descripcion": "Descripción actualizada",
                "orden": 3
            }
            """;

        mockMvc.perform(put("/api/finanzas/grupos-flujo-caja/{id}", grupoId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(grupoId))
                .andExpect(jsonPath("$.data.nombre").value("Grupo Actualizado"));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/grupos-flujo-caja/{id} - Debe eliminar grupo de flujo de caja")
    void eliminar_GrupoFlujoCaja_DebeEliminarYRetornar() throws Exception {
        // Primero crear un grupo para tener un ID válido
        String requestJson = """
            {
                "codigo": "GFC-TEST-004",
                "nombre": "Grupo a Eliminar",
                "descripcion": "Descripción a eliminar",
                "orden": 4
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long grupoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Eliminar el grupo
        mockMvc.perform(delete("/api/finanzas/grupos-flujo-caja/{id}", grupoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/grupos-flujo-caja/{id}/activar - Debe activar grupo de flujo de caja")
    void activar_GrupoFlujoCaja_DebeActivarYRetornar() throws Exception {
        // Primero crear un grupo para tener un ID válido
        String requestJson = """
            {
                "codigo": "GFC-TEST-005",
                "nombre": "Grupo a Activar",
                "descripcion": "Descripción a activar",
                "orden": 5
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long grupoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Activar el grupo
        mockMvc.perform(patch("/api/finanzas/grupos-flujo-caja/{id}/activar", grupoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(grupoId));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/grupos-flujo-caja/{id}/desactivar - Debe desactivar grupo de flujo de caja")
    void desactivar_GrupoFlujoCaja_DebeDesactivarYRetornar() throws Exception {
        // Primero crear un grupo para tener un ID válido
        String requestJson = """
            {
                "codigo": "GFC-TEST-006",
                "nombre": "Grupo a Desactivar",
                "descripcion": "Descripción a desactivar",
                "orden": 6
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long grupoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar el grupo
        mockMvc.perform(patch("/api/finanzas/grupos-flujo-caja/{id}/desactivar", grupoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(grupoId));
    }

    @Test
    @DisplayName("GET /api/finanzas/grupos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void obtener_GrupoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/grupos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_GrupoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "codigo": "GFC-TEST-007",
                "nombre": "Grupo Inexistente",
                "descripcion": "Descripción inexistente",
                "orden": 7
            }
            """;

        mockMvc.perform(put("/api/finanzas/grupos-flujo-caja/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/grupos-flujo-caja/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_GrupoFlujoCaja_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(delete("/api/finanzas/grupos-flujo-caja/{id}", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/grupos-flujo-caja - Debe retornar error de validación con datos inválidos")
    void crear_GrupoFlujoCaja_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "codigo": "",
                "nombre": "",
                "descripcion": "",
                "orden": null
            }
            """;

        mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
