package com.sigre.comercializacion.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.comercializacion.client.ContabilidadGenerarAsientoClient;
import com.sigre.comercializacion.client.dto.GenerarAsientoResponse;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.repository.CuentaCobrarDetRepository;
import com.sigre.comercializacion.repository.CuentaCobrarRepository;
import com.sigre.comercializacion.support.CuentaCobrarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Tests de Branch Coverage para CuentaCobrarService
 * Objetivo: Llevar coverage de 66% a 80%+
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class CuentaCobrarServiceBranchTest {

    @Mock
    private CuentaCobrarRepository cuentaCobrarRepository;

    @Mock
    private CuentaCobrarDetRepository cuentaCobrarDetRepository;

    @Mock
    private ContabilidadGenerarAsientoClient contabilidadClient;

    @Mock
    private CuentaCobrarCabeceraValidator cabeceraValidator;

    @Mock
    private CntasCobrarDetImpService cntasCobrarDetImpService;

    @InjectMocks
    private CuentaCobrarService service;

    @org.junit.jupiter.api.BeforeEach
    void stubCabeceraValidator() {
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
        lenient().doNothing().when(cabeceraValidator).copiarPeriodoContable(any(), any());
    }

    // ==================== TESTS PARA CREATE ====================

    @Test
    void create_conTotalNull_calculaTotalDesdeMovimientos() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setTotal(null);
        cuenta.setSaldo(null);
        
        List<CuentaCobrarDet> movimientos = List.of(
                crearMovimiento(CuentaCobrarDet.TipoMovimiento.CARGO, new BigDecimal("100")),
                crearMovimiento(CuentaCobrarDet.TipoMovimiento.CARGO, new BigDecimal("50"))
        );

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());
        
        // Mock del cliente de contabilidad con respuesta válida
        com.sigre.common.dto.ApiResponse<com.sigre.comercializacion.client.dto.GenerarAsientoResponse> mockResponse = 
            new com.sigre.common.dto.ApiResponse<>();
        mockResponse.setSuccess(true);
        com.sigre.comercializacion.client.dto.GenerarAsientoResponse asientoResponse = 
            new com.sigre.comercializacion.client.dto.GenerarAsientoResponse();
        asientoResponse.setAsientoId(100L);
        mockResponse.setData(asientoResponse);
        when(contabilidadClient.generarRegistroCntasCobrar(any())).thenReturn(mockResponse);

        // When
        CuentaCobrar result = service.create(cuenta, movimientos, 1L);

        // Then
        assertThat(result.getTotal()).isEqualTo(new BigDecimal("150"));
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("150"));
    }

    @Test
    void create_conSaldoNegativo_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("-50"));

        mockearValidacionesCreacion(cuenta);

        // When & Then
        assertThatThrownBy(() -> service.create(cuenta, new ArrayList<>(), 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("saldo no puede ser negativo");
    }

    @Test
    void create_conMovimientosVacios_noGeneraAsiento() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });

        // When
        CuentaCobrar result = service.create(cuenta, new ArrayList<>(), 1L);

        // Then
        assertThat(result.getCntblAsientoId()).isNull();
        verify(contabilidadClient, never()).generarRegistroCntasCobrar(any());
    }

    // ==================== TESTS PARA UPDATE ====================

    @Test
    void update_conCuentaAnulada_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("0"); // Anulada

        CuentaCobrar actualizada = crearCuentaBase();

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede modificar cuenta anulada");
    }

    @Test
    void update_conSucursalInactiva_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setSucursalId(999L);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsSucursalActivaById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Sucursal inexistente o inactiva");
    }

    @Test
    void update_conClienteInactivo_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setClienteId(999L);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsSucursalActivaById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Cliente inexistente o inactivo");
    }

    @Test
    void update_conDocTipoInactivo_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setDocTipoId(999L);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsSucursalActivaById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Tipo de documento inexistente o inactivo");
    }

    @Test
    void update_conMonedaInactiva_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setMonedaId(999L);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsSucursalActivaById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarRepository.existsMonedaActivaById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Moneda inexistente o inactiva");
    }

    @Test
    void update_conClaveNaturalDuplicada_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");
        existing.setClienteId(1L);
        existing.setSerie("F001");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setClienteId(2L); // Cambia cliente
        actualizada.setSerie("F002"); // Cambia serie

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockearValidacionesActualizacion(actualizada);
        when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                2L, actualizada.getDocTipoId(), "F002", actualizada.getNumero(), "1"))
                .thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una cuenta por cobrar con la misma clave natural");
    }

    @Test
    void update_conSaldoNegativo_lanzaBusinessException() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setSaldo(new BigDecimal("-100"));

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockearValidacionesActualizacion(actualizada);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, actualizada, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("saldo no puede ser negativo");
    }

    // ==================== TESTS PARA DESACTIVAR ====================

    @Test
    void desactivar_conAbonosAplicados_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.desactivar(1L, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede desactivar cuenta con abonos aplicados");
    }

    // ==================== TESTS PARA ANULAR ====================

    @Test
    void anular_conMotivoVacio_noRegistraMovimiento() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setTotal(new BigDecimal("100"));

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        service.anular(1L, "", 1L);

        // Then
        verify(cuentaCobrarDetRepository, never()).save(any(CuentaCobrarDet.class));
    }

    @Test
    void anular_conMotivoNull_noRegistraMovimiento() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setTotal(new BigDecimal("100"));

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        service.anular(1L, null, 1L);

        // Then
        verify(cuentaCobrarDetRepository, never()).save(any(CuentaCobrarDet.class));
    }

    @Test
    void anular_conCuentaYaAnulada_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("0"); // Ya anulada

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.anular(1L, "Motivo", 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La cuenta ya está anulada");
    }

    // ==================== TESTS PARA VALIDAR MOVIMIENTO ====================

    @Test
    void validarMovimiento_conConceptoNull_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(null);

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimiento, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("concepto financiero es obligatorio");
    }

    @Test
    void validarMovimiento_conConceptoInactivo_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(999L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.ABONO);
        movimiento.setMonto(new BigDecimal("50"));
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimiento, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Concepto financiero inexistente o inactivo");
    }

    @Test
    void validarMovimiento_conCuentaAnulada_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("0"); // Anulada

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.ABONO);
        movimiento.setMonto(new BigDecimal("50"));
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimiento, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede registrar movimiento en cuenta anulada");
    }

    @Test
    void registrarMovimiento_conSaldoNegativo_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setSaldo(new BigDecimal("50"));

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.ABONO);
        movimiento.setMonto(new BigDecimal("100")); // Mayor que el saldo
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimiento, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("movimiento generaría saldo negativo");
    }

    // ==================== TESTS PARA GENERAR ASIENTO CONTABLE ====================

    @Test
    void create_conAsientoContableExitoso_vinculaAsientoId() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));
        
        List<CuentaCobrarDet> movimientos = List.of(
                crearMovimiento(CuentaCobrarDet.TipoMovimiento.CARGO, new BigDecimal("100"))
        );

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());
        
        // Mock del cliente de contabilidad con respuesta exitosa
        com.sigre.common.dto.ApiResponse<com.sigre.comercializacion.client.dto.GenerarAsientoResponse> mockResponse = 
            new com.sigre.common.dto.ApiResponse<>();
        mockResponse.setSuccess(true);
        com.sigre.comercializacion.client.dto.GenerarAsientoResponse asientoResponse = 
            new com.sigre.comercializacion.client.dto.GenerarAsientoResponse();
        asientoResponse.setAsientoId(999L);
        mockResponse.setData(asientoResponse);
        when(contabilidadClient.generarRegistroCntasCobrar(any())).thenReturn(mockResponse);

        // When
        CuentaCobrar result = service.create(cuenta, movimientos, 1L);

        // Then
        assertThat(result.getCntblAsientoId()).isEqualTo(999L);
    }

    @Test
    void create_conFechaEmisionNull_usaFechaActual() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setFechaEmision(null); // Sin fecha de emisión
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));
        
        List<CuentaCobrarDet> movimientos = List.of(
                crearMovimiento(CuentaCobrarDet.TipoMovimiento.CARGO, new BigDecimal("100"))
        );

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());
        
        com.sigre.common.dto.ApiResponse<com.sigre.comercializacion.client.dto.GenerarAsientoResponse> mockResponse = 
            new com.sigre.common.dto.ApiResponse<>();
        mockResponse.setSuccess(true);
        com.sigre.comercializacion.client.dto.GenerarAsientoResponse asientoResponse = 
            new com.sigre.comercializacion.client.dto.GenerarAsientoResponse();
        asientoResponse.setAsientoId(100L);
        mockResponse.setData(asientoResponse);
        when(contabilidadClient.generarRegistroCntasCobrar(any())).thenReturn(mockResponse);

        // When
        CuentaCobrar result = service.create(cuenta, movimientos, 1L);

        // Then
        assertThat(result).isNotNull();
        verify(contabilidadClient).generarRegistroCntasCobrar(any());
    }

    @Test
    void create_conErrorFeign_lanzaBusinessException() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));
        
        List<CuentaCobrarDet> movimientos = List.of(
                crearMovimiento(CuentaCobrarDet.TipoMovimiento.CARGO, new BigDecimal("100"))
        );

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(anyLong())).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        lenient().when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());
        
        // Mock del cliente de contabilidad con error Feign
        when(contabilidadClient.generarRegistroCntasCobrar(any()))
            .thenThrow(feign.FeignException.ServiceUnavailable.class);

        // When & Then
        assertThatThrownBy(() -> service.create(cuenta, movimientos, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se pudo conectar con contabilidad");
    }

    // ==================== TESTS PARA ACTUALIZAR ESTADO POR SALDO ====================

    @Test
    void update_conSaldoCero_cambiaEstadoA5() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");
        existing.setSaldo(new BigDecimal("100"));

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setSaldo(BigDecimal.ZERO); // Saldo cero

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockearValidacionesActualizacion(actualizada);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.update(1L, actualizada, 1L);

        // Then
        assertThat(result.getFlagEstado()).isEqualTo("5"); // Estado pagado
    }

    @Test
    void update_conSaldoParcial_cambiaEstadoA4() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("1");
        existing.setTotal(new BigDecimal("100"));
        existing.setSaldo(new BigDecimal("100"));

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setTotal(new BigDecimal("100"));
        actualizada.setSaldo(new BigDecimal("50")); // Saldo parcial

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockearValidacionesActualizacion(actualizada);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.update(1L, actualizada, 1L);

        // Then
        assertThat(result.getFlagEstado()).isEqualTo("4"); // Estado parcial
    }

    @Test
    void update_conSaldoCompleto_cambiaEstadoA1() {
        // Given
        CuentaCobrar existing = crearCuentaBase();
        existing.setId(1L);
        existing.setFlagEstado("4"); // Estaba parcial
        existing.setTotal(new BigDecimal("100"));
        existing.setSaldo(new BigDecimal("50"));

        CuentaCobrar actualizada = crearCuentaBase();
        actualizada.setTotal(new BigDecimal("100"));
        actualizada.setSaldo(new BigDecimal("100")); // Saldo completo

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockearValidacionesActualizacion(actualizada);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.update(1L, actualizada, 1L);

        // Then
        assertThat(result.getFlagEstado()).isEqualTo("1"); // Estado activo
    }

    // ==================== TESTS PARA CALCULAR NUEVO SALDO ====================

    @Test
    void registrarMovimiento_conTipoCargo_incrementaSaldo() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setSaldo(new BigDecimal("100"));

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.CARGO);
        movimiento.setMonto(new BigDecimal("50"));
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.registrarMovimiento(1L, movimiento, 1L);

        // Then
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("150")); // 100 + 50
    }

    @Test
    void registrarMovimiento_conTipoAbono_decrementaSaldo() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setSaldo(new BigDecimal("100"));

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.ABONO);
        movimiento.setMonto(new BigDecimal("30"));
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.registrarMovimiento(1L, movimiento, 1L);

        // Then
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("70")); // 100 - 30
    }

    @Test
    void registrarMovimiento_conTipoAjuste_estableceSaldoDirecto() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setSaldo(new BigDecimal("100"));

        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.AJUSTE);
        movimiento.setMonto(new BigDecimal("75")); // Nuevo saldo directo
        movimiento.setFechaMov(LocalDate.now());

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        CuentaCobrar result = service.registrarMovimiento(1L, movimiento, 1L);

        // Then
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("75")); // Saldo directo
    }

    // ==================== TESTS PARA VALIDACIONES ADICIONALES ====================

    @Test
    void validarCreacion_conMonedaNull_noValidaMoneda() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setMonedaId(null); // Sin moneda
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));

        mockearValidacionesCreacion(cuenta);
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(1L);
            return c;
        });

        // When
        CuentaCobrar result = service.create(cuenta, new ArrayList<>(), 1L);

        // Then
        assertThat(result).isNotNull();
        verify(cuentaCobrarRepository, never()).existsMonedaActivaById(anyLong());
    }

    @Test
    void anular_conMotivoValido_registraMovimientoAnulacion() {
        // Given
        CuentaCobrar cuenta = crearCuentaBase();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setTotal(new BigDecimal("100"));

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(false);
        when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("CF004"))
            .thenReturn(Optional.of(10L));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarDetRepository.save(any(CuentaCobrarDet.class))).thenAnswer(inv -> inv.getArgument(0));

        // When
        service.anular(1L, "Motivo válido", 1L);

        // Then
        verify(cuentaCobrarDetRepository).save(any(CuentaCobrarDet.class));
    }

    // ==================== MÉTODOS AUXILIARES ====================

    private CuentaCobrar crearCuentaBase() {
        CuentaCobrar cuenta = new CuentaCobrar();
        cuenta.setSucursalId(1L);
        cuenta.setClienteId(1L);
        cuenta.setDocTipoId(1L);
        cuenta.setSerie("F001");
        cuenta.setNumero("00000001");
        cuenta.setFechaEmision(LocalDate.now());
        cuenta.setFechaVencimiento(LocalDate.now().plusDays(30));
        cuenta.setMonedaId(1L);
        cuenta.setTotal(new BigDecimal("100"));
        cuenta.setSaldo(new BigDecimal("100"));
        cuenta.setAno(2026);
        cuenta.setMes(5);
        cuenta.setCntblLibroId(4L);
        cuenta.setFlagEstado("1");
        return cuenta;
    }

    private CuentaCobrarDet crearMovimiento(CuentaCobrarDet.TipoMovimiento tipo, BigDecimal monto) {
        CuentaCobrarDet movimiento = new CuentaCobrarDet();
        movimiento.setTipoMov(tipo);
        movimiento.setMonto(monto);
        movimiento.setFechaMov(LocalDate.now());
        movimiento.setConceptoFinancieroId(1L);
        movimiento.setReferencia("Test");
        return movimiento;
    }

    private void mockearValidacionesCreacion(CuentaCobrar cuenta) {
        when(cuentaCobrarRepository.existsSucursalActivaById(cuenta.getSucursalId())).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(cuenta.getClienteId())).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(cuenta.getDocTipoId())).thenReturn(true);
        if (cuenta.getMonedaId() != null) {
            when(cuentaCobrarRepository.existsMonedaActivaById(cuenta.getMonedaId())).thenReturn(true);
        }
        when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                anyLong(), anyLong(), anyString(), anyString(), anyString())).thenReturn(false);
    }

    private void mockearValidacionesActualizacion(CuentaCobrar cuenta) {
        when(cuentaCobrarRepository.existsSucursalActivaById(cuenta.getSucursalId())).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(cuenta.getClienteId())).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(cuenta.getDocTipoId())).thenReturn(true);
        if (cuenta.getMonedaId() != null) {
            when(cuentaCobrarRepository.existsMonedaActivaById(cuenta.getMonedaId())).thenReturn(true);
        }
    }
}
