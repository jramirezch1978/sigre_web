package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ZonaDespachoRequest;
import com.sigre.comercializacion.dto.response.ZonaDespachoResponse;
import com.sigre.comercializacion.entity.ZonaDespacho;
import com.sigre.comercializacion.mapper.ZonaDespachoMapper;
import com.sigre.comercializacion.service.ZonaDespachoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ZonaDespachoControllerTest {

    @Mock
    private ZonaDespachoService service;
    @Mock
    private ZonaDespachoMapper mapper;
    @InjectMocks
    private ZonaDespachoController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new ZonaDespacho())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new ZonaDespachoResponse()));
        assertThat(controller.findAll(Pageable.unpaged(), null, null, null, null).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(new ZonaDespacho());
        when(mapper.toResponse(any())).thenReturn(new ZonaDespachoResponse());
        assertThat(controller.findById(1L).isSuccess()).isTrue();
    }

    @Test
    void create_update_delete_activate_deactivate() {
        ZonaDespachoRequest req = new ZonaDespachoRequest();
        ZonaDespacho entity = new ZonaDespacho();
        entity.setId(1L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ZonaDespachoResponse());
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
