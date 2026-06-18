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
import pe.restaurant.rrhh.dto.request.GratificacionProcesarRequest;
import pe.restaurant.rrhh.dto.response.GratificacionResponse;
import pe.restaurant.rrhh.service.GratificacionService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - GratificacionController")
class GratificacionControllerTest {

    @Mock
    private GratificacionService service;

    @InjectMocks
    private GratificacionController controller;

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
    @DisplayName("POST /api/rrhh/gratificaciones/procesar -> procesa batch")
    void procesar_retornaListaProcesada() throws Exception {
        GratificacionProcesarRequest request = new GratificacionProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoGratificacionId(1L);

        when(service.procesar(any())).thenReturn(List.of(
                RrhhTestFixtures.gratificacionResponse(1L)
        ));

        mockMvc.perform(post("/api/rrhh/gratificaciones/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].id").value(1));

        verify(service).procesar(any());
    }

    @Test
    @DisplayName("GET /api/rrhh/gratificaciones -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<GratificacionResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.gratificacionResponse(1L)
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/gratificaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].id").value(1));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/gratificaciones con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<GratificacionResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.gratificacionResponse(1L)
        ));
        when(service.listar(eq(1L), eq(2026), eq(1L), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/gratificaciones")
                        .param("trabajadorId", "1")
                        .param("anio", "2026")
                        .param("periodoGratificacionId", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listar(eq(1L), eq(2026), eq(1L), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/gratificaciones/{id} -> retorna gratificación")
    void obtenerPorId_idExistente_retornaGratificacion() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.gratificacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/gratificaciones/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }
}
