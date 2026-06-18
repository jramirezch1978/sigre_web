package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfSubClaseRequest;
import pe.restaurant.activos.dto.AfSubClaseResponse;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.mapper.AfSubClaseMapper;
import pe.restaurant.activos.service.AfSubClaseService;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfSubClaseControllerTest {

    @Mock private AfSubClaseService service;
    @Mock private AfSubClaseMapper mapper;
    @InjectMocks private AfSubClaseController controller;

    private AfSubClase entity;
    private AfSubClaseResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(1L);
        entity.setCodigo("SUB001");
        entity.setNombre("Subclase de Activo 1");
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfSubClaseResponse();
        response.setId(1L);
        response.setAfClaseId(1L);
        response.setCodigo("SUB001");
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
        when(mapper.toEntity(any(AfSubClaseRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfSubClaseRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.actualizar(1L, new AfSubClaseRequest());
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
