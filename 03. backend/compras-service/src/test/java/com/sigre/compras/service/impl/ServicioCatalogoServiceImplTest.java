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
import com.sigre.compras.entity.ServicioCatalogo;
import com.sigre.compras.repository.ServicioCatalogoRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ServicioCatalogoServiceImpl — Pruebas Unitarias")
class ServicioCatalogoServiceImplTest {

    @Mock private ServicioCatalogoRepository repository;

    @InjectMocks private ServicioCatalogoServiceImpl service;

    // ── findAll ──

    @Test
    @DisplayName("findAll() retorna página")
    void findAll_retornaPagina() {
        ServicioCatalogo sc = servicioCatalogo(1L);
        Page<ServicioCatalogo> page = new PageImpl<>(List.of(sc));
        when(repository.findAll(any(Pageable.class))).thenReturn(page);

        Page<ServicioCatalogo> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ── findById ──

    @Test
    @DisplayName("findById() existente -> ok")
    void findById_existente_ok() {
        ServicioCatalogo sc = servicioCatalogo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(sc));

        ServicioCatalogo result = service.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getServicio()).isEqualTo("SRV001");
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
        ServicioCatalogo entity = servicioCatalogo(null);
        when(repository.existsByServicioIgnoreCase("SRV001")).thenReturn(false);
        ServicioCatalogo saved = servicioCatalogo(1L);
        when(repository.save(any(ServicioCatalogo.class))).thenReturn(saved);

        ServicioCatalogo result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() duplicado -> lanza excepción")
    void create_duplicado_lanzaExcepcion() {
        ServicioCatalogo entity = servicioCatalogo(null);
        when(repository.existsByServicioIgnoreCase("SRV001")).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    // ── update ──

    @Test
    @DisplayName("update() ok")
    void update_ok() {
        ServicioCatalogo existing = servicioCatalogo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByServicioIgnoreCaseAndIdNot("SRV001", 1L)).thenReturn(false);
        ServicioCatalogo updated = servicioCatalogo(1L);
        when(repository.save(any(ServicioCatalogo.class))).thenReturn(updated);

        ServicioCatalogo entity = servicioCatalogo(null);
        ServicioCatalogo result = service.update(1L, entity);

        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("update() duplicado -> lanza excepción")
    void update_duplicado_lanzaExcepcion() {
        ServicioCatalogo existing = servicioCatalogo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByServicioIgnoreCaseAndIdNot("SRV001", 1L)).thenReturn(true);

        ServicioCatalogo entity = servicioCatalogo(null);

        assertThatThrownBy(() -> service.update(1L, entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    // ── delete ──

    @Test
    @DisplayName("delete() ok")
    void delete_ok() {
        ServicioCatalogo existing = servicioCatalogo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.delete(1L);

        verify(repository).deleteById(1L);
    }

    // ── activate / deactivate ──

    @Test
    @DisplayName("activate() ok")
    void activate_ok() {
        ServicioCatalogo existing = servicioCatalogo(1L);
        existing.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(ServicioCatalogo.class))).thenReturn(existing);

        ServicioCatalogo result = service.activate(1L);

        assertThat(result).isNotNull();
        assertThat(existing.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("deactivate() ok")
    void deactivate_ok() {
        ServicioCatalogo existing = servicioCatalogo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any(ServicioCatalogo.class))).thenReturn(existing);

        ServicioCatalogo result = service.deactivate(1L);

        assertThat(result).isNotNull();
        assertThat(existing.getFlagEstado()).isEqualTo("0");
    }

}
