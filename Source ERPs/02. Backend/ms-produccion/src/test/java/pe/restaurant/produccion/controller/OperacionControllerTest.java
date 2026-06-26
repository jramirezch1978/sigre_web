package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.OperacionDetRequest;
import pe.restaurant.produccion.dto.request.OperacionRequest;
import pe.restaurant.produccion.dto.response.OperacionDetResponse;
import pe.restaurant.produccion.dto.response.OperacionResponse;
import pe.restaurant.produccion.entity.Operacion;
import pe.restaurant.produccion.entity.OperacionesDet;
import pe.restaurant.produccion.mapper.OperacionMapper;
import pe.restaurant.produccion.mapper.OperacionesDetMapper;
import pe.restaurant.produccion.service.OperacionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OperacionControllerTest {

    @Mock private OperacionService service;
    @Mock private OperacionMapper mapper;
    @Mock private OperacionesDetMapper detMapper;
    @InjectMocks private OperacionController controller;

    private Operacion entity;
    private OperacionResponse response;
    private OperacionRequest request;

    @BeforeEach
    void setUp() {
        entity = new Operacion();
        entity.setId(1L);

        response = OperacionResponse.builder().id(1L).build();

        request = new OperacionRequest();
    }

    @Test
    void findAll_retornaPageDataConEnrich() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        doNothing().when(service).enrich(anyList());

        var result = controller.findAll(null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        verify(service).enrich(anyList());
    }

    @Test
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrich(any(OperacionResponse.class));

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(any(OperacionRequest.class))).thenReturn(entity);
        when(service.create(any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrich(any(OperacionResponse.class));

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any(), any());
    }

    @Test
    void create_conDetalles_mapeaSubRecursos() {
        request.setDetalles(List.of(new OperacionDetRequest()));
        when(detMapper.toEntity(any(OperacionDetRequest.class))).thenReturn(new OperacionesDet());
        when(mapper.toEntity(any(OperacionRequest.class))).thenReturn(entity);
        when(service.create(any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrich(any(OperacionResponse.class));

        controller.create(request);

        verify(detMapper).toEntity(any(OperacionDetRequest.class));
    }

    @Test
    void update_retornaActualizado() {
        when(mapper.toEntity(any(OperacionRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrich(any(OperacionResponse.class));

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any(), any());
    }

    @Test
    void update_conDetalles_mapeaSubRecursos() {
        request.setDetalles(List.of(new OperacionDetRequest()));
        when(detMapper.toEntity(any(OperacionDetRequest.class))).thenReturn(new OperacionesDet());
        when(mapper.toEntity(any(OperacionRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrich(any(OperacionResponse.class));

        controller.update(1L, request);

        verify(detMapper).toEntity(any(OperacionDetRequest.class));
    }

    @Test
    void activate_retornaResponse() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OperacionResponse.class));

        var result = controller.activate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void deactivate_retornaResponse() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrich(any(OperacionResponse.class));

        var result = controller.deactivate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);

        var result = controller.delete(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    @Test
    void findDetalles_retornaLista() {
        when(service.findDetalles(1L)).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichDetalles(any());

        var result = controller.findDetalles(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void addDetalles_retornaLista() {
        when(detMapper.toEntity(any(OperacionDetRequest.class))).thenReturn(new OperacionesDet());
        when(service.addDetalles(anyLong(), any())).thenReturn(List.of());
        when(detMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichDetalles(any());

        var result = controller.addDetalles(1L, List.of(new OperacionDetRequest()));

        assertThat(result.isSuccess()).isTrue();
    }
}
