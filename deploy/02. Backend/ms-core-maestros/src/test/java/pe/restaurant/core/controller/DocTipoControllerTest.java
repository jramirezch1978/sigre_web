package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.core.dto.DocTipoRequest;
import pe.restaurant.core.dto.DocTipoResponse;
import pe.restaurant.core.entity.DocTipo;
import pe.restaurant.core.mapper.DocTipoMapper;
import pe.restaurant.core.service.DocTipoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DocTipoControllerTest {

    @Mock private DocTipoService service;
    @Mock private DocTipoMapper mapper;
    @InjectMocks private DocTipoController controller;

    private DocTipo entity;
    private DocTipoResponse response;

    @BeforeEach void setUp() {
        entity = new DocTipo();
        entity.setId(1L);
        entity.setCodigo("FAC");
        response = new DocTipoResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        when(service.findAll()).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll().getData()).hasSize(1);
    }
    @Test void findByCodigo() {
        when(service.findByCodigo("FAC")).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findByCodigo("FAC").getData().getId()).isEqualTo(1L);
    }
    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }
    @Test void create() {
        var req = new DocTipoRequest();
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(req).isSuccess()).isTrue();
    }
    @Test void update() {
        var req = new DocTipoRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, req).isSuccess()).isTrue();
    }
    @Test void delete() {
        controller.delete(1L);
        verify(service).delete(1L);
    }
}
