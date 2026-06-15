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
import org.springframework.data.domain.PageImpl;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhDetRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import com.sigre.rrhh.service.NovedadRrhhService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - NovedadRrhhController")
class NovedadRrhhControllerTest {

    @Mock private NovedadRrhhService service;

    @InjectMocks private NovedadRrhhController controller;

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
    @DisplayName("GET /api/rrhh/novedades -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        var page = new PageImpl<>(List.of(RrhhTestFixtures.novedadRrhhResponse(1L)));
        when(service.listar(any(), any(), any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/novedades")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/novedades con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        var page = new PageImpl<>(List.of(RrhhTestFixtures.novedadRrhhResponse(1L)));
        when(service.listar(eq(1L), eq(2L), any(), any(), eq("1"), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/novedades")
                        .param("trabajadorId", "1")
                        .param("tipoNovedadRrhhId", "2")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/novedades/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        mockMvc.perform(get("/api/rrhh/novedades/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/novedades -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        NovedadRrhhCreateRequest request = RrhhTestFixtures.novedadRrhhCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        mockMvc.perform(post("/api/rrhh/novedades")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("PUT /api/rrhh/novedades/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        NovedadRrhhUpdateRequest request = RrhhTestFixtures.novedadRrhhUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        mockMvc.perform(put("/api/rrhh/novedades/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/novedades/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        mockMvc.perform(patch("/api/rrhh/novedades/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("GET /api/rrhh/novedades/{id}/detalles -> lista detalles")
    void listarDetalles_retornaLista() throws Exception {
        when(service.listarDetalles(1L)).thenReturn(List.of(RrhhTestFixtures.novedadRrhhDetResponse(1L)));

        mockMvc.perform(get("/api/rrhh/novedades/{id}/detalles", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));
    }

    @Test
    @DisplayName("POST /api/rrhh/novedades/{id}/detalles -> crea detalle")
    void crearDetalle_datosValidos_crea() throws Exception {
        NovedadRrhhDetRequest request = new NovedadRrhhDetRequest();
        request.setFechaProceso(java.time.LocalDate.of(2026, 3, 1));
        request.setMontoPlanilla(new java.math.BigDecimal("500.0000"));
        when(service.crearDetalle(eq(1L), any())).thenReturn(RrhhTestFixtures.novedadRrhhDetResponse(1L));

        mockMvc.perform(post("/api/rrhh/novedades/{id}/detalles", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("DELETE /api/rrhh/novedades/{id}/detalles/{detalleId} -> elimina detalle")
    void eliminarDetalle_idExistente_elimina() throws Exception {
        doNothing().when(service).eliminarDetalle(1L, 1L);

        mockMvc.perform(delete("/api/rrhh/novedades/{id}/detalles/{detalleId}", 1L, 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }
}
