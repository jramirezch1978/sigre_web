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
import com.sigre.rrhh.dto.request.CapacitacionCreateRequest;
import com.sigre.rrhh.dto.request.CapacitacionTrabajadorRequest;
import com.sigre.rrhh.dto.request.CapacitacionUpdateRequest;
import com.sigre.rrhh.dto.response.CapacitacionResponse;
import com.sigre.rrhh.dto.response.CapacitacionTrabajadorResponse;
import com.sigre.rrhh.service.CapacitacionService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CapacitacionController")
class CapacitacionControllerTest {

    @Mock
    private CapacitacionService service;

    @InjectMocks
    private CapacitacionController controller;

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
    @DisplayName("GET /api/rrhh/capacitaciones -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<CapacitacionResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.capacitacionResponse(1L)
        ));
        when(service.listar(any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/capacitaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/capacitaciones/{id} -> retorna capacitación")
    void obtenerPorId_idExistente_retornaCapacitacion() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/capacitaciones/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/capacitaciones -> crea capacitación")
    void crear_datosValidos_creaExitosamente() throws Exception {
        CapacitacionCreateRequest request = RrhhTestFixtures.capacitacionCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/capacitaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/capacitaciones/{id} -> actualiza capacitación")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        CapacitacionUpdateRequest request = RrhhTestFixtures.capacitacionUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        mockMvc.perform(put("/api/rrhh/capacitaciones/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/capacitaciones/{id}/desactivar -> desactiva capacitación")
    void desactivar_idExistente_desactivaExitosamente() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        mockMvc.perform(patch("/api/rrhh/capacitaciones/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/capacitaciones/{id}/participantes -> lista participantes")
    void listarParticipantes_retornaLista() throws Exception {
        when(service.listarParticipantes(1L)).thenReturn(List.of(
                RrhhTestFixtures.capacitacionTrabajadorResponse(1L, 1L)
        ));

        mockMvc.perform(get("/api/rrhh/capacitaciones/{id}/participantes", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));

        verify(service).listarParticipantes(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/capacitaciones/{id}/participantes -> agrega participante")
    void agregarParticipante_datosValidos_agregaExitosamente() throws Exception {
        CapacitacionTrabajadorRequest request = RrhhTestFixtures.capacitacionTrabajadorRequest();
        when(service.agregarParticipante(eq(1L), any()))
                .thenReturn(RrhhTestFixtures.capacitacionTrabajadorResponse(1L, 1L));

        mockMvc.perform(post("/api/rrhh/capacitaciones/{id}/participantes", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).agregarParticipante(eq(1L), any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/capacitaciones/{id}/participantes/{trabajadorId} -> actualiza participante")
    void actualizarParticipante_datosValidos_actualizaExitosamente() throws Exception {
        CapacitacionTrabajadorRequest request = RrhhTestFixtures.capacitacionTrabajadorRequest();
        when(service.actualizarParticipante(eq(1L), eq(2L), any()))
                .thenReturn(RrhhTestFixtures.capacitacionTrabajadorResponse(1L, 1L));

        mockMvc.perform(put("/api/rrhh/capacitaciones/{id}/participantes/{trabajadorId}", 1L, 2L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).actualizarParticipante(eq(1L), eq(2L), any());
    }

    @Test
    @DisplayName("DELETE /api/rrhh/capacitaciones/{id}/participantes/{trabajadorId} -> quita participante")
    void quitarParticipante_idExistente_quitaExitosamente() throws Exception {
        doNothing().when(service).eliminarParticipante(1L, 2L);

        mockMvc.perform(delete("/api/rrhh/capacitaciones/{id}/participantes/{trabajadorId}", 1L, 2L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).eliminarParticipante(1L, 2L);
    }
}
