package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.core.dto.ArticuloSubCategRequest;
import com.sigre.core.dto.ArticuloSubCategResponse;
import com.sigre.core.entity.ArticuloSubCateg;
import com.sigre.core.mapper.ArticuloSubCategMapper;
import com.sigre.core.service.ArticuloSubCategService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloSubCategControllerTest {

    @Mock private ArticuloSubCategService service;
    @Mock private ArticuloSubCategMapper mapper;
    @InjectMocks private ArticuloSubCategController controller;

    private ArticuloSubCateg entity;
    private ArticuloSubCategResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloSubCateg();
        entity.setId(1L);
        entity.setCodSubCat("SUB01");
        entity.setDescSubcateg("Sub Categoria 1");
        entity.setArticuloCategId(10L);
        entity.setFlagEstado("1");

        response = new ArticuloSubCategResponse();
        response.setId(1L);
        response.setCodSubCat("SUB01");
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ArticuloSubCategRequest());
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
}
