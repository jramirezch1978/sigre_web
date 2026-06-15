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
import com.sigre.compras.dto.CompradorCategoriaRequest;
import com.sigre.compras.dto.CompradorCategoriaResponse;
import com.sigre.compras.dto.CompradorRequest;
import com.sigre.compras.dto.CompradorResponse;
import com.sigre.compras.entity.Comprador;
import com.sigre.compras.entity.CompradorCategoria;
import com.sigre.compras.mapper.CompradorCategoriaMapper;
import com.sigre.compras.mapper.CompradorMapper;
import com.sigre.compras.service.CompradorService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CompradorController — Pruebas Unitarias")
class CompradorControllerTest {

    @Mock private CompradorService service;
    @Mock private CompradorMapper mapper;
    @Mock private CompradorCategoriaMapper categoriaMapper;
    @InjectMocks private CompradorController controller;

    private Comprador entity;
    private CompradorResponse response;
    private CompradorCategoria categoriaEntity;
    private CompradorCategoriaResponse categoriaResponse;

    @BeforeEach
    void setUp() {
        entity = new Comprador();
        entity.setId(1L);
        entity.setUsuarioId(100L);
        entity.setNombre("Comprador Test");
        entity.setFlagEstado("1");

        response = new CompradorResponse();
        response.setId(1L);

        categoriaEntity = new CompradorCategoria();
        categoriaEntity.setId(10L);
        categoriaEntity.setCompradorId(1L);
        categoriaEntity.setArticuloCategId(50L);

        categoriaResponse = new CompradorCategoriaResponse();
        categoriaResponse.setId(10L);
    }

    @Test
    @DisplayName("findAll() retorna página")
    void findAll_retornaPagina() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findById() retorna response")
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("create() retorna response")
    void create_retornaResponse() {
        when(mapper.toEntity(any(CompradorRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new CompradorRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    @DisplayName("update() retorna response")
    void update_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new CompradorRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    @DisplayName("delete() retorna true")
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }

    @Test
    @DisplayName("activate() retorna response")
    void activate_retornaResponse() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    @DisplayName("deactivate() retorna response")
    void deactivate_retornaResponse() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    @DisplayName("findCategorias() retorna lista")
    void findCategorias_retornaLista() {
        when(service.findCategorias(1L)).thenReturn(List.of(categoriaEntity));
        when(categoriaMapper.toResponseList(any())).thenReturn(List.of(categoriaResponse));
        var result = controller.findCategorias(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    @DisplayName("assignCategoria() retorna response")
    void assignCategoria_retornaResponse() {
        var request = new CompradorCategoriaRequest();
        request.setArticuloCategId(50L);
        when(service.assignCategoria(1L, 50L)).thenReturn(categoriaEntity);
        when(categoriaMapper.toResponse(categoriaEntity)).thenReturn(categoriaResponse);
        var result = controller.assignCategoria(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("asignada");
    }
}
