package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.entity.LotePallet;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.LotePalletRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Bloque B: lote_pallet — FK almacén, artículo (core) y unidad lote.
 */
@ExtendWith(MockitoExtension.class)
class LotePalletServiceImplTest {

    @Mock
    private LotePalletRepository repository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private JdbcTemplate jdbcTemplate;
    @InjectMocks
    private LotePalletServiceImpl service;

    private LotePallet lote;

    @BeforeEach
    void setUp() {
        lote = new LotePallet();
        lote.setAlmacenId(1L);
        lote.setArticuloId(200L);
        lote.setNroLote("L-2026-01");
    }

    @Test
    void create_lanzaSiAlmacenNoExiste() {
        when(almacenRepository.existsById(1L)).thenReturn(false);
        assertThatThrownBy(() -> service.create(lote))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void create_lanzaSiArticuloNoExiste() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(0);
        assertThatThrownBy(() -> service.create(lote))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void create_lanzaSiDuplicadoNroLote() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCase(1L, 200L, "L-2026-01"))
                .thenReturn(true);
        assertThatThrownBy(() -> service.create(lote))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "LOTE_PALLET_DUPLICADO");
    }

    @Test
    void create_ok() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCase(1L, 200L, "L-2026-01"))
                .thenReturn(false);
        when(repository.save(any(LotePallet.class))).thenAnswer(i -> {
            LotePallet o = i.getArgument(0);
            o.setId(10L);
            return o;
        });
        LotePallet out = service.create(lote);
        assertThat(out.getId()).isEqualTo(10L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void buscar_devuelvePagina() {
        lote.setId(10L);
        when(repository.findFiltrado(1L, 200L, Pageable.unpaged()))
                .thenReturn(new PageImpl<>(java.util.List.of(lote)));

        assertThat(service.buscar(1L, 200L, Pageable.unpaged()).getContent()).hasSize(1);
    }

    @Test
    void findById_ok() {
        lote.setId(10L);
        when(repository.findById(10L)).thenReturn(java.util.Optional.of(lote));

        assertThat(service.findById(10L).getNroLote()).isEqualTo("L-2026-01");
    }

    @Test
    void findById_notFound() {
        when(repository.findById(99L)).thenReturn(java.util.Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void update_ok() {
        lote.setId(10L);
        LotePallet cambios = new LotePallet();
        cambios.setAlmacenId(1L);
        cambios.setArticuloId(200L);
        cambios.setNroLote("L-2026-02");
        cambios.setObservacion("obs");
        when(repository.findById(10L)).thenReturn(java.util.Optional.of(lote));
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCaseAndIdNot(1L, 200L, "L-2026-02", 10L))
                .thenReturn(false);
        when(repository.save(any(LotePallet.class))).thenAnswer(i -> i.getArgument(0));

        LotePallet updated = service.update(10L, cambios);

        assertThat(updated.getNroLote()).isEqualTo("L-2026-02");
        assertThat(updated.getObservacion()).isEqualTo("obs");
    }

    @Test
    void update_lanzaSiDuplicadoNroLote() {
        lote.setId(10L);
        LotePallet cambios = new LotePallet();
        cambios.setAlmacenId(1L);
        cambios.setArticuloId(200L);
        cambios.setNroLote("L-DUP");
        when(repository.findById(10L)).thenReturn(java.util.Optional.of(lote));
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCaseAndIdNot(1L, 200L, "L-DUP", 10L))
                .thenReturn(true);

        assertThatThrownBy(() -> service.update(10L, cambios))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "LOTE_PALLET_DUPLICADO");
    }

    @Test
    void activate_yDeactivate() {
        lote.setId(11L);
        when(repository.findById(11L)).thenReturn(java.util.Optional.of(lote));
        when(repository.save(any(LotePallet.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.activate(11L).getFlagEstado()).isEqualTo("1");
        assertThat(service.deactivate(11L).getFlagEstado()).isEqualTo("0");
    }

    @Test
    void create_respetaFlagEstadoExistente() {
        lote.setFlagEstado("0");
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCase(1L, 200L, "L-2026-01"))
                .thenReturn(false);
        when(repository.save(any(LotePallet.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.create(lote).getFlagEstado()).isEqualTo("0");
    }

    @Test
    void update_lanzaSiAlmacenNoExiste() {
        lote.setId(10L);
        LotePallet cambios = new LotePallet();
        cambios.setAlmacenId(99L);
        cambios.setArticuloId(200L);
        cambios.setNroLote("L-2026-02");
        when(repository.findById(10L)).thenReturn(java.util.Optional.of(lote));

        assertThatThrownBy(() -> service.update(10L, cambios))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void update_lanzaSiNroLoteDuplicado() {
        lote.setId(10L);
        LotePallet cambios = new LotePallet();
        cambios.setAlmacenId(1L);
        cambios.setArticuloId(200L);
        cambios.setNroLote("L-DUP");
        when(repository.findById(10L)).thenReturn(java.util.Optional.of(lote));
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(200L)))
                .thenReturn(1);
        when(repository.existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCaseAndIdNot(1L, 200L, "L-DUP", 10L))
                .thenReturn(true);

        assertThatThrownBy(() -> service.update(10L, cambios))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "LOTE_PALLET_DUPLICADO");
    }
}
