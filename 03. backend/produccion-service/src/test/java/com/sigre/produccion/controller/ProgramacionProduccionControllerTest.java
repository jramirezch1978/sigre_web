package com.sigre.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.request.ProgramacionProduccionRequest;
import com.sigre.produccion.dto.response.ProgramacionProduccionResponse;
import com.sigre.produccion.entity.ProgramacionProduccion;
import com.sigre.produccion.mapper.ProgramacionProduccionMapper;
import com.sigre.produccion.service.ProgramacionProduccionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProgramacionProduccionControllerTest {

    @Mock private ProgramacionProduccionService service;
    @Mock private ProgramacionProduccionMapper mapper;
    @InjectMocks private ProgramacionProduccionController controller;

    private ProgramacionProduccion entity;
    private ProgramacionProduccionResponse response;
    private ProgramacionProduccionRequest request;

    @BeforeEach
    void setUp() {
        entity = new ProgramacionProduccion();
        entity.setId(1L);

        response = ProgramacionProduccionResponse.builder().id(1L).build();

        request = new ProgramacionProduccionRequest();
    }

    @Test
    void findAll_retornaPageDataConEnrich() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        doNothing().when(service).enrichResponses(any());

        var result = controller.findAll(null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        verify(service).enrichResponses(any());
    }

    @Test
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichResponses(any());

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(any(ProgramacionProduccionRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichResponses(any());

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any());
    }

    @Test
    void update_retornaActualizado() {
        when(mapper.toEntity(any(ProgramacionProduccionRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichResponses(any());

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any());
    }

    @Test
    void activate_retornaResponse() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichResponses(any());

        var result = controller.activate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void deactivate_retornaResponse() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(service).enrichResponses(any());

        var result = controller.deactivate(1L);

        assertThat(result.isSuccess()).isTrue();
    }
}
