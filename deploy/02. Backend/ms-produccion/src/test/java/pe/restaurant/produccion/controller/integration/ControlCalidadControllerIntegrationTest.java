package pe.restaurant.produccion.controller.integration;

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
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.produccion.dto.request.ControlCalidadRequest;

import java.time.LocalDate;

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
@DisplayName("Pruebas de Integracion — ControlCalidadController")
class ControlCalidadControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;

    private final String authToken = "Bearer mock-token";

    @Test
    @DisplayName("GET /api/produccion/controles-calidad -> retorna lista paginada")
    void listar_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/produccion/controles-calidad")
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /api/produccion/controles-calidad -> crea y retorna 201")
    void crear_conDatosValidos_retornaCreated() throws Exception {
        ControlCalidadRequest request = new ControlCalidadRequest();
        request.setFecha(LocalDate.now());
        request.setResultado("APROBADO");
        request.setObservaciones("Control IT test");

        mockMvc.perform(post("/api/produccion/controles-calidad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @DisplayName("POST con resultado invalido -> retorna 422")
    void crear_cuandoResultadoInvalido_retornaUnprocessable() throws Exception {
        ControlCalidadRequest request = new ControlCalidadRequest();
        request.setFecha(LocalDate.now());
        request.setResultado("INVALIDO");

        mockMvc.perform(post("/api/produccion/controles-calidad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/produccion/controles-calidad/{id} con ID inexistente -> 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/produccion/controles-calidad/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }
}
