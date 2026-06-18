package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.core.dto.ParametroSistemaRequest;
import pe.restaurant.core.dto.ParametroSistemaResponse;
import pe.restaurant.core.entity.ParametroSistema;
import pe.restaurant.core.mapper.ParametroSistemaMapper;
import pe.restaurant.core.service.ParametroSistemaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ParametroSistemaControllerTest {

    @Mock private ParametroSistemaService service;
    @Mock private ParametroSistemaMapper mapper;
    @InjectMocks private ParametroSistemaController controller;

    private ParametroSistema entity;
    private ParametroSistemaResponse response;

    @BeforeEach void setUp() {
        entity = new ParametroSistema();
        entity.setId(1L);
        response = new ParametroSistemaResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(null, null, pageable)).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(null, null, pageable).isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new ParametroSistemaRequest();
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void update() {
        var request = new ParametroSistemaRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }

    @Test void deactivate() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.isSuccess()).isTrue();
        verify(service).deactivate(1L);
    }

    @Test void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
        verify(service).delete(1L);
    }

    @Test void activate() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.isSuccess()).isTrue();
        verify(service).activate(1L);
    }

    @Test void updateBatch() {
        var req1 = new ParametroSistemaRequest();
        var entity2 = new ParametroSistema();
        entity2.setId(2L);
        when(mapper.toEntity(req1)).thenReturn(entity);
        when(service.updateBatch(any())).thenReturn(List.of(entity, entity2));
        when(mapper.toResponseList(any())).thenReturn(List.of(response, response));
        var result = controller.updateBatch(List.of(req1));
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(2);
    }
}
