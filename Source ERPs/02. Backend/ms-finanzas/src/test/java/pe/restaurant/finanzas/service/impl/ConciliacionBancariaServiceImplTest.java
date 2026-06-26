package pe.restaurant.finanzas.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.ConciliacionBancariaRequest;
import pe.restaurant.finanzas.dto.request.ConciliacionDetRequest;
import pe.restaurant.finanzas.dto.request.ConciliarPartidasRequest;
import pe.restaurant.finanzas.dto.response.*;
import pe.restaurant.finanzas.entity.ConciliacionBancaria;
import pe.restaurant.finanzas.entity.ConciliacionDet;
import pe.restaurant.finanzas.mapper.ConciliacionBancariaMapper;
import pe.restaurant.finanzas.mapper.ConciliacionDetMapper;
import pe.restaurant.finanzas.repository.BancoCntaRepository;
import pe.restaurant.finanzas.repository.CajaBancosRepository;
import pe.restaurant.finanzas.repository.ConciliacionBancariaRepository;
import pe.restaurant.finanzas.repository.ConciliacionDetRepository;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConciliacionBancariaServiceImpl")
class ConciliacionBancariaServiceImplTest {

    @Mock private ConciliacionBancariaRepository repository;
    @Mock private ConciliacionDetRepository detalleRepository;
    @Mock private BancoCntaRepository bancoCntaRepository;
    @Mock private CajaBancosRepository cajaBancosRepository;
    @Mock private ConciliacionBancariaMapper mapper;
    @Mock private ConciliacionDetMapper detalleMapper;

    @InjectMocks
    private ConciliacionBancariaServiceImpl service;

    private ConciliacionBancaria conciliacion;
    private ConciliacionBancariaResponse response;

    @BeforeEach
    void setUp() {
        conciliacion = new ConciliacionBancaria();
        conciliacion.setId(1L);
        conciliacion.setBancoCntaId(1L);
        conciliacion.setPeriodoAnio(2026);
        conciliacion.setPeriodoMes(5);
        conciliacion.setSaldoBanco(new BigDecimal("10000.00"));
        conciliacion.setSaldoLibros(new BigDecimal("10000.00"));
        conciliacion.setFlagEstado("1");
        conciliacion.setDetalles(new ArrayList<>());

        response = new ConciliacionBancariaResponse();
        response.setId(1L);
        response.setBancoCntaId(1L);
        response.setFlagEstado("1");
    }


    // ==== listar — filtros ====

    @Test
    @DisplayName("listar - Debe retornar página de conciliaciones")
    void listar_DebeRetornarPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ConciliacionBancaria> page = new PageImpl<>(List.of(conciliacion), pageable, 1);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConciliacionBancariaResponse> result = service.listar(null, null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Debe filtrar por bancoCntaId")
    void listar_conFiltroBancoCntaId_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ConciliacionBancaria> page = new PageImpl<>(List.of(conciliacion), pageable, 1);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConciliacionBancariaResponse> result = service.listar(1L, null, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Debe filtrar por periodoAnio")
    void listar_conFiltroPeriodoAnio_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ConciliacionBancaria> page = new PageImpl<>(List.of(conciliacion), pageable, 1);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConciliacionBancariaResponse> result = service.listar(null, 2026, null, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Debe filtrar por periodoMes")
    void listar_conFiltroPeriodoMes_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ConciliacionBancaria> page = new PageImpl<>(List.of(conciliacion), pageable, 1);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConciliacionBancariaResponse> result = service.listar(null, null, 5, null, pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Debe filtrar por estado")
    void listar_conFiltroEstado_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ConciliacionBancaria> page = new PageImpl<>(List.of(conciliacion), pageable, 1);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConciliacionBancariaResponse> result = service.listar(null, null, null, "1", pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("obtenerPorId - Debe retornar conciliación")
    void obtenerPorId_DebeRetornarConciliacion() {
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));
        when(mapper.toResponse(conciliacion)).thenReturn(response);

        ConciliacionBancariaResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId - Debe lanzar excepción si no existe")
    void obtenerPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findByIdWithDetalles(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtenerPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("crear - Debe crear conciliación bancaria")
    void crear_DebeCrearConciliacion() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(6);
        request.setSaldoBanco(new BigDecimal("5000.00"));
        request.setSaldoLibros(new BigDecimal("5000.00"));
        ConciliacionDetRequest detRequest = new ConciliacionDetRequest();
        detRequest.setCajaBancosId(2001L);
        request.setDetalles(List.of(detRequest));

        when(bancoCntaRepository.existsById(1L)).thenReturn(true);
        when(cajaBancosRepository.existsById(2001L)).thenReturn(true);
        when(detalleMapper.toEntity(any())).thenReturn(new ConciliacionDet());
        when(repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(anyLong(), anyInt(), anyInt(), anyString())).thenReturn(false);
        when(mapper.toEntity(any())).thenReturn(conciliacion);
        when(repository.save(any())).thenReturn(conciliacion);
        when(mapper.toResponse(any())).thenReturn(response);

        ConciliacionBancariaResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(repository, atLeastOnce()).save(any());
    }


    // ==== crear — validaciones ====

    @Test
    @DisplayName("crear - Debe lanzar excepción si banco no existe")
    void crear_BancoNoExiste_DebeLanzarExcepcion() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(999L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(6);
        request.setSaldoBanco(new BigDecimal("5000.00"));
        request.setSaldoLibros(new BigDecimal("5000.00"));
        request.setDetalles(List.of(new ConciliacionDetRequest()));

        when(bancoCntaRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si periodo mes es menor a 1")
    void crear_periodoMesMenorA1_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(0);
        request.setDetalles(List.of(new ConciliacionDetRequest()));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El mes debe estar entre 1 y 12");
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si periodo mes es mayor a 12")
    void crear_periodoMesMayorA12_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(13);
        request.setDetalles(List.of(new ConciliacionDetRequest()));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El mes debe estar entre 1 y 12");
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si conciliación duplicada")
    void crear_conciliacionDuplicada_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        request.setDetalles(List.of(new ConciliacionDetRequest()));

        when(repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(anyLong(), anyInt(), anyInt(), anyString())).thenReturn(true);
        when(bancoCntaRepository.existsById(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe una conciliación en proceso");
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si id de caja no existe")
    void crear_cajaBancosIdNoExiste_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        ConciliacionDetRequest detRequest = new ConciliacionDetRequest();
        detRequest.setCajaBancosId(999L);
        request.setDetalles(List.of(detRequest));

        when(repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(anyLong(), anyInt(), anyInt(), anyString())).thenReturn(false);
        when(bancoCntaRepository.existsById(1L)).thenReturn(true);
        when(cajaBancosRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("no existen");
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si detalles es null")
    void crear_detallesNull_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        request.setDetalles(null);

        when(repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(anyLong(), anyInt(), anyInt(), anyString())).thenReturn(false);
        when(bancoCntaRepository.existsById(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Debe incluir al menos un detalle");
    }

    @Test
    @DisplayName("crear - Debe lanzar excepción si detalles es vacio")
    void crear_detallesVacio_lanzaBusinessException() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        request.setDetalles(List.of());

        when(repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(anyLong(), anyInt(), anyInt(), anyString())).thenReturn(false);
        when(bancoCntaRepository.existsById(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Debe incluir al menos un detalle");
    }


    // ==== cerrar — validaciones ====

    @Test
    @DisplayName("cerrar - Debe cerrar conciliación")
    void cerrar_DebeCerrarConciliacion() {
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));
        when(repository.save(any())).thenReturn(conciliacion);

        CerrarConciliacionResponse result = service.cerrar(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("cerrar - Debe lanzar excepción si hay partidas sin conciliar")
    void cerrar_conPartidasPendientes_lanzaBusinessException() {
        ConciliacionDet detPendiente = new ConciliacionDet();
        detPendiente.setId(1L);
        detPendiente.setConciliado(false);
        conciliacion.addDetalle(detPendiente);

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));

        assertThatThrownBy(() -> service.cerrar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("partidas sin conciliar");
    }


    // ==== actualizar — validaciones ====

    @Test
    @DisplayName("actualizar - Debe actualizar conciliación")
    void actualizar_DebeActualizarConciliacion() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(6);
        request.setSaldoBanco(new BigDecimal("8000.00"));
        request.setSaldoLibros(new BigDecimal("8000.00"));
        request.setDetalles(new ArrayList<>());

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));
        when(repository.save(any())).thenReturn(conciliacion);
        when(mapper.toResponse(any())).thenReturn(response);

        ConciliacionBancariaResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("actualizar - Debe lanzar excepción si conciliación está cerrada")
    void actualizar_conciliacionCerrada_lanzaBusinessException() {
        conciliacion.setFlagEstado("2");

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));

        assertThatThrownBy(() -> service.actualizar(1L, request()))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede modificar una conciliación cerrada");
    }


    // ==== conciliar — validaciones ====

    @Test
    @DisplayName("conciliar - Debe conciliar partidas")
    void conciliar_DebeConciliarPartidas() {
        ConciliarPartidasRequest request = new ConciliarPartidasRequest();
        request.setDetalleIds(List.of(1L));

        ConciliacionDet det = new ConciliacionDet();
        det.setId(1L);
        det.setConciliado(false);

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));
        when(detalleRepository.findByConciliacionIdAndIdIn(1L, List.of(1L))).thenReturn(List.of(det));
        when(detalleRepository.saveAll(any())).thenReturn(List.of(det));

        ConciliarPartidasResponse result = service.conciliar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getPartidasConciliadas()).isEqualTo(1);
        verify(detalleRepository).saveAll(any());
    }

    @Test
    @DisplayName("conciliar - Debe lanzar excepción si algunos IDs no pertenecen a la conciliación")
    void conciliar_detalleIdsInvalidos_lanzaBusinessException() {
        ConciliarPartidasRequest request = new ConciliarPartidasRequest();
        request.setDetalleIds(List.of(1L, 2L));

        ConciliacionDet det = new ConciliacionDet();
        det.setId(1L);

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));
        when(detalleRepository.findByConciliacionIdAndIdIn(1L, List.of(1L, 2L))).thenReturn(List.of(det));

        assertThatThrownBy(() -> service.conciliar(1L, request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("IDs de detalle no pertenecen");
    }


    // ==== cerrar — validación estado cerrado ====

    @Test
    @DisplayName("cerrar - Debe lanzar excepción si conciliación ya está cerrada")
    void cerrar_conciliacionCerrada_lanzaBusinessException() {
        conciliacion.setFlagEstado("2");

        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(conciliacion));

        assertThatThrownBy(() -> service.cerrar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede modificar una conciliación cerrada");
    }


    // ==== helpers ====

    private ConciliacionBancariaRequest request() {
        ConciliacionBancariaRequest request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(1L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        request.setDetalles(List.of(new ConciliacionDetRequest()));
        return request;
    }
}
