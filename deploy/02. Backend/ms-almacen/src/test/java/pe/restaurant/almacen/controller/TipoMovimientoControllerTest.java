package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.ArticuloMovTipoRequest;
import pe.restaurant.almacen.dto.ArticuloMovTipoResponse;
import pe.restaurant.almacen.entity.ArticuloMovTipo;
import pe.restaurant.almacen.mapper.ArticuloMovTipoMapper;
import pe.restaurant.almacen.service.ArticuloMovTipoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TipoMovimientoControllerTest {

    @Mock private ArticuloMovTipoService service;
    @Mock private ArticuloMovTipoMapper mapper;
    @InjectMocks private TipoMovimientoController controller;

    private ArticuloMovTipo entity;
    private ArticuloMovTipoResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloMovTipo();
        entity.setId(1L);
        entity.setTipoMov("ING");
        entity.setDescTipoMov("Ingreso");
        entity.setFlagEstado("1");

        response = new ArticuloMovTipoResponse();
        response.setId(1L);
        response.setTipoMov("ING");
        response.setDescTipoMov("Ingreso");
    }

    @Test
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(PageRequest.of(0, 20));
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getTipoMov()).isEqualTo("ING");
    }

    @Test
    void create() {
        when(mapper.toEntity(any(ArticuloMovTipoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ArticuloMovTipoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ArticuloMovTipoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void activate() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
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
