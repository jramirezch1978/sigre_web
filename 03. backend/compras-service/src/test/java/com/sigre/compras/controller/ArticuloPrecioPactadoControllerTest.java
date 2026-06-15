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
import com.sigre.compras.dto.ArticuloPrecioPactadoRequest;
import com.sigre.compras.dto.ArticuloPrecioPactadoResponse;
import com.sigre.compras.entity.ArticuloPrecioPactado;
import com.sigre.compras.mapper.ArticuloPrecioPactadoMapper;
import com.sigre.compras.service.ArticuloPrecioPactadoService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ArticuloPrecioPactadoController — Pruebas Unitarias")
class ArticuloPrecioPactadoControllerTest {

    @Mock private ArticuloPrecioPactadoService service;
    @Mock private ArticuloPrecioPactadoMapper mapper;
    @InjectMocks private ArticuloPrecioPactadoController controller;

    private ArticuloPrecioPactado entity;
    private ArticuloPrecioPactadoResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloPrecioPactado();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setProveedorId(20L);
        entity.setPrecio(new BigDecimal("100.0000"));
        entity.setFlagEstado("1");

        response = new ArticuloPrecioPactadoResponse();
        response.setId(1L);
    }

    @Test
    @DisplayName("findAll() validación general")
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(null, null, Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findAllWithFilters() validación general")
    void findAllWithFilters() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(eq(10L), eq(20L), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(10L, 20L, Pageable.unpaged());
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
        when(mapper.toEntity(any(ArticuloPrecioPactadoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ArticuloPrecioPactadoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("update() validación general")
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ArticuloPrecioPactadoRequest());
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
