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
 * Tests de integración para ConceptoFinancieroController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - ConceptoFinancieroController")
class ConceptoFinancieroControllerIntegrationTest {

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

        // Maestros comunes (TestDataSeeder ya tiene seedConceptoFinanciero)
        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedConceptoFinanciero();
    }

    @Test
    @DisplayName("GET /api/finanzas/conceptos-financieros - Debe listar conceptos financieros")
    void listar_ConceptosFinancieros_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/conceptos-financieros/{id} - Debe obtener concepto financiero por ID")
    void obtener_ConceptoFinanciero_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeeder.seedConceptoFinanciero() insertó un concepto con ID=1
        mockMvc.perform(get("/api/finanzas/conceptos-financieros/1")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.nombre").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/conceptos-financieros - Debe crear concepto financiero")
    void crear_ConceptoFinanciero_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "Concepto de Prueba",
                "codigo": "TEST001",
                "descripcion": "Concepto financiero de prueba"
            }
            """;

        mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombre").value("Concepto de Prueba"))
                .andExpect(jsonPath("$.data.codigo").value("TEST001"));
    }

    @Test
    @DisplayName("PUT /api/finanzas/conceptos-financieros/{id} - Debe actualizar concepto financiero existente")
    void actualizar_ConceptoFinanciero_DebeActualizarYRetornar() throws Exception {
        // Primero crear un concepto financiero para tener un ID válido
        String requestJson = """
            {
                "nombre": "Concepto Original",
                "codigo": "TEST002",
                "descripcion": "Concepto original"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long conceptoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar el concepto financiero
        String requestActualizado = """
            {
                "nombre": "Concepto Actualizado",
                "codigo": "TEST002",
                "descripcion": "Concepto actualizado"
            }
            """;

        mockMvc.perform(put("/api/finanzas/conceptos-financieros/{id}", conceptoId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(conceptoId))
                .andExpect(jsonPath("$.data.nombre").value("Concepto Actualizado"));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/conceptos-financieros/{id} - Debe eliminar concepto financiero")
    void eliminar_ConceptoFinanciero_DebeEliminarYRetornar() throws Exception {
        // Primero crear un concepto financiero para tener un ID válido
        String requestJson = """
            {
                "nombre": "Concepto a Eliminar",
                "codigo": "TEST003",
                "descripcion": "Concepto a eliminar"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long conceptoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Eliminar el concepto financiero
        mockMvc.perform(delete("/api/finanzas/conceptos-financieros/{id}", conceptoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/conceptos-financieros/{id}/activar - Debe activar concepto financiero")
    void activar_ConceptoFinanciero_DebeActivarYRetornar() throws Exception {
        // Primero crear un concepto financiero para tener un ID válido
        String requestJson = """
            {
                "nombre": "Concepto a Activar",
                "codigo": "TEST004",
                "descripcion": "Concepto a activar"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long conceptoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Activar el concepto financiero
        mockMvc.perform(patch("/api/finanzas/conceptos-financieros/{id}/activar", conceptoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(conceptoId));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/conceptos-financieros/{id}/desactivar - Debe desactivar concepto financiero")
    void desactivar_ConceptoFinanciero_DebeDesactivarYRetornar() throws Exception {
        // Primero crear un concepto financiero para tener un ID válido
        String requestJson = """
            {
                "nombre": "Concepto a Desactivar",
                "codigo": "TEST005",
                "descripcion": "Concepto a desactivar"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long conceptoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar el concepto financiero
        mockMvc.perform(patch("/api/finanzas/conceptos-financieros/{id}/desactivar", conceptoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(conceptoId));
    }

    @Test
    @DisplayName("GET /api/finanzas/conceptos-financieros/{id} - Debe retornar 404 con ID inexistente")
    void obtener_ConceptoFinanciero_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/conceptos-financieros/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/conceptos-financieros/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_ConceptoFinanciero_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "Concepto Inexistente",
                "codigo": "TEST006",
                "descripcion": "Concepto inexistente"
            }
            """;

        mockMvc.perform(put("/api/finanzas/conceptos-financieros/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/conceptos-financieros/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_ConceptoFinanciero_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(delete("/api/finanzas/conceptos-financieros/{id}", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/conceptos-financieros - Debe retornar error de validación con datos inválidos")
    void crear_ConceptoFinanciero_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "nombre": "",
                "codigo": "",
                "descripcion": ""
            }
            """;

        mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
