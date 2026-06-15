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

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para AutorizadorGiroController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - AutorizadorGiroController")
class AutorizadorGiroControllerIntegrationTest {

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

        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedMoneda();
        testDataSeeder.seedSucursal();
        testDataSeeder.seedEntidadContribuyente();
        testDataSeeder.seedCentrosCosto();
    }

    @Test
    @DisplayName("GET /api/finanzas/autorizadores-giro - Debe listar autorizadores paginado")
    void listar_Autorizadores_DebeRetornarPaginado() throws Exception {
        mockMvc.perform(get("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/autorizadores-giro/{id} - Debe retornar 404 con ID inexistente")
    void obtener_Autorizador_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/99999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/autorizadores-giro - Debe crear autorizador")
    void crear_Autorizador_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "centrosCostoId": 1,
                "activo": true
            }
            """;

        mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.centrosCostoId").value(1));
    }

    @Test
    @DisplayName("POST /api/finanzas/autorizadores-giro - Debe crear y luego obtener")
    void crearYObtener_Autorizador_DebeRetornarDatos() throws Exception {
        String requestJson = """
            {
                "centrosCostoId": 1,
                "activo": true
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/finanzas/autorizadores-giro/" + id)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.centrosCostoId").value(1));
    }

    @Test
    @DisplayName("PUT /api/finanzas/autorizadores-giro/{id} - Debe actualizar autorizador")
    void actualizar_Autorizador_DebeActualizarYRetornar() throws Exception {
        String createRequest = """
            {
                "centrosCostoId": 1,
                "activo": true
            }
            """;

        String createResponse = mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createRequest))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        String updateRequest = """
            {
                "centrosCostoId": 1,
                "activo": false
            }
            """;

        mockMvc.perform(put("/api/finanzas/autorizadores-giro/" + id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("PUT /api/finanzas/autorizadores-giro/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_Autorizador_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "centrosCostoId": 1,
                "activo": false
            }
            """;

        mockMvc.perform(put("/api/finanzas/autorizadores-giro/99999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/autorizadores-giro/{id} - Debe eliminar autorizador")
    void eliminar_Autorizador_DebeEliminarYRetornar() throws Exception {
        String createRequest = """
            {
                "centrosCostoId": 1,
                "activo": true
            }
            """;

        String createResponse = mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createRequest))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        mockMvc.perform(delete("/api/finanzas/autorizadores-giro/" + id)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/autorizadores-giro/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_Autorizador_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(delete("/api/finanzas/autorizadores-giro/99999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/autorizadores-giro/{id}/activar - Debe activar autorizador")
    void activar_Autorizador_DebeActivarYRetornar() throws Exception {
        String createRequest = """
            {
                "centrosCostoId": 1,
                "activo": false
            }
            """;

        String createResponse = mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createRequest))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/finanzas/autorizadores-giro/" + id + "/activar")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/autorizadores-giro/{id}/desactivar - Debe desactivar autorizador")
    void desactivar_Autorizador_DebeDesactivarYRetornar() throws Exception {
        String createRequest = """
            {
                "centrosCostoId": 1,
                "activo": true
            }
            """;

        String createResponse = mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createRequest))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/finanzas/autorizadores-giro/" + id + "/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("GET /api/finanzas/autorizadores-giro/centro-costo/{id} - Debe listar por centro de costo")
    void listar_PorCentroCosto_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/centro-costo/1")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray());
    }

    @Test
    @DisplayName("GET /api/finanzas/autorizadores-giro/centro-costo/{id}/activos - Debe listar activos por centro de costo")
    void listarActivos_PorCentroCosto_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/centro-costo/1/activos")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray());
    }

    @Test
    @DisplayName("POST /api/finanzas/autorizadores-giro - Debe retornar error de validación con datos inválidos")
    void crear_Autorizador_ConDatosInvalidos_DebeRetornarError() throws Exception {
        String requestInvalido = """
            {
                "centrosCostoId": null
            }
            """;

        mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/finanzas/autorizadores-giro - Debe validar paginación")
    void listar_ConPaginacion_DebeRetornarPaginado() throws Exception {
        mockMvc.perform(get("/api/finanzas/autorizadores-giro")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.size").value(2))
                .andExpect(jsonPath("$.data.page.number").value(0));
    }
}