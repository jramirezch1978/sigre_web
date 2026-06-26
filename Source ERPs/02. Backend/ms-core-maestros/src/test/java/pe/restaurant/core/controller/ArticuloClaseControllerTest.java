package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.ArticuloClaseRequest;
import pe.restaurant.core.dto.ArticuloClaseResponse;
import pe.restaurant.core.entity.ArticuloClase;
import pe.restaurant.core.mapper.ArticuloClaseMapper;
import pe.restaurant.core.service.ArticuloClaseService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloClaseControllerTest {

    @Mock private ArticuloClaseService service;
    @Mock private ArticuloClaseMapper mapper;
    @InjectMocks private ArticuloClaseController controller;

    private ArticuloClase entity;
    private ArticuloClaseResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloClase();
        entity.setId(1L);
        entity.setCodClase("CLS01");
        entity.setDescClase("Clase 1");
        entity.setFlagEstado("1");

        response = new ArticuloClaseResponse();
        response.setId(1L);
        response.setCodClase("CLS01");
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
        when(mapper.toEntity(any(ArticuloClaseRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ArticuloClaseRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ArticuloClaseRequest());
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
