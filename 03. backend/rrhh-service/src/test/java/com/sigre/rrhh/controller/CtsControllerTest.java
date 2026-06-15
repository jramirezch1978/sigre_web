package com.sigre.rrhh.controller;

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
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.CtsProcesarRequest;
import com.sigre.rrhh.dto.response.CtsResponse;
import com.sigre.rrhh.service.CtsService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CtsController")
class CtsControllerTest {

    @Mock
    private CtsService service;

    @InjectMocks
    private CtsController controller;

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
    @DisplayName("POST /api/rrhh/cts/procesar -> procesa batch")
    void procesar_retornaListaProcesada() throws Exception {
        CtsProcesarRequest request = new CtsProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoCtsId(1L);

        when(service.procesar(any())).thenReturn(List.of(
                RrhhTestFixtures.ctsResponse(1L)
        ));

        mockMvc.perform(post("/api/rrhh/cts/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].id").value(1));

        verify(service).procesar(any());
    }

    @Test
    @DisplayName("GET /api/rrhh/cts -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<CtsResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.ctsResponse(1L)
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/cts")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].id").value(1));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/cts con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<CtsResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.ctsResponse(1L)
        ));
        when(service.listar(eq(1L), eq(2026), eq(1L), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/cts")
                        .param("trabajadorId", "1")
                        .param("anio", "2026")
                        .param("periodoCtsId", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listar(eq(1L), eq(2026), eq(1L), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/cts/{id} -> retorna CTS")
    void obtenerPorId_idExistente_retornaCts() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.ctsResponse(1L));

        mockMvc.perform(get("/api/rrhh/cts/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }
}
