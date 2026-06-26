package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.MotivoTrasladoRequest;
import pe.restaurant.almacen.dto.MotivoTrasladoResponse;
import pe.restaurant.almacen.entity.MotivoTraslado;
import pe.restaurant.almacen.mapper.MotivoTrasladoMapper;
import pe.restaurant.almacen.service.MotivoTrasladoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MotivoTrasladoControllerTest {

    @Mock private MotivoTrasladoService service;
    @Mock private MotivoTrasladoMapper mapper;
    @InjectMocks private MotivoTrasladoController controller;

    private MotivoTraslado entity;
    private MotivoTrasladoResponse response;

    @BeforeEach
    void setUp() {
        entity = new MotivoTraslado();
        entity.setId(1L);
        entity.setCodigo("MT01");
        entity.setNombre("Motivo 1");
        entity.setFlagEstado("1");

        response = new MotivoTrasladoResponse();
        response.setId(1L);
        response.setCodigo("MT01");
    }

    @Test
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void create() {
        when(mapper.toEntity(any(MotivoTrasladoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new MotivoTrasladoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new MotivoTrasladoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void activate() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }
}
