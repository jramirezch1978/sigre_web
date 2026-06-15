package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.ArticuloCategRequest;
import com.sigre.core.dto.ArticuloCategResponse;
import com.sigre.core.dto.ArticuloSubCategRequest;
import com.sigre.core.dto.ArticuloSubCategResponse;
import com.sigre.core.entity.ArticuloCateg;
import com.sigre.core.entity.ArticuloSubCateg;
import com.sigre.core.mapper.ArticuloCategMapper;
import com.sigre.core.mapper.ArticuloSubCategMapper;
import com.sigre.core.service.ArticuloCategService;
import com.sigre.core.service.ArticuloSubCategService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloCategControllerTest {

    @Mock private ArticuloCategService service;
    @Mock private ArticuloCategMapper mapper;
    @Mock private ArticuloSubCategService subCategService;
    @Mock private ArticuloSubCategMapper subCategMapper;
    @InjectMocks private ArticuloCategController controller;

    private ArticuloCateg entity;
    private ArticuloCategResponse response;
    private ArticuloSubCateg subCategEntity;
    private ArticuloSubCategResponse subCategResponse;

    @BeforeEach
    void setUp() {
        entity = new ArticuloCateg();
        entity.setId(1L);
        entity.setCatArt("CAT01");
        entity.setDescCateg("Categoria 1");
        entity.setFlagEstado("1");

        response = new ArticuloCategResponse();
        response.setId(1L);
        response.setCatArt("CAT01");

        subCategEntity = new ArticuloSubCateg();
        subCategEntity.setId(10L);
        subCategEntity.setArticuloCategId(1L);

        subCategResponse = new ArticuloSubCategResponse();
        subCategResponse.setId(10L);
    }

    @Test
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void arbol() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(Pageable.unpaged())).thenReturn(page);
        when(subCategService.findByCategoria(1L)).thenReturn(List.of(subCategEntity));
        when(subCategMapper.toResponseList(any())).thenReturn(List.of(subCategResponse));
        var result = controller.arbol();
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getSubCategorias()).hasSize(1);
    }

    @Test
    void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void create() {
        when(mapper.toEntity(any(ArticuloCategRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ArticuloCategRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ArticuloCategRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void activate() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }

    @Test
    void findSubCategorias() {
        when(service.findById(1L)).thenReturn(entity);
        when(subCategService.findByCategoria(1L)).thenReturn(List.of(subCategEntity));
        when(subCategMapper.toResponseList(any())).thenReturn(List.of(subCategResponse));
        var result = controller.findSubCategorias(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void createSubCategoria() {
        var request = new ArticuloSubCategRequest();
        when(subCategMapper.toEntity(any(ArticuloSubCategRequest.class))).thenReturn(subCategEntity);
        when(subCategService.create(any())).thenReturn(subCategEntity);
        when(subCategMapper.toResponse(subCategEntity)).thenReturn(subCategResponse);
        var result = controller.createSubCategoria(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(10L);
    }
}
