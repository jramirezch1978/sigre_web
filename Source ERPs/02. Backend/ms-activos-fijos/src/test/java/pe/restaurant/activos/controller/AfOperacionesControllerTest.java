package pe.restaurant.activos.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.dto.AfOperacionesRequest;
import pe.restaurant.activos.dto.AfOperacionesResponse;
import pe.restaurant.activos.entity.AfOperaciones;
import pe.restaurant.activos.mapper.AfOperacionesMapper;
import pe.restaurant.activos.service.AfOperacionesService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfOperacionesControllerTest {

    @Mock
    private AfOperacionesService service;
    @Mock
    private AfOperacionesMapper mapper;
    @InjectMocks
    private AfOperacionesController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfOperaciones entity;
    private AfOperacionesResponse response;
    private AfOperacionesRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfOperaciones();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipo("MANTENIMIENTO");
        entity.setFechaProgramada(LocalDate.now().plusDays(7));
        entity.setFechaEjecucion(null);
        entity.setCosto(new BigDecimal("500.00"));
        entity.setProveedorServicio("Servicios Técnicos S.A.");

        response = new AfOperacionesResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setTipo("MANTENIMIENTO");
        response.setFechaProgramada(LocalDate.now().plusDays(7));
        response.setFechaEjecucion(null);
        response.setCosto(new BigDecimal("500.00"));
        response.setProveedorServicio("Servicios Técnicos S.A.");

        request = new AfOperacionesRequest();
        request.setAfMaestroId(1L);
        request.setTipo("MANTENIMIENTO");
        request.setFechaProgramada(LocalDate.now().plusDays(7));
        request.setFechaEjecucion(null);
        request.setCosto(new BigDecimal("500.00"));
        request.setProveedorServicio("Servicios Técnicos S.A.");
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/operaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].tipo").value("MANTENIMIENTO"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/operaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.tipo").value("MANTENIMIENTO"))
                .andExpect(jsonPath("$.data.afMaestroId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfOperacionesRequest.class))).thenReturn(entity);
        when(service.create(any(AfOperaciones.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/operaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.tipo").value("MANTENIMIENTO"))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfOperacionesRequest.class), any(AfOperaciones.class));
        when(service.update(eq(1L), any(AfOperaciones.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/operaciones/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.tipo").value("MANTENIMIENTO"))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/operaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarProgramadasReturnsList() throws Exception {
        when(service.findProgramadas()).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/operaciones/programadas"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].tipo").value("MANTENIMIENTO"));
    }

    @Test
    void ejecutarReturnsExecutedEntity() throws Exception {
        AfOperaciones ejecutada = new AfOperaciones();
        ejecutada.setId(1L);
        ejecutada.setAfMaestroId(1L);
        ejecutada.setTipo("MANTENIMIENTO");
        ejecutada.setFechaProgramada(LocalDate.now().plusDays(7));
        ejecutada.setFechaEjecucion(LocalDate.now());
        ejecutada.setCosto(new BigDecimal("500.00"));
        ejecutada.setProveedorServicio("Servicios Técnicos S.A.");

        AfOperacionesResponse ejecutadaResponse = new AfOperacionesResponse();
        ejecutadaResponse.setId(1L);
        ejecutadaResponse.setAfMaestroId(1L);
        ejecutadaResponse.setTipo("MANTENIMIENTO");
        ejecutadaResponse.setFechaProgramada(LocalDate.now().plusDays(7));
        ejecutadaResponse.setFechaEjecucion(LocalDate.now());
        ejecutadaResponse.setCosto(new BigDecimal("500.00"));
        ejecutadaResponse.setProveedorServicio("Servicios Técnicos S.A.");

        when(service.ejecutar(1L)).thenReturn(ejecutada);
        when(mapper.toResponse(ejecutada)).thenReturn(ejecutadaResponse);

        mockMvc.perform(patch("/api/activos/operaciones/1/ejecutar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.tipo").value("MANTENIMIENTO"))
                .andExpect(jsonPath("$.data.fechaEjecucion").exists())
                .andExpect(jsonPath("$.message").value("Operación ejecutada"));
    }

    @Test
    void listarPorActivoReturnsList() throws Exception {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/operaciones/activo/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].tipo").value("MANTENIMIENTO"))
                .andExpect(jsonPath("$.data[0].afMaestroId").value(1));
    }
}
