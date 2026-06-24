package com.sigre.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.entity.*;
import com.sigre.rrhh.mapper.CalculoMapper;
import com.sigre.rrhh.repository.*;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CalculoServiceImpl — Pruebas Unitarias")
class CalculoServiceImplTest {

    @Mock private CalculoRepository calculoRepo;
    @Mock private CalculoDetRepository calculoDetRepo;
    @Mock private TipoPlanillaRepository tipoPlanillaRepo;
    @Mock private CalculoMapper mapper;
    @Mock private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private CalculoServiceImpl service;

    @Captor
    private ArgumentCaptor<Calculo> calculoCaptor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    // ═══════════════════════════════════════════════════
    // listar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(calculoRepo.findWithFilters(any(), any(), any(), any()))
            .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.calculo(1L))));
        when(mapper.toResponse(any(), anyInt())).thenReturn(RrhhTestFixtures.calculoResponse(1L));

        Page<CalculoResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(calculoRepo).findWithFilters(null, null, null, pageable);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() {
        Pageable pageable = Pageable.ofSize(10);
        when(calculoRepo.findWithFilters(eq(2026), eq(6), eq(1L), any()))
            .thenReturn(new PageImpl<>(List.of()));

        service.listar(2026, 6, 1L, pageable);

        verify(calculoRepo).findWithFilters(2026, 6, 1L, pageable);
    }

    // ═══════════════════════════════════════════════════
    // obtenerDetalle()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerDetalle() con ID existente -> retorna detalle")
    void obtenerDetalle_idExistente_retornaDetalle() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        List<CalculoDet> detalles = List.of(RrhhTestFixtures.calculoDet(1L, 1L));
        when(calculoRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(calculoDetRepo.findByCalculoIdOrderByConceptoIdAscItemAsc(1L)).thenReturn(detalles);
        when(mapper.toDetalleResponse(entity, detalles)).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        CalculoDetalleResponse result = service.obtenerDetalle(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerDetalle() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerDetalle_idInexistente_lanzaResourceNotFoundException() {
        when(calculoRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerDetalle(999L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    // ═══════════════════════════════════════════════════
    // procesar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("procesar() -> invoca sp_calcular_planilla y devuelve resumen")
    void procesar_invocaStoredProcedure() {
        TipoPlanilla tipoPlanilla = RrhhTestFixtures.tipoPlanilla(1L, "N");
        when(jdbcTemplate.update(anyString(), any(Object[].class))).thenReturn(0);
        when(tipoPlanillaRepo.findByCodigo("N")).thenReturn(Optional.of(tipoPlanilla));
        when(calculoRepo.findWithFilters(eq(2026), eq(6), eq(1L), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        CalculoDetalleResponse resp = service.procesar(2026, 6, "N", "PI");

        assertThat(resp.getAnio()).isEqualTo(2026);
        assertThat(resp.getMes()).isEqualTo(6);
        assertThat(resp.getTotalTrabajadores()).isZero();
        verify(jdbcTemplate).update(contains("sp_calcular_planilla"), any(Object[].class));
    }

    // ═══════════════════════════════════════════════════
    // eliminar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> elimina cálculo y sus detalles")
    void eliminar_eliminaCalculoYDetalles() {
        Calculo entity = RrhhTestFixtures.calculo(1L);
        when(calculoRepo.findById(1L)).thenReturn(Optional.of(entity));

        service.eliminar(1L);

        verify(calculoDetRepo).deleteByCalculoId(1L);
        verify(calculoRepo).delete(entity);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminar_idInexistente_lanzaResourceNotFoundException() {
        when(calculoRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.eliminar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(calculoDetRepo, never()).deleteByCalculoId(any());
        verify(calculoRepo, never()).delete(any());
    }
}
