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
import com.sigre.rrhh.dto.request.PrestamoCreateRequest;
import com.sigre.rrhh.dto.request.PrestamoUpdateRequest;
import com.sigre.rrhh.dto.response.PrestamoResponse;
import com.sigre.rrhh.service.PrestamoService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - PrestamoController")
class PrestamoControllerTest {

    @Mock
    private PrestamoService service;

    @InjectMocks
    private PrestamoController controller;

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
    @DisplayName("GET /api/rrhh/prestamos -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<PrestamoResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.prestamoResponse(1L)
        ));
        when(service.listar(any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/prestamos")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/prestamos con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        when(service.listar(eq(1L), eq("1"), any())).thenReturn(new PageImpl<>(List.of()));

        mockMvc.perform(get("/api/rrhh/prestamos")
                        .param("trabajadorId", "1")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(eq(1L), eq("1"), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/prestamos/{id} -> retorna préstamo")
    void obtenerPorId_idExistente_retornaPrestamo() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.prestamoResponse(1L));

        mockMvc.perform(get("/api/rrhh/prestamos/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.montoTotal").value(5000.0));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/prestamos -> crea préstamo")
    void crear_datosValidos_creaExitosamente() throws Exception {
        PrestamoCreateRequest request = RrhhTestFixtures.prestamoCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.prestamoResponse(1L));

        mockMvc.perform(post("/api/rrhh/prestamos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/prestamos/{id} -> actualiza préstamo")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        PrestamoUpdateRequest request = RrhhTestFixtures.prestamoUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.prestamoResponse(1L));

        mockMvc.perform(put("/api/rrhh/prestamos/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/prestamos/{id}/estado -> cambia estado")
    void cambiarEstado_idExistente_cambiaEstado() throws Exception {
        when(service.cambiarEstado(1L)).thenReturn(RrhhTestFixtures.prestamoResponse(1L));

        mockMvc.perform(patch("/api/rrhh/prestamos/{id}/estado", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).cambiarEstado(1L);
    }
}
