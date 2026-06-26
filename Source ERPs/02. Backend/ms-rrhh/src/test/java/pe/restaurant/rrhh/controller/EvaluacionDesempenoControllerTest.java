package pe.restaurant.rrhh.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import pe.restaurant.rrhh.dto.response.EvaluacionDesempenoResponse;
import pe.restaurant.rrhh.service.EvaluacionDesempenoService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - EvaluacionDesempenoController")
class EvaluacionDesempenoControllerTest {

    @Mock
    private EvaluacionDesempenoService service;

    @InjectMocks
    private EvaluacionDesempenoController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper))
                .build();
    }

    @Test
    @DisplayName("GET /api/rrhh/evaluaciones-desempeno -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<EvaluacionDesempenoResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.evaluacionDesempenoResponse(1L)
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/evaluaciones-desempeno")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/evaluaciones-desempeno/{id} -> retorna evaluación")
    void obtenerPorId_idExistente_retornaEvaluacion() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.evaluacionDesempenoResponse(1L));

        mockMvc.perform(get("/api/rrhh/evaluaciones-desempeno/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/evaluaciones-desempeno -> crea evaluación")
    void crear_datosValidos_creaExitosamente() throws Exception {
        EvaluacionDesempenoCreateRequest request = RrhhTestFixtures.evaluacionDesempenoCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.evaluacionDesempenoResponse(1L));

        mockMvc.perform(post("/api/rrhh/evaluaciones-desempeno")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/evaluaciones-desempeno/{id} -> actualiza evaluación")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        EvaluacionDesempenoUpdateRequest request = RrhhTestFixtures.evaluacionDesempenoUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.evaluacionDesempenoResponse(1L));

        mockMvc.perform(put("/api/rrhh/evaluaciones-desempeno/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("DELETE /api/rrhh/evaluaciones-desempeno/{id} -> elimina evaluación")
    void eliminar_idExistente_eliminaExitosamente() throws Exception {
        doNothing().when(service).eliminar(1L);

        mockMvc.perform(delete("/api/rrhh/evaluaciones-desempeno/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).eliminar(1L);
    }
}
