package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ZonaRequest;
import com.sigre.comercializacion.dto.response.ZonaResponse;
import com.sigre.comercializacion.entity.Zona;
import com.sigre.comercializacion.mapper.ZonaMapper;
import com.sigre.comercializacion.service.ZonaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ZonaControllerTest {

    @Mock
    private ZonaService service;
    @Mock
    private ZonaMapper mapper;
    @InjectMocks
    private ZonaController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new Zona())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new ZonaResponse()));
        assertThat(controller.findAll(null, null, null, Pageable.unpaged()).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(new ZonaResponse());
        assertThat(controller.findById(1L).getData().getClass()).isEqualTo(ZonaResponse.class);
    }

    @Test
    void findBySucursal_and_activas() {
        when(service.findBySucursalId(1L)).thenReturn(List.of(new ZonaResponse()));
        when(service.findAllActivas()).thenReturn(List.of(new ZonaResponse()));
        assertThat(controller.findBySucursalId(1L).isSuccess()).isTrue();
        assertThat(controller.findAllActivas().isSuccess()).isTrue();
    }

    @Test
    void create_update_delete_activate_deactivate() {
        ZonaRequest req = new ZonaRequest();
        Zona entity = new Zona();
        entity.setId(1L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ZonaResponse());
        assertThat(controller.create(req).isSuccess()).isTrue();

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
