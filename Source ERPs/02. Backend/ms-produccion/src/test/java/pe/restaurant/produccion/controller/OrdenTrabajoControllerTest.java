package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.OrdenTrabajoRequest;
import pe.restaurant.produccion.dto.response.OrdenTrabajoResponse;
import pe.restaurant.produccion.entity.OrdenTrabajo;
import pe.restaurant.produccion.mapper.OrdenTrabajoMapper;
import pe.restaurant.produccion.service.OrdenTrabajoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrdenTrabajoControllerTest {

    @Mock private OrdenTrabajoService service;
    @Mock private OrdenTrabajoMapper mapper;
    @InjectMocks private OrdenTrabajoController controller;

    private OrdenTrabajo entity;
    private OrdenTrabajoResponse response;
    private OrdenTrabajoRequest request;

    @BeforeEach
    void setUp() {
        entity = new OrdenTrabajo();
        entity.setId(1L);

        response = OrdenTrabajoResponse.builder().id(1L).build();

        request = new OrdenTrabajoRequest();
    }

    @Test
    void findAll_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        doNothing().when(service).enrich(any(OrdenTrabajoResponse.class));

        var result = controller.findAll(null, null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichDetail(any(OrdenTrabajoResponse.class));

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(service).enrichDetail(any(OrdenTrabajoResponse.class));
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(any(OrdenTrabajoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichDetail(any(OrdenTrabajoResponse.class));

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any());
    }

    @Test
    void update_retornaActualizado() {
        when(mapper.toEntity(any(OrdenTrabajoRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichDetail(any(OrdenTrabajoResponse.class));

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any());
    }

    @Test
    void activate_retornaResponse() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OrdenTrabajoResponse.class));

        var result = controller.activate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void deactivate_retornaResponse() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OrdenTrabajoResponse.class));

        var result = controller.deactivate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void cerrar_retornaResponse() {
        when(service.cerrar(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OrdenTrabajoResponse.class));

        var result = controller.cerrar(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void anular_retornaResponse() {
        when(service.anular(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OrdenTrabajoResponse.class));

        var result = controller.anular(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);

        var result = controller.delete(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }
}
