package com.sigre.produccion.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import com.sigre.produccion.dto.request.EjecutorRequest;

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
@DisplayName("Pruebas de Integracion — EjecutorController")
class EjecutorControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;

    private final String authToken = "Bearer mock-token";

    @Test
    @DisplayName("GET /api/produccion/ejecutores -> retorna lista paginada")
    void listar_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/produccion/ejecutores")
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /api/produccion/ejecutores -> crea y retorna 201")
    void crear_conDatosValidos_retornaCreated() throws Exception {
        EjecutorRequest request = new EjecutorRequest();
        request.setCodigo("EJEC-IT-" + System.nanoTime() % 100000);
        request.setNombre("Ejecutor IT Test");
        request.setFlagExterno("0");

        mockMvc.perform(post("/api/produccion/ejecutores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.codigo").value(request.getCodigo()));
    }

    @Test
    @DisplayName("POST con codigo duplicado -> retorna 409")
    void crear_cuandoCodigoDuplicado_retornaConflict() throws Exception {
        EjecutorRequest request = new EjecutorRequest();
        request.setCodigo("EJEC-DUP-" + System.nanoTime() % 100000);
        request.setNombre("Ejecutor Duplicado");
        request.setFlagExterno("0");

        mockMvc.perform(post("/api/produccion/ejecutores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated());

        mockMvc.perform(post("/api/produccion/ejecutores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/produccion/ejecutores/{id} con ID inexistente -> 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/produccion/ejecutores/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }
}
