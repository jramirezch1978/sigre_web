package com.sigre.compras.service.impl;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.compras.entity.ArticuloPrecioPactado;
import com.sigre.compras.repository.ArticuloPrecioPactadoRepository;
import com.sigre.compras.repository.ArticuloRefRepository;
import com.sigre.compras.repository.EntidadContribuyenteRefRepository;
import com.sigre.compras.repository.MonedaRefRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ArticuloPrecioPactadoServiceImpl — Pruebas Unitarias")
class ArticuloPrecioPactadoServiceImplTest {

    @Mock private ArticuloPrecioPactadoRepository repository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;

    @InjectMocks private ArticuloPrecioPactadoServiceImpl service;

    // ── findAll ──

    @Test
    @DisplayName("findAll() sin filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void findAll_sinFiltros_retornaPagina() {
        Page<ArticuloPrecioPactado> page = new PageImpl<>(List.of(articuloPrecioPactado(1L)));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<ArticuloPrecioPactado> result = service.findAll(null, null, PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findAll() con artículo id -> retorna página")
    @SuppressWarnings("unchecked")
    void findAll_conArticuloId_retornaPagina() {
        Page<ArticuloPrecioPactado> page = new PageImpl<>(List.of(articuloPrecioPactado(1L)));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<ArticuloPrecioPactado> result = service.findAll(100L, null, PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findAll() con proveedor id -> retorna página")
    @SuppressWarnings("unchecked")
    void findAll_conProveedorId_retornaPagina() {
        Page<ArticuloPrecioPactado> page = new PageImpl<>(List.of(articuloPrecioPactado(1L)));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<ArticuloPrecioPactado> result = service.findAll(null, 10L, PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
    }

    // ── findById ──

    @Test
    @DisplayName("findById() existente -> ok")
    void findById_existente_ok() {
        ArticuloPrecioPactado entity = articuloPrecioPactado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        ArticuloPrecioPactado result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById() no existente -> lanza excepción")
    void findById_noExistente_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── create ──

    @Test
    @DisplayName("create() ok")
    void create_ok() {
        mockAllForeignKeysValid();
        ArticuloPrecioPactado entity = articuloPrecioPactado(null);
        ArticuloPrecioPactado saved = articuloPrecioPactado(1L);
        when(repository.save(any(ArticuloPrecioPactado.class))).thenReturn(saved);

        ArticuloPrecioPactado result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() artículo no existe -> lanza excepción")
    void create_articuloNoExiste_lanzaExcepcion() {
        when(articuloRefRepository.existsById(100L)).thenReturn(false);

        ArticuloPrecioPactado entity = articuloPrecioPactado(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("create() proveedor no existe -> lanza excepción")
    void create_proveedorNoExiste_lanzaExcepcion() {
        when(articuloRefRepository.existsById(100L)).thenReturn(true);
        when(entidadContribuyenteRefRepository.existsById(10L)).thenReturn(false);

        ArticuloPrecioPactado entity = articuloPrecioPactado(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("create() moneda no existe -> lanza excepción")
    void create_monedaNoExiste_lanzaExcepcion() {
        when(articuloRefRepository.existsById(100L)).thenReturn(true);
        when(entidadContribuyenteRefRepository.existsById(10L)).thenReturn(true);
        when(monedaRefRepository.existsById(1L)).thenReturn(false);

        ArticuloPrecioPactado entity = articuloPrecioPactado(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── update ──

    @Test
    @DisplayName("update() ok")
    void update_ok() {
        ArticuloPrecioPactado existing = articuloPrecioPactado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        mockAllForeignKeysValid();
        ArticuloPrecioPactado toUpdate = articuloPrecioPactado(null);
        when(repository.save(toUpdate)).thenReturn(existing);

        ArticuloPrecioPactado result = service.update(1L, toUpdate);

        assertThat(result).isNotNull();
        assertThat(toUpdate.getId()).isEqualTo(1L);
        verify(repository).save(toUpdate);
    }

    // ── delete ──

    @Test
    @DisplayName("delete() ok")
    void delete_ok() {
        ArticuloPrecioPactado existing = articuloPrecioPactado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.delete(1L);

        verify(repository).deleteById(1L);
    }

    // ── activate / deactivate ──

    @Test
    @DisplayName("activate() ok")
    void activate_ok() {
        ArticuloPrecioPactado existing = articuloPrecioPactado(1L);
        existing.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        ArticuloPrecioPactado result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("deactivate() ok")
    void deactivate_ok() {
        ArticuloPrecioPactado existing = articuloPrecioPactado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        ArticuloPrecioPactado result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(repository).save(existing);
    }

    // ── Helpers ──

    private void mockAllForeignKeysValid() {
        when(articuloRefRepository.existsById(100L)).thenReturn(true);
        when(entidadContribuyenteRefRepository.existsById(10L)).thenReturn(true);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
    }
}
