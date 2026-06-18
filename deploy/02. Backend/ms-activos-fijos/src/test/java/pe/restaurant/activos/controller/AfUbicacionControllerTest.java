package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfUbicacionRequest;
import pe.restaurant.activos.dto.AfUbicacionResponse;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.mapper.AfUbicacionMapper;
import pe.restaurant.activos.service.AfUbicacionService;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfUbicacionControllerTest {

    @Mock private AfUbicacionService service;
    @Mock private AfUbicacionMapper mapper;
    @InjectMocks private AfUbicacionController controller;

    private AfUbicacion entity;
    private AfUbicacionResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setCodigo("UB001");
        entity.setNombre("Ubicación de Activo 1");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfUbicacionResponse();
        response.setId(1L);
        response.setSucursalId(1L);
        response.setCodigo("UB001");
    }

    @Test
    void listar() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listar(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void obtenerPorId() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.obtenerPorId(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void crear() {
        when(mapper.toEntity(any(AfUbicacionRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfUbicacionRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.actualizar(1L, new AfUbicacionRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    void desactivar() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.desactivar(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    void activar() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activar(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void eliminar() {
        doNothing().when(service).delete(1L);
        var result = controller.eliminar(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }
}
