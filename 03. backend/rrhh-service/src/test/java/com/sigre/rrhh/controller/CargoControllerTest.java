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
import com.sigre.rrhh.dto.request.CargoRequest;
import com.sigre.rrhh.dto.response.CargoResponse;
import com.sigre.rrhh.service.CargoService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CargoController")
class CargoControllerTest {

    @Mock
    private CargoService service;

    @InjectMocks
    private CargoController controller;

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
    @DisplayName("GET /api/rrhh/cargos -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<CargoResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.cargoResponse(1L, "Cargo Test")
        ));
        when(service.listar(any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/cargos")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].nombre").value("Cargo Test"));

        verify(service).listar(any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/cargos/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtener(1L)).thenReturn(
                RrhhTestFixtures.cargoResponse(1L, "Cargo Test")
        );

        mockMvc.perform(get("/api/rrhh/cargos/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.nombre").value("Cargo Test"));

        verify(service).obtener(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/cargos -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Cargo Nuevo");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.cargoResponse(1L, "Cargo Nuevo")
        );

        mockMvc.perform(post("/api/rrhh/cargos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.nombre").value("Cargo Nuevo"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/cargos/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Cargo Actualizado");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.cargoResponse(1L, "Cargo Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/cargos/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Cargo Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/cargos/{id}/activar -> activa entidad")
    void activar_idExistente_activaExitosamente() throws Exception {
        when(service.activar(1L)).thenReturn(RrhhTestFixtures.cargoResponse(1L, "Cargo Test"));

        mockMvc.perform(patch("/api/rrhh/cargos/{id}/activar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).activar(1L);
    }
}
