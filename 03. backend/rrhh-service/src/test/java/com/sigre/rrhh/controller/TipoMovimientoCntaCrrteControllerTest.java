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
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;
import com.sigre.rrhh.service.TipoMovimientoCntaCrrteService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - TipoMovimientoCntaCrrteController")
class TipoMovimientoCntaCrrteControllerTest {

    @Mock
    private TipoMovimientoCntaCrrteService service;

    @InjectMocks
    private TipoMovimientoCntaCrrteController controller;

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
    @DisplayName("GET /api/rrhh/tipos-movimiento-cnta-crrte -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<TipoMovimientoCntaCrrteResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-movimiento-cnta-crrte")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].codigo").value("TM"));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-movimiento-cnta-crrte con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<TipoMovimientoCntaCrrteResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        ));
        when(service.listar(eq("TM"), eq("Tipo Movimiento"), eq("1"), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-movimiento-cnta-crrte")
                        .param("codigo", "TM")
                        .param("nombre", "Tipo Movimiento")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(eq("TM"), eq("Tipo Movimiento"), eq("1"), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-movimiento-cnta-crrte/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        );

        mockMvc.perform(get("/api/rrhh/tipos-movimiento-cnta-crrte/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TM"))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Movimiento"));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-movimiento-cnta-crrte -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        TipoMovimientoCntaCrrteCreateRequest request = RrhhTestFixtures.tipoMovimientoCntaCrrteCreateRequest("TM", "Tipo Movimiento");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        );

        mockMvc.perform(post("/api/rrhh/tipos-movimiento-cnta-crrte")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TM"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-movimiento-cnta-crrte/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        TipoMovimientoCntaCrrteUpdateRequest request = RrhhTestFixtures.tipoMovimientoCntaCrrteUpdateRequest("Tipo Actualizado");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/tipos-movimiento-cnta-crrte/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-movimiento-cnta-crrte/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        );

        mockMvc.perform(patch("/api/rrhh/tipos-movimiento-cnta-crrte/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-movimiento-cnta-crrte/{id}/activar -> activa entidad")
    void activar_idExistente_activaExitosamente() throws Exception {
        when(service.activar(1L)).thenReturn(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        );

        mockMvc.perform(patch("/api/rrhh/tipos-movimiento-cnta-crrte/{id}/activar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).activar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-movimiento-cnta-crrte/activos -> retorna lista activos")
    void listarActivos_retornaLista() throws Exception {
        when(service.listarActivos()).thenReturn(List.of(
                RrhhTestFixtures.tipoMovimientoCntaCrrteResponse(1L, "TM", "Tipo Movimiento")
        ));

        mockMvc.perform(get("/api/rrhh/tipos-movimiento-cnta-crrte/activos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listarActivos();
    }
}