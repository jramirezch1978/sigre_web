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
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;
import com.sigre.rrhh.service.TipoPlanillaService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - TipoPlanillaController")
class TipoPlanillaControllerTest {

    @Mock
    private TipoPlanillaService service;

    @InjectMocks
    private TipoPlanillaController controller;

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
    @DisplayName("GET /api/rrhh/tipos-planilla -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<TipoPlanillaResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla")
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-planilla")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].codigo").value("TP"));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-planilla con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<TipoPlanillaResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla")
        ));
        when(service.listar(eq("TP"), eq("Tipo Planilla"), eq("1"), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-planilla")
                        .param("codigo", "TP")
                        .param("nombre", "Tipo Planilla")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(eq("TP"), eq("Tipo Planilla"), eq("1"), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-planilla/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla")
        );

        mockMvc.perform(get("/api/rrhh/tipos-planilla/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TP"))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Planilla"));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-planilla -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        TipoPlanillaCreateRequest request = RrhhTestFixtures.tipoPlanillaCreateRequest("TP", "Tipo Planilla");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla")
        );

        mockMvc.perform(post("/api/rrhh/tipos-planilla")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("TP"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-planilla/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        TipoPlanillaUpdateRequest request = RrhhTestFixtures.tipoPlanillaUpdateRequest("Tipo Actualizado");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/tipos-planilla/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Tipo Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-planilla/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla"));

        mockMvc.perform(patch("/api/rrhh/tipos-planilla/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-planilla/{id}/activar -> activa entidad")
    void activar_idExistente_activaExitosamente() throws Exception {
        when(service.activar(1L)).thenReturn(RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla"));

        mockMvc.perform(patch("/api/rrhh/tipos-planilla/{id}/activar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).activar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-planilla/activos -> retorna lista activos")
    void listarActivos_retornaLista() throws Exception {
        when(service.listarActivos()).thenReturn(List.of(
                RrhhTestFixtures.tipoPlanillaResponse(1L, "TP", "Tipo Planilla")
        ));

        mockMvc.perform(get("/api/rrhh/tipos-planilla/activos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listarActivos();
    }
}