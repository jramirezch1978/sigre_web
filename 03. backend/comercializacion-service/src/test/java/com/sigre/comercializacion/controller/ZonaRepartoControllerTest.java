package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ZonaRepartoRequest;
import com.sigre.comercializacion.dto.response.ZonaRepartoResponse;
import com.sigre.comercializacion.entity.ZonaReparto;
import com.sigre.comercializacion.mapper.ZonaRepartoMapper;
import com.sigre.comercializacion.service.ZonaRepartoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ZonaRepartoControllerTest {

    @Mock
    private ZonaRepartoService service;
    @Mock
    private ZonaRepartoMapper mapper;
    @InjectMocks
    private ZonaRepartoController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new ZonaReparto())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new ZonaRepartoResponse()));
        assertThat(controller.findAll(Pageable.unpaged(), null, null, null, null).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(new ZonaReparto());
        when(mapper.toResponse(any())).thenReturn(new ZonaRepartoResponse());
        assertThat(controller.findById(1L).isSuccess()).isTrue();
    }

    @Test
    void create_update_delete_activate_deactivate() {
        ZonaRepartoRequest req = new ZonaRepartoRequest();
        ZonaReparto entity = new ZonaReparto();
        entity.setId(1L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ZonaRepartoResponse());
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        assertThat(controller.update(1L, req).isSuccess()).isTrue();

        when(service.activate(1L)).thenReturn(entity);
        assertThat(controller.activate(1L).isSuccess()).isTrue();
        when(service.deactivate(1L)).thenReturn(entity);
        assertThat(controller.deactivate(1L).isSuccess()).isTrue();

        assertThat(controller.delete(1L).isSuccess()).isTrue();
        verify(service).delete(1L);
    }
}
