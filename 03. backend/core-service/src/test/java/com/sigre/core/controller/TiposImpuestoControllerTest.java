package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.core.dto.TiposImpuestoRequest;
import com.sigre.core.dto.TiposImpuestoResponse;
import com.sigre.core.entity.TiposImpuesto;
import com.sigre.core.mapper.TiposImpuestoMapper;
import com.sigre.core.service.TiposImpuestoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TiposImpuestoControllerTest {

    @Mock private TiposImpuestoService service;
    @Mock private TiposImpuestoMapper mapper;
    @InjectMocks private TiposImpuestoController controller;

    private TiposImpuesto entity;
    private TiposImpuestoResponse response;

    @BeforeEach void setUp() {
        entity = new TiposImpuesto();
        entity.setId(1L);
        entity.setTipoImpuesto("IGV");
        response = new TiposImpuestoResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        when(service.findAll()).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll().getData()).hasSize(1);
    }
    @Test void findByTipoImpuesto() {
        when(service.findByTipoImpuesto("IGV")).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findByTipoImpuesto("IGV").getData().getId()).isEqualTo(1L);
    }
    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }
    @Test void create() {
        var req = new TiposImpuestoRequest();
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(req).isSuccess()).isTrue();
    }
    @Test void update() {
        var req = new TiposImpuestoRequest();
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
