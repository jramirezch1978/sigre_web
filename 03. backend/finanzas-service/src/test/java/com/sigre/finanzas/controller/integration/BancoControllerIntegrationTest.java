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
 * Tests de integración para BancoController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - BancoController")
class BancoControllerIntegrationTest {

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

        // Maestros comunes (TestDataSeeder ya tiene seedBanco)
        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedBanco();
    }

    @Test
    @DisplayName("GET /api/finanzas/bancos - Debe listar bancos")
    void listar_Bancos_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/bancos/{id} - Debe obtener banco por ID")
    void obtener_Banco_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeeder.seedBanco() insertó un banco con ID=1
        mockMvc.perform(get("/api/finanzas/bancos/1")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.nomBanco").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/bancos - Debe crear banco")
    void crear_Banco_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "codBanco": "999",
                "nomBanco": "Banco de Prueba",
                "codBancoSunat": "99"
            }
            """;

        mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nomBanco").value("Banco de Prueba"))
                .andExpect(jsonPath("$.data.codBanco").value("999"));
    }

    @Test
    @DisplayName("PUT /api/finanzas/bancos/{id} - Debe actualizar banco existente")
    void actualizar_Banco_DebeActualizarYRetornar() throws Exception {
        // Primero crear un banco para tener un ID válido
        String requestJson = """
            {
                "codBanco": "998",
                "nomBanco": "Banco Original",
                "codBancoSunat": "98"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long bancoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar el banco
        String requestActualizado = """
            {
                "codBanco": "998",
                "nomBanco": "Banco Actualizado",
                "codBancoSunat": "98"
            }
            """;

        mockMvc.perform(put("/api/finanzas/bancos/{id}", bancoId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(bancoId))
                .andExpect(jsonPath("$.data.nomBanco").value("Banco Actualizado"));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/bancos/{id} - Debe eliminar banco")
    void eliminar_Banco_DebeEliminarYRetornar() throws Exception {
        // Primero crear un banco para tener un ID válido
        String requestJson = """
            {
                "codBanco": "997",
                "nomBanco": "Banco a Eliminar",
                "codBancoSunat": "97"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long bancoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Eliminar el banco
        mockMvc.perform(delete("/api/finanzas/bancos/{id}", bancoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/bancos/{id}/activar - Debe activar banco")
    void activar_Banco_DebeActivarYRetornar() throws Exception {
        // Primero crear un banco para tener un ID válido
        String requestJson = """
            {
                "codBanco": "996",
                "nomBanco": "Banco a Activar",
                "codBancoSunat": "96"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long bancoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Activar el banco
        mockMvc.perform(patch("/api/finanzas/bancos/{id}/activar", bancoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(bancoId));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/bancos/{id}/desactivar - Debe desactivar banco")
    void desactivar_Banco_DebeDesactivarYRetornar() throws Exception {
        // Primero crear un banco para tener un ID válido
        String requestJson = """
            {
                "codBanco": "995",
                "nomBanco": "Banco a Desactivar",
                "codBancoSunat": "95"
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long bancoId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar el banco
        mockMvc.perform(patch("/api/finanzas/bancos/{id}/desactivar", bancoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(bancoId));
    }

    @Test
    @DisplayName("GET /api/finanzas/bancos/{id} - Debe retornar 404 con ID inexistente")
    void obtener_Banco_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/bancos/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/bancos/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_Banco_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "codBanco": "994",
                "nomBanco": "Banco Inexistente",
                "codBancoSunat": "94"
            }
            """;

        mockMvc.perform(put("/api/finanzas/bancos/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/bancos/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_Banco_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(delete("/api/finanzas/bancos/{id}", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/bancos - Debe retornar error de validación con datos inválidos")
    void crear_Banco_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "codBanco": "",
                "nomBanco": ""
            }
            """;

        mockMvc.perform(post("/api/finanzas/bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
