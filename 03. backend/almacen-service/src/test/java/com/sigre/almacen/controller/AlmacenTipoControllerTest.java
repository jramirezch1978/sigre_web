package com.sigre.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.AlmacenTipoRequest;
import com.sigre.almacen.dto.AlmacenTipoResponse;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.mapper.AlmacenTipoMapper;
import com.sigre.almacen.service.AlmacenTipoService;
import com.sigre.almacen.support.AlmacenTipoResponseEnricher;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlmacenTipoControllerTest {

    @Mock
    private AlmacenTipoService service;

    @Mock
    private AlmacenTipoMapper mapper;

    @Mock
    private AlmacenTipoResponseEnricher almacenTipoResponseEnricher;

    @InjectMocks
    private AlmacenTipoController controller;

    private AlmacenTipo entity;
    private AlmacenTipoResponse response;

    @BeforeEach
    void setUp() {
        entity = new AlmacenTipo();
        entity.setId(1L);
        entity.setCodigo("TM1");
        entity.setNombre("Principal");

        response = new AlmacenTipoResponse();
        response.setId(1L);
        response.setCodigo("TM1");
    }

    @Test
    void findAll_mapsPage() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenTipoResponseEnricher).enrich(response);

        var result = controller.findAll(Pageable.unpaged());

        assertThat(result.getData().getContent()).containsExactly(response);
        verify(almacenTipoResponseEnricher).enrich(response);
    }

    @Test
    void findById_crud_flow() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenTipoResponseEnricher).enrich(response);

        assertThat(controller.findById(1L).getData().getCodigo()).isEqualTo("TM1");

        AlmacenTipoRequest req = new AlmacenTipoRequest();
        req.setCodigo("TM1");
        req.setNombre("Principal");
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        assertThat(controller.create(req).getMessage()).isEqualTo("Registro creado");

        when(service.findById(2L)).thenReturn(entity);
        when(service.update(eq(2L), eq(entity))).thenReturn(entity);
        assertThat(controller.update(2L, req).getMessage()).isEqualTo("Registro actualizado");

        when(service.deactivate(1L)).thenReturn(entity);
        when(service.activate(1L)).thenReturn(entity);
        assertThat(controller.deactivate(1L).getMessage()).isEqualTo("Registro desactivado");
        assertThat(controller.activate(1L).getMessage()).isEqualTo("Registro activado");

        assertThat(controller.delete(9L).getData()).isTrue();
        verify(service).delete(9L);
    }
}
