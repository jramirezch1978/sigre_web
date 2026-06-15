package com.sigre.compras.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.TipoEntidadContribuyenteRequest;
import com.sigre.compras.dto.TipoEntidadContribuyenteResponse;
import com.sigre.compras.entity.TipoEntidadContribuyente;
import com.sigre.compras.mapper.TipoEntidadContribuyenteMapper;
import com.sigre.compras.service.TipoEntidadContribuyenteService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoEntidadContribuyenteController — Pruebas Unitarias")
class TipoEntidadContribuyenteControllerTest {

    @Mock private TipoEntidadContribuyenteService service;
    @Mock private TipoEntidadContribuyenteMapper mapper;
    @InjectMocks private TipoEntidadContribuyenteController controller;

    private TipoEntidadContribuyente entity;
    private TipoEntidadContribuyenteResponse response;

    @BeforeEach
    void setUp() {
        entity = new TipoEntidadContribuyente();
        entity.setId(1L);
        entity.setTipo("PROVEEDOR");
        entity.setDescripcion("Entidad proveedora");
        entity.setFlagEstado("1");

        response = new TipoEntidadContribuyenteResponse();
        response.setId(1L);
    }

    @Test
    @DisplayName("findAll() validación general")
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findById() validación general")
    void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("create() validación general")
    void create() {
        when(mapper.toEntity(any(TipoEntidadContribuyenteRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new TipoEntidadContribuyenteRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("update() validación general")
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new TipoEntidadContribuyenteRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("activate() validación general")
    void activate() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    @DisplayName("deactivate() validación general")
    void deactivate() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    @DisplayName("delete() validación general")
    void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }
}
