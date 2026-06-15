package com.sigre.compras.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.compras.entity.AprobadorConfigurado;
import com.sigre.compras.repository.AprobadorConfiguradoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AprobadorConfiguradoServiceImpl — Pruebas Unitarias")
class AprobadorConfiguradoServiceImplTest {

    @Mock private AprobadorConfiguradoRepository repository;
    @Mock private JdbcTemplate securityJdbcTemplate;

    private AprobadorConfiguradoServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new AprobadorConfiguradoServiceImpl(repository, securityJdbcTemplate);
    }

    // ── findAll ──

    @Test
    @DisplayName("findAll() retorna página")
    void findAll_retornaPagina() {
        AprobadorConfigurado entity = aprobadorConfigurado(1L);
        Page<AprobadorConfigurado> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(Pageable.class))).thenReturn(page);

        Page<AprobadorConfigurado> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ── findById ──

    @Test
    @DisplayName("findById() existente -> retorna entity")
    void findById_existente_retornaEntity() {
        AprobadorConfigurado entity = aprobadorConfigurado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        AprobadorConfigurado result = service.findById(1L);

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
    @DisplayName("create() ok valida y guarda")
    void create_ok_validaYGuarda() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        AprobadorConfigurado entity = aprobadorConfigurado(null);
        AprobadorConfigurado saved = aprobadorConfigurado(1L);
        when(repository.save(entity)).thenReturn(saved);

        AprobadorConfigurado result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(securityJdbcTemplate).queryForObject(contains("auth.usuario"), eq(Integer.class), any());
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() aprobador no existe -> lanza excepción")
    void create_aprobadorNoExiste_lanzaExcepcion() {
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(0);

        AprobadorConfigurado entity = aprobadorConfigurado(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── update ──

    @Test
    @DisplayName("update() ok")
    void update_ok() {
        AprobadorConfigurado existing = aprobadorConfigurado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any()))
                .thenReturn(1);
        AprobadorConfigurado toUpdate = aprobadorConfigurado(null);
        when(repository.save(toUpdate)).thenReturn(existing);

        AprobadorConfigurado result = service.update(1L, toUpdate);

        assertThat(result).isNotNull();
        assertThat(toUpdate.getId()).isEqualTo(1L);
        verify(repository).save(toUpdate);
    }

    @Test
    @DisplayName("update() no existe -> lanza excepción")
    void update_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(99L, aprobadorConfigurado(null)))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── delete ──

    @Test
    @DisplayName("delete() ok")
    void delete_ok() {
        AprobadorConfigurado existing = aprobadorConfigurado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.delete(1L);

        verify(repository).deleteById(1L);
    }

    @Test
    @DisplayName("delete() no existe -> lanza excepción")
    void delete_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── activate / deactivate ──

    @Test
    @DisplayName("activate() ok")
    void activate_ok() {
        AprobadorConfigurado existing = aprobadorConfigurado(1L);
        existing.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        AprobadorConfigurado result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("deactivate() ok")
    void deactivate_ok() {
        AprobadorConfigurado existing = aprobadorConfigurado(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        AprobadorConfigurado result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(repository).save(existing);
    }

}
