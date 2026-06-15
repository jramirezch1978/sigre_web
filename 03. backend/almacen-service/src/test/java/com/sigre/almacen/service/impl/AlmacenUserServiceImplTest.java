package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.entity.AlmacenUser;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.AlmacenUserRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlmacenUserServiceImplTest {

    @Mock
    private AlmacenUserRepository repository;

    @Mock
    private AlmacenRepository almacenRepository;

    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private AlmacenUserServiceImpl service;

    @Test
    void listarPorAlmacenId_lanzaSiAlmacenNoExiste() {
        when(almacenRepository.existsById(1L)).thenReturn(false);
        assertThatThrownBy(() -> service.listarPorAlmacenId(1L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Almacen");
        verify(repository, never()).findByAlmacenId(anyLong());
    }

    @Test
    void listarPorAlmacenId_retornaLista() {
        when(almacenRepository.existsById(2L)).thenReturn(true);
        List<AlmacenUser> rows = List.of(new AlmacenUser());
        when(repository.findByAlmacenId(2L)).thenReturn(rows);
        assertThat(service.listarPorAlmacenId(2L)).isSameAs(rows);
    }

    @Test
    void listarPorAlmacenId_conFiltroUsuario() {
        when(almacenRepository.existsById(4L)).thenReturn(true);
        List<AlmacenUser> rows = List.of(new AlmacenUser());
        when(repository.findAllByAlmacenIdAndUsuarioId(4L, 50L)).thenReturn(rows);
        assertThat(service.listarPorAlmacenId(4L, null, 50L)).isSameAs(rows);
    }

    @Test
    void listarPorAlmacenId_conFiltroFlagYUsuario() {
        when(almacenRepository.existsById(5L)).thenReturn(true);
        List<AlmacenUser> rows = List.of(new AlmacenUser());
        when(repository.findByAlmacenIdAndFlagEstadoAndUsuarioId(5L, "1", 60L)).thenReturn(rows);
        assertThat(service.listarPorAlmacenId(5L, "1", 60L)).isSameAs(rows);
    }

    @Test
    void listarPorAlmacenId_conFiltroFlag() {
        when(almacenRepository.existsById(3L)).thenReturn(true);
        List<AlmacenUser> rows = List.of(new AlmacenUser());
        when(repository.findByAlmacenIdAndFlagEstado(3L, "1")).thenReturn(rows);
        assertThat(service.listarPorAlmacenId(3L, "1", null)).isSameAs(rows);
    }

    @Test
    void asignar_lanzaSiAlmacenNoExiste() {
        when(almacenRepository.existsById(10L)).thenReturn(false);
        assertThatThrownBy(() -> service.asignar(10L, 100L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Almacen");
        verify(jdbcTemplate, never()).queryForObject(anyString(), eq(Integer.class), any());
    }

    @Test
    void asignar_lanzaSiUsuarioNoExisteEnAuth() {
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(200L))).thenReturn(0);
        assertThatThrownBy(() -> service.asignar(10L, 200L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Usuario");
        verify(repository, never()).save(any());
    }

    @Test
    void asignar_lanzaSiUsuarioYaActivoEnAlmacen() {
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(300L))).thenReturn(1);
        AlmacenUser existing = new AlmacenUser();
        existing.setFlagEstado("1");
        when(repository.findFirstByAlmacenIdAndUsuarioId(10L, 300L)).thenReturn(Optional.of(existing));
        assertThatThrownBy(() -> service.asignar(10L, 300L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    BusinessException be = (BusinessException) ex;
                    assertThat(be.getMessage()).contains("ya está asignado");
                    assertThat(be.getStatus()).isEqualTo(HttpStatus.CONFLICT);
                    assertThat(be.getErrorCode()).isEqualTo("ALMACEN_USUARIO_DUPLICADO");
                });
        verify(repository, never()).save(any());
    }

    @Test
    void asignar_reactivaAsignacionInactiva() {
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(301L))).thenReturn(1);
        AlmacenUser existing = new AlmacenUser();
        existing.setId(55L);
        existing.setAlmacenId(10L);
        existing.setUsuarioId(301L);
        existing.setFlagEstado("0");
        when(repository.findFirstByAlmacenIdAndUsuarioId(10L, 301L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenAnswer(i -> i.getArgument(0));
        AlmacenUser out = service.asignar(10L, 301L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        verify(repository).save(existing);
    }

    @Test
    void asignar_creaNuevaFilaCuandoNoExiste() {
        when(almacenRepository.existsById(11L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(400L))).thenReturn(1);
        when(repository.findFirstByAlmacenIdAndUsuarioId(11L, 400L)).thenReturn(Optional.empty());
        when(repository.save(any(AlmacenUser.class))).thenAnswer(i -> {
            AlmacenUser r = i.getArgument(0);
            r.setId(99L);
            return r;
        });
        AlmacenUser out = service.asignar(11L, 400L);
        assertThat(out.getId()).isEqualTo(99L);
        assertThat(out.getAlmacenId()).isEqualTo(11L);
        assertThat(out.getUsuarioId()).isEqualTo(400L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void desasignar_lanzaSiAlmacenNoExiste() {
        when(almacenRepository.existsById(20L)).thenReturn(false);
        assertThatThrownBy(() -> service.desasignar(20L, 500L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    @Test
    void desasignar_lanzaSiNoHayAsignacion() {
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(repository.findFirstByAlmacenIdAndUsuarioId(20L, 500L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.desasignar(20L, 500L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Asignacion almacen-usuario");
        verify(repository, never()).save(any());
    }

    @Test
    void desasignar_eliminaCuandoExiste() {
        when(almacenRepository.existsById(20L)).thenReturn(true);
        AlmacenUser row = new AlmacenUser();
        row.setId(12L);
        when(repository.findFirstByAlmacenIdAndUsuarioId(20L, 501L)).thenReturn(Optional.of(row));
        when(repository.save(any(AlmacenUser.class))).thenAnswer(i -> i.getArgument(0));
        AlmacenUser out = service.desasignar(20L, 501L);
        assertThat(out.getFlagEstado()).isEqualTo("0");
        verify(repository).save(row);
    }
}
