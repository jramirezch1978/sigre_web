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
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;
import com.sigre.rrhh.service.ControlSubsidioService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ControlSubsidioController")
class ControlSubsidioControllerTest {

    @Mock
    private ControlSubsidioService service;

    @InjectMocks
    private ControlSubsidioController controller;

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
    @DisplayName("GET /api/rrhh/subsidios -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<ControlSubsidioResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.controlSubsidioResponse(1L)
        ));
        when(service.listar(any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/subsidios")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any());
    }

    @Test
    @DisplayName("GET /api/rrhh/subsidios/{id} -> retorna subsidio")
    void obtenerPorId_idExistente_retornaSubsidio() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.controlSubsidioResponse(1L));

        mockMvc.perform(get("/api/rrhh/subsidios/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/subsidios -> crea subsidio")
    void crear_datosValidos_creaExitosamente() throws Exception {
        ControlSubsidioCreateRequest request = RrhhTestFixtures.controlSubsidioCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.controlSubsidioResponse(1L));

        mockMvc.perform(post("/api/rrhh/subsidios")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/subsidios/{id} -> actualiza subsidio")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        ControlSubsidioUpdateRequest request = RrhhTestFixtures.controlSubsidioUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.controlSubsidioResponse(1L));

        mockMvc.perform(put("/api/rrhh/subsidios/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/subsidios/{id}/desactivar -> desactiva subsidio")
    void desactivar_idExistente_desactivaExitosamente() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.controlSubsidioResponse(1L));

        mockMvc.perform(patch("/api/rrhh/subsidios/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).desactivar(1L);
    }
}
