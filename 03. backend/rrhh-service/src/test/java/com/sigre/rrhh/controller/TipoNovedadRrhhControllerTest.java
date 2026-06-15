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
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.service.TipoNovedadRrhhService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - TipoNovedadRrhhController")
class TipoNovedadRrhhControllerTest {

    @Mock
    private TipoNovedadRrhhService service;

    @InjectMocks
    private TipoNovedadRrhhController controller;

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
    @DisplayName("GET /api/rrhh/tipos-novedad -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<TipoNovedadRrhhResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "TN", "Tipo Novedad")
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-novedad")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].codigo").value("TN"));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(
                RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "TN", "Tipo Novedad")
        );

        mockMvc.perform(get("/api/rrhh/tipos-novedad/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TN"))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Novedad"));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-novedad -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        TipoNovedadRrhhCreateRequest request = RrhhTestFixtures.tipoNovedadRrhhCreateRequest("TN", "Tipo Novedad");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "TN", "Tipo Novedad")
        );

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TN"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-novedad/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        TipoNovedadRrhhUpdateRequest request = RrhhTestFixtures.tipoNovedadRrhhUpdateRequest("Tipo Actualizado", "1");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "TN", "Tipo Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/tipos-novedad/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-novedad/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "TN", "Tipo Novedad"));

        mockMvc.perform(patch("/api/rrhh/tipos-novedad/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }
}
