package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfMatrizSubClaseRequest;
import pe.restaurant.activos.dto.AfMatrizSubClaseResponse;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.mapper.AfMatrizSubClaseMapper;
import pe.restaurant.activos.service.AfMatrizSubClaseService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfMatrizSubClaseControllerTest {

    @Mock
    private AfMatrizSubClaseService service;
    @Mock
    private AfMatrizSubClaseMapper mapper;
    @InjectMocks
    private AfMatrizSubClaseController controller;

    private AfMatrizSubClase entity;
    private AfMatrizSubClaseResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfMatrizSubClase();
        entity.setId(1L);
        entity.setAfSubClaseId(10L);
        entity.setCuentaActivoId(100L);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfMatrizSubClaseResponse();
        response.setId(1L);
        response.setAfSubClaseId(10L);
        response.setCuentaActivoId(100L);
        response.setFlagEstado("1");
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
    void obtenerPorSubClase() {
        when(service.findBySubClaseId(10L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.obtenerPorSubClase(10L).getData().getAfSubClaseId()).isEqualTo(10L);
    }

    @Test
    void crear() {
        when(mapper.toEntity(any(AfMatrizSubClaseRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var req = new AfMatrizSubClaseRequest();
        req.setAfSubClaseId(10L);
        var result = controller.crear(req);
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void obtenerPorId() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.obtenerPorId(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
        assertThat(result.getData().getAfSubClaseId()).isEqualTo(10L);
    }

    @Test
    void obtenerPorSubClaseNotFound() {
        when(service.findBySubClaseId(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> controller.obtenerPorSubClase(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(AfMatrizSubClase.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var req = new AfMatrizSubClaseRequest();
        req.setAfSubClaseId(10L);
        req.setCuentaActivoId(200L);

        var result = controller.actualizar(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(mapper).updateEntity(req, entity);
        verify(service).update(eq(1L), eq(entity));
    }

    @Test
    void eliminar() {
        var result = controller.eliminar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
        verify(service).delete(1L);
    }
}
