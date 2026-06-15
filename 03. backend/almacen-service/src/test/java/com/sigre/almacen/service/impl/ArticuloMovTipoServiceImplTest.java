package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.repository.ArticuloMovTipoRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Bloque A: validación auto-referencia tipo_mov_dev (ArticuloMovTipoServiceImpl).
 */
@ExtendWith(MockitoExtension.class)
class ArticuloMovTipoServiceImplTest {

    @Mock
    private ArticuloMovTipoRepository repository;
    @InjectMocks
    private ArticuloMovTipoServiceImpl service;

    private ArticuloMovTipo tipo;

    @BeforeEach
    void setUp() {
        tipo = new ArticuloMovTipo();
        tipo.setId(1L);
        tipo.setTipoMov("E01");
        tipo.setDescTipoMov("Salida");
        tipo.setFlagContabiliza("0");
        tipo.setFlagAjusteValorizacion("0");
        tipo.setFlagMovEntreAlm("0");
        tipo.setFlagSolicitaProv("0");
        tipo.setFlagSolicitaDocInt("0");
        tipo.setFlagSolicitaDocExt("0");
        tipo.setFlagSolicitaRef("0");
        tipo.setFactorSldoTotal(BigDecimal.ONE);
        tipo.setFactorSldoXLlegar(BigDecimal.ZERO);
        tipo.setFactorSldoSol(BigDecimal.ZERO);
        tipo.setFactorSldoDev(BigDecimal.ZERO);
        tipo.setFactorSldoPres(BigDecimal.ZERO);
        tipo.setFactorSldoConsig(BigDecimal.ZERO);
        tipo.setFactorCtrlTempla(BigDecimal.ZERO);
        tipo.setFlagEstado("1");
    }

    @Test
    void create_rechazaTipoMovDevIguatATipoMov() {
        tipo.setTipoMov("X01");
        tipo.setTipoMovDev("x01");
        when(repository.existsByTipoMov("X01")).thenReturn(false);
        assertThatThrownBy(() -> service.create(tipo))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo_mov_dev no puede ser el mismo");
        verify(repository, never()).save(any());
    }

    @Test
    void create_rechazaSiTipoMovDevNoExisteEnOtroRegistro() {
        tipo.setTipoMov("E01");
        tipo.setTipoMovDev("NOEXISTE");
        when(repository.existsByTipoMov("E01")).thenReturn(false);
        when(repository.findByTipoMov("NOEXISTE")).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.create(tipo))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void create_okCuandoTipoMovDevApuntaARegistroExistente() {
        ArticuloMovTipo ref = new ArticuloMovTipo();
        ref.setId(2L);
        ref.setTipoMov("D01");
        tipo.setTipoMovDev("D01");
        when(repository.existsByTipoMov("E01")).thenReturn(false);
        when(repository.findByTipoMov("D01")).thenReturn(Optional.of(ref));
        when(repository.save(any(ArticuloMovTipo.class))).thenAnswer(i -> i.getArgument(0));
        ArticuloMovTipo out = service.create(tipo);
        assertThat(out.getTipoMov()).isEqualTo("E01");
        verify(repository).save(tipo);
    }

    @Test
    void create_tipoMovDevBlanco_omiteValidacionReferencia() {
        tipo.setTipoMovDev("   ");
        when(repository.existsByTipoMov("E01")).thenReturn(false);
        when(repository.save(any(ArticuloMovTipo.class))).thenAnswer(i -> i.getArgument(0));
        service.create(tipo);
        verify(repository, never()).findByTipoMov(anyString());
    }

    @Test
    void create_lanzaSiTipoMovDuplicado() {
        when(repository.existsByTipoMov("E01")).thenReturn(true);
        assertThatThrownBy(() -> service.create(tipo))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    @Test
    void findById_ok() {
        when(repository.findById(1L)).thenReturn(Optional.of(tipo));
        assertThat(service.findById(1L).getTipoMov()).isEqualTo("E01");
    }

    @Test
    void findById_notFound() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void findAll_lista() {
        when(repository.findAll()).thenReturn(java.util.List.of(tipo));
        assertThat(service.findAll()).hasSize(1);
    }

    @Test
    void findByTipoMov_notFound() {
        when(repository.findByTipoMov("ZZZ")).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findByTipoMov("ZZZ"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void findByTipoMov_ok() {
        when(repository.findByTipoMov("E01")).thenReturn(Optional.of(tipo));
        assertThat(service.findByTipoMov("E01").getId()).isEqualTo(1L);
    }

    @Test
    void delete_ok() {
        when(repository.existsById(1L)).thenReturn(true);
        service.delete(1L);
        verify(repository).deleteById(1L);
    }

    @Test
    void delete_notFound() {
        when(repository.existsById(5L)).thenReturn(false);
        assertThatThrownBy(() -> service.delete(5L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Nested
    @DisplayName("update() revalida tipo_mov_dev")
    class Update {
        @Test
        void update_igualMismoErrorQueCreate() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipo));
            when(repository.existsByTipoMovAndIdNot("E01", 1L)).thenReturn(false);
            tipo.setTipoMov("E01");
            tipo.setTipoMovDev("E01");
            assertThatThrownBy(() -> service.update(1L, tipo))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void update_ok() {
            when(repository.findById(1L)).thenReturn(Optional.of(tipo));
            when(repository.existsByTipoMovAndIdNot("E01", 1L)).thenReturn(false);
            when(repository.save(any(ArticuloMovTipo.class))).thenAnswer(i -> i.getArgument(0));
            ArticuloMovTipo out = service.update(1L, tipo);
            assertThat(out.getId()).isEqualTo(1L);
        }
    }
}
