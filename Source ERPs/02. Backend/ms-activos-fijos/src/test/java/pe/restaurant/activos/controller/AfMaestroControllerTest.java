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
import pe.restaurant.activos.dto.AfMaestroRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.mapper.AfMaestroMapper;
import pe.restaurant.activos.service.AfMaestroService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfMaestroControllerTest {

    @Mock
    private AfMaestroService service;
    @Mock
    private AfMaestroMapper mapper;
    @InjectMocks
    private AfMaestroController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfMaestro entity;
    private AfMaestroResponse response;
    private AfMaestroRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfMaestro();
        entity.setId(1L);
        entity.setCodigo("ACT001");
        entity.setNombre("Activo Fijo Test");
        entity.setAfSubClaseId(1L);
        entity.setAfUbicacionId(1L);
        entity.setFechaAdquisicion(LocalDate.now());
        entity.setValorAdquisicion(new BigDecimal("10000.00"));
        entity.setValorResidual(new BigDecimal("1000.00"));
        entity.setProveedorId(1L);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfMaestroResponse();
        response.setId(1L);
        response.setCodigo("ACT001");
        response.setNombre("Activo Fijo Test");
        response.setAfSubClaseId(1L);
        response.setAfUbicacionId(1L);
        response.setFechaAdquisicion(LocalDate.now());
        response.setValorAdquisicion(new BigDecimal("10000.00"));
        response.setValorResidual(new BigDecimal("1000.00"));
        response.setProveedorId(1L);
        response.setFlagEstado("1");

        request = new AfMaestroRequest();
        request.setCodigo("ACT001");
        request.setNombre("Activo Fijo Test");
        request.setAfSubClaseId(1L);
        request.setAfUbicacionId(1L);
        request.setFechaAdquisicion(LocalDate.now());
        request.setValorAdquisicion(new BigDecimal("10000.00"));
        request.setValorResidual(new BigDecimal("1000.00"));
        request.setProveedorId(1L);
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/maestro")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.content[0].nombre").value("Activo Fijo Test"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/maestro/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.nombre").value("Activo Fijo Test"));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfMaestroRequest.class))).thenReturn(entity);
        when(service.create(any(AfMaestro.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/maestro")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.nombre").value("Activo Fijo Test"))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfMaestroRequest.class), any(AfMaestro.class));
        when(service.update(eq(1L), any(AfMaestro.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/maestro/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.nombre").value("Activo Fijo Test"))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void desactivarReturnsDeactivatedEntity() throws Exception {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(patch("/api/activos/maestro/1/desactivar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.nombre").value("Activo Fijo Test"))
                .andExpect(jsonPath("$.message").value("Registro desactivado"));
    }

    @Test
    void activarReturnsActivatedEntity() throws Exception {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(patch("/api/activos/maestro/1/activar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.nombre").value("Activo Fijo Test"))
                .andExpect(jsonPath("$.message").value("Registro activado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/maestro/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorSubClaseReturnsPageData() throws Exception {
        when(service.findByAfSubClaseId(eq(1L), any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/maestro/por-subclase/1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.content[0].afSubClaseId").value(1));
    }

    @Test
    void listarPorUbicacionReturnsPageData() throws Exception {
        when(service.findByAfUbicacionId(eq(1L), any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/maestro/por-ubicacion/1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].codigo").value("ACT001"))
                .andExpect(jsonPath("$.data.content[0].afUbicacionId").value(1));
    }

}
