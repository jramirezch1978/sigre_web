package com.sigre.produccion.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.dto.request.OtTipoRequest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integracion — OtTipoController")
class OtTipoControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;

    private String authToken = "Bearer mock-token";

    // ==== CREATE ====

    @Test
    @DisplayName("POST /api/produccion/ot-tipos -> crea y retorna 201")
    void crear_conDatosValidos_retornaCreated() throws Exception {
        OtTipoRequest request = ProduccionTestFixtures.otTipoRequest();
        String body = objectMapper.writeValueAsString(request);

        mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.codigo").value(request.getCodigo()));
    }

    @Test
    @DisplayName("POST /api/produccion/ot-tipos -> codigo duplicado retorna 409")
    void crear_cuandoCodigoDuplicado_retornaConflict() throws Exception {
        OtTipoRequest req1 = ProduccionTestFixtures.otTipoRequest();

        mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(req1)))
            .andExpect(status().isCreated());

        mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(req1)))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== READ ====

    @Test
    @DisplayName("GET /api/produccion/ot-tipos -> retorna lista paginada")
    void listar_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/produccion/ot-tipos")
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/produccion/ot-tipos/{id} con ID existente -> retorna OK")
    void obtener_conIdExistente_retornaOk() throws Exception {
        OtTipoRequest request = ProduccionTestFixtures.otTipoRequest();
        String createBody = objectMapper.writeValueAsString(request);

        String response = mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/produccion/ot-tipos/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("GET /api/produccion/ot-tipos/{id} con ID inexistente -> retorna 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/produccion/ot-tipos/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== UPDATE ====

    @Test
    @DisplayName("PUT /api/produccion/ot-tipos/{id} -> actualiza y retorna OK")
    void actualizar_conDatosValidos_retornaOk() throws Exception {
        OtTipoRequest request = ProduccionTestFixtures.otTipoRequest();
        String createBody = objectMapper.writeValueAsString(request);

        String response = mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        request.setNombre("Actualizado");
        String updateBody = objectMapper.writeValueAsString(request);

        mockMvc.perform(put("/api/produccion/ot-tipos/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.nombre").value("Actualizado"));
    }

    // ==== ACTIVATE / DEACTIVATE ====

    @Test
    @DisplayName("PATCH desactivar/activar -> cambia estado")
    void desactivarYActivar_cambiaEstado() throws Exception {
        OtTipoRequest request = ProduccionTestFixtures.otTipoRequest();
        String createBody = objectMapper.writeValueAsString(request);

        String response = mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/produccion/ot-tipos/{id}/desactivar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.flagEstado").value("0"));

        mockMvc.perform(patch("/api/produccion/ot-tipos/{id}/activar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    // ==== DELETE ====

    @Test
    @DisplayName("DELETE /api/produccion/ot-tipos/{id} sin OTs -> desactiva (baja logica)")
    void eliminar_sinOTsAsociadas_desactiva() throws Exception {
        OtTipoRequest request = ProduccionTestFixtures.otTipoRequest();
        String createBody = objectMapper.writeValueAsString(request);

        String response = mockMvc.perform(post("/api/produccion/ot-tipos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(delete("/api/produccion/ot-tipos/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }
}
