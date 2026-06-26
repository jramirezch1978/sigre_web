package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.ControlCalidadRequest;
import pe.restaurant.produccion.dto.response.ControlCalidadResponse;
import pe.restaurant.produccion.entity.ControlCalidad;
import pe.restaurant.produccion.mapper.ControlCalidadMapper;
import pe.restaurant.produccion.service.ControlCalidadService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ControlCalidadControllerTest {

    @Mock private ControlCalidadService service;
    @Mock private ControlCalidadMapper mapper;
    @InjectMocks private ControlCalidadController controller;

    private ControlCalidad entity;
    private ControlCalidadResponse response;
    private ControlCalidadRequest request;

    @BeforeEach
    void setUp() {
        entity = new ControlCalidad();
        entity.setId(1L);

        response = ControlCalidadResponse.builder().id(1L).build();

        request = new ControlCalidadRequest();
    }

    @Test
    void findAll_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        doNothing().when(service).enrich(anyList());

        var result = controller.findAll(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(anyList());

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(any(ControlCalidadRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(anyList());

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any());
    }

    @Test
    void update_retornaActualizado() {
        when(mapper.toEntity(any(ControlCalidadRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(anyList());

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any());
    }

    @Test
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);

        var result = controller.delete(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }
}
