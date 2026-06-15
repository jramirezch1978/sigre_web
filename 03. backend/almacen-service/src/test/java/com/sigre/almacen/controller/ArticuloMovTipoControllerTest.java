package com.sigre.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.ArticuloMovTipoRequest;
import com.sigre.almacen.dto.ArticuloMovTipoResponse;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.mapper.ArticuloMovTipoMapper;
import com.sigre.almacen.service.ArticuloMovTipoService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Bloque A: PATCH activar / desactivar en ArticuloMovTipoController.
 */
@ExtendWith(MockitoExtension.class)
class ArticuloMovTipoControllerTest {

    @Mock
    private ArticuloMovTipoService service;
    @Mock
    private ArticuloMovTipoMapper mapper;
    @InjectMocks
    private ArticuloMovTipoController controller;

    private ArticuloMovTipo entity;
    private ArticuloMovTipoResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloMovTipo();
        entity.setId(3L);
        entity.setTipoMov("E02");
        entity.setDescTipoMov("Test");
        entity.setFlagContabiliza("0");
        entity.setFlagAjusteValorizacion("0");
        entity.setFlagMovEntreAlm("0");
        entity.setFlagSolicitaProv("0");
        entity.setFlagSolicitaDocInt("0");
        entity.setFlagSolicitaDocExt("0");
        entity.setFlagSolicitaRef("0");
        entity.setFlagSolicitaLote("0");
        entity.setFlagSolicitaCenbef("0");
        entity.setFlagSolicitaPrecio("0");
        entity.setFactorSldoTotal(BigDecimal.ONE);
        entity.setFactorSldoXLlegar(BigDecimal.ZERO);
        entity.setFactorSldoSol(BigDecimal.ZERO);
        entity.setFactorSldoDev(BigDecimal.ZERO);
        entity.setFactorSldoPres(BigDecimal.ZERO);
        entity.setFactorSldoConsig(BigDecimal.ZERO);
        entity.setFactorCtrlTempla(BigDecimal.ZERO);
        response = new ArticuloMovTipoResponse();
        response.setId(3L);
        response.setTipoMov("E02");
    }

    @Test
    void findAll_devuelvePagina() {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(response));

        var out = controller.findAll(Pageable.unpaged());

        assertThat(out.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_devuelveRegistro() {
        when(service.findById(3L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        assertThat(controller.findById(3L).getData().getTipoMov()).isEqualTo("E02");
    }

    @Test
    void create_mapeaYPersiste() {
        ArticuloMovTipoRequest req = new ArticuloMovTipoRequest();
        req.setTipoMov("I99");
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        assertThat(controller.create(req).getData().getId()).isEqualTo(3L);
    }

    @Test
    void update_mapeaYActualiza() {
        ArticuloMovTipoRequest req = new ArticuloMovTipoRequest();
        req.setTipoMov("E02");
        when(service.findById(3L)).thenReturn(entity);
        when(service.update(eq(3L), any(ArticuloMovTipo.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        assertThat(controller.update(3L, req).getData().getId()).isEqualTo(3L);
        verify(mapper).updateEntity(req, entity);
    }

    @Test
    void delete_delegaEnServicio() {
        controller.delete(3L);
        verify(service).delete(3L);
    }

    @Test
    void activar_poneFlag1YllamaUpdate() {
        when(service.findById(3L)).thenReturn(entity);
        when(service.update(eq(3L), any(ArticuloMovTipo.class))).thenAnswer(i -> i.getArgument(1));
        when(mapper.toResponse(any(ArticuloMovTipo.class))).thenReturn(response);
        var out = controller.activate(3L);
        assertThat(out.getData().getId()).isEqualTo(3L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        verify(service).update(eq(3L), any(ArticuloMovTipo.class));
    }

    @Test
    void desactivar_poneFlag0YllamaUpdate() {
        when(service.findById(3L)).thenReturn(entity);
        when(service.update(eq(3L), any(ArticuloMovTipo.class))).thenAnswer(i -> i.getArgument(1));
        when(mapper.toResponse(any(ArticuloMovTipo.class))).thenReturn(response);
        controller.deactivate(3L);
        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(service).update(eq(3L), any(ArticuloMovTipo.class));
    }
}
