package com.sigre.compras.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.compras.dto.*;
import com.sigre.compras.entity.ProgramacionCompras;
import com.sigre.compras.entity.ProgramacionComprasDet;
import com.sigre.compras.mapper.ProgramacionComprasMapper;
import com.sigre.compras.repository.ProgramacionComprasRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProgramacionComprasServiceImpl — Pruebas Unitarias")
class ProgramacionComprasServiceImplTest {

    @Mock private ProgramacionComprasRepository repository;
    @Mock private ProgramacionComprasMapper mapper;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks private ProgramacionComprasServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── listar ──

    @Test
    @DisplayName("listar() con todos los filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_conTodosLosFiltros_retornaPagina() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        Page<ProgramacionCompras> page = new PageImpl<>(List.of(entity));

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(
                ProgramacionComprasResponse.builder().id(1L).numero("PC-001").build());

        Page<ProgramacionComprasResponse> result = service.listar(2026, 4, "BORRADOR", Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getNumero()).isEqualTo("PC-001");
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_sinFiltros_retornaPagina() {
        Page<ProgramacionCompras> page = new PageImpl<>(List.of(programacionCompras(1L, "1")));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(
                ProgramacionComprasResponse.builder().id(1L).build());

        Page<ProgramacionComprasResponse> result = service.listar(null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() solo anio -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloAnio_filtra() {
        Page<ProgramacionCompras> page = new PageImpl<>(Collections.emptyList());
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<ProgramacionComprasResponse> result = service.listar(2026, null, null, Pageable.unpaged());

        assertThat(result.getContent()).isEmpty();
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() solo mes -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloMes_filtra() {
        Page<ProgramacionCompras> page = new PageImpl<>(Collections.emptyList());
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);

        Page<ProgramacionComprasResponse> result = service.listar(null, 5, null, Pageable.unpaged());

        assertThat(result.getContent()).isEmpty();
    }

    @Test
    @DisplayName("listar() estado blank -> ignora filtro estado")
    @SuppressWarnings("unchecked")
    void listar_estadoBlank_ignoraFiltroEstado() {
        Page<ProgramacionCompras> page = new PageImpl<>(List.of(programacionCompras(1L, "1")));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(
                ProgramacionComprasResponse.builder().id(1L).build());

        Page<ProgramacionComprasResponse> result = service.listar(null, null, "  ", Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() sin sucursal -> no filtra por sucursal")
    @SuppressWarnings("unchecked")
    void listar_sinSucursal_noFiltraPorSucursal() {
        TenantContext.setSucursalId(null);
        Page<ProgramacionCompras> page = new PageImpl<>(List.of(programacionCompras(1L, "1")));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(
                ProgramacionComprasResponse.builder().id(1L).build());

        Page<ProgramacionComprasResponse> result = service.listar(null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasDetalleResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNumero()).isEqualTo("PC-001");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok -> genera nro y guarda")
    void crear_ok_generaNroYGuarda() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("PC-001");
        when(mapper.toDetEntity(any())).thenReturn(new ProgramacionComprasDet());

        ProgramacionCompras saved = programacionCompras(1L, "1");
        when(repository.save(any(ProgramacionCompras.class))).thenReturn(saved);
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasRequest request = programacionComprasRequest();
        ProgramacionComprasDetalleResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(numeradorDocumentoService).siguienteNroDocumento(eq("compras.prog_compras"), eq(1L), eq(2026));
        verify(repository).save(any(ProgramacionCompras.class));
    }

    @Test
    @DisplayName("crear() con multiples líneas todas se guardan")
    void crear_conMultiplesLineas_todasSeGuardan() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("PC-002");
        when(mapper.toDetEntity(any())).thenReturn(new ProgramacionComprasDet());

        ProgramacionCompras saved = programacionCompras(2L, "1");
        when(repository.save(any(ProgramacionCompras.class))).thenReturn(saved);
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(2L).numero("PC-002").lineas(Collections.emptyList()).build());

        ProgramacionComprasRequest req = new ProgramacionComprasRequest();
        req.setAnio(2026);
        req.setMes(5);
        ProgramacionComprasDetRequest d1 = new ProgramacionComprasDetRequest();
        d1.setArticuloId(100L);
        d1.setCantidad(new BigDecimal("10"));
        ProgramacionComprasDetRequest d2 = new ProgramacionComprasDetRequest();
        d2.setArticuloId(200L);
        d2.setCantidad(new BigDecimal("30"));
        ProgramacionComprasDetRequest d3 = new ProgramacionComprasDetRequest();
        d3.setArticuloId(300L);
        d3.setCantidad(new BigDecimal("50"));
        req.setLineas(List.of(d1, d2, d3));

        ProgramacionComprasDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(mapper, times(3)).toDetEntity(any());
        verify(repository).save(argThat(entity ->
                entity.getLineas().size() == 3));
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() borrador -> ok")
    void actualizar_borrador_ok() {
        ProgramacionCompras existing = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(mapper.toDetEntity(any())).thenReturn(new ProgramacionComprasDet());
        when(repository.save(any(ProgramacionCompras.class))).thenReturn(existing);
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasDetalleResponse result = service.actualizar(1L, programacionComprasRequest());

        assertThat(result).isNotNull();
        verify(repository).save(any(ProgramacionCompras.class));
    }

    @Test
    @DisplayName("actualizar() no borrador -> lanza excepción")
    void actualizar_noBorrador_lanzaExcepcion() {
        ProgramacionCompras existing = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, programacionComprasRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("actualizar() no existe -> lanza excepción")
    void actualizar_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(99L, programacionComprasRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() reemplaza líneas existentes")
    void actualizar_reemplazaLineasExistentes() {
        ProgramacionCompras existing = programacionCompras(1L, "1");
        assertThat(existing.getLineas()).hasSize(1);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(mapper.toDetEntity(any())).thenReturn(new ProgramacionComprasDet());
        when(repository.save(any(ProgramacionCompras.class))).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasRequest req = new ProgramacionComprasRequest();
        req.setAnio(2026);
        req.setMes(6);
        ProgramacionComprasDetRequest d1 = new ProgramacionComprasDetRequest();
        d1.setArticuloId(200L);
        d1.setCantidad(new BigDecimal("15"));
        ProgramacionComprasDetRequest d2 = new ProgramacionComprasDetRequest();
        d2.setArticuloId(300L);
        d2.setCantidad(new BigDecimal("25"));
        req.setLineas(List.of(d1, d2));

        service.actualizar(1L, req);

        verify(repository).save(argThat(entity -> {
            assertThat(entity.getAnio()).isEqualTo(2026);
            assertThat(entity.getMes()).isEqualTo(6);
            assertThat(entity.getUpdatedBy()).isEqualTo(1L);
            return true;
        }));
    }

    @Test
    @DisplayName("actualizar() anulada -> lanza excepción")
    void actualizar_anulada_lanzaExcepcion() {
        ProgramacionCompras existing = programacionCompras(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, programacionComprasRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("actualizar() ejecutada -> lanza excepción")
    void actualizar_ejecutada_lanzaExcepcion() {
        ProgramacionCompras existing = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, programacionComprasRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    // ── confirmar ──

    @Test
    @DisplayName("confirmar() borrador -> ok")
    void confirmar_borrador_ok() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionCompras.class))).thenReturn(entity);
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasDetalleResponse result = service.confirmar(1L);

        assertThat(result).isNotNull();
        assertThat(entity.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("confirmar() no borrador -> lanza excepción")
    void confirmar_noBorrador_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.confirmar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("confirmar() no existe -> lanza excepción")
    void confirmar_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.confirmar(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("confirmar() anulada -> lanza excepción")
    void confirmar_anulada_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.confirmar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("confirmar() ejecutada -> lanza excepción")
    void confirmar_ejecutada_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.confirmar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("confirmar() asigna updated by")
    void confirmar_asignaUpdatedBy() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder().id(1L).build());

        service.confirmar(1L);

        verify(repository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            assertThat(e.getFlagEstado()).isEqualTo("2");
            return true;
        }));
    }

    // ── anular ──

    @Test
    @DisplayName("anular() borrador -> ok")
    void anular_borrador_ok() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionCompras.class))).thenReturn(entity);
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder()
                        .id(1L).numero("PC-001").lineas(Collections.emptyList()).build());

        ProgramacionComprasDetalleResponse result = service.anular(1L);

        assertThat(result).isNotNull();
        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() confirmada -> lanza excepción")
    void anular_confirmada_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrada");
    }

    @Test
    @DisplayName("anular() ya anulada -> lanza excepción")
    void anular_yaAnulada_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("anular() ejecutada -> lanza excepción")
    void anular_ejecutada_lanzaExcepcion() {
        ProgramacionCompras entity = programacionCompras(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrada");
    }

    @Test
    @DisplayName("anular() no existe -> lanza excepción")
    void anular_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("anular() borrador -> asigna updated by")
    void anular_borrador_asignaUpdatedBy() {
        ProgramacionCompras entity = programacionCompras(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(mapper.toDetalleResponse(any())).thenReturn(
                ProgramacionComprasDetalleResponse.builder().id(1L).build());

        service.anular(1L);

        verify(repository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            assertThat(e.getFlagEstado()).isEqualTo("0");
            return true;
        }));
    }

}
