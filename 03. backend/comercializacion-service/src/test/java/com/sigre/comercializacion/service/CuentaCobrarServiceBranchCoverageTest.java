package com.sigre.comercializacion.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.comercializacion.client.ContabilidadGenerarAsientoClient;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.repository.CuentaCobrarDetRepository;
import com.sigre.comercializacion.repository.CuentaCobrarRepository;
import com.sigre.comercializacion.support.CuentaCobrarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para CuentaCobrarService
 * Enfocado en cubrir branches condicionales y excepciones críticas
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("CuentaCobrarService — Branch Coverage Tests")
class CuentaCobrarServiceBranchCoverageTest {

    @Mock
    private CuentaCobrarRepository cuentaCobrarRepository;

    @Mock
    private CuentaCobrarDetRepository cuentaCobrarDetRepository;

    @Mock
    private ContabilidadGenerarAsientoClient contabilidadClient;

    @Mock
    private CuentaCobrarCabeceraValidator cabeceraValidator;

    @InjectMocks
    private CuentaCobrarService service;

    private CuentaCobrar cuentaValida;

    @BeforeEach
    void setUp() {
        cuentaValida = CuentaCobrar.builder()
                .id(1L)
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .serie("F001")
                .numero("12345")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L)
                .total(new BigDecimal("1000"))
                .saldo(new BigDecimal("1000"))
                .ano(2026)
                .mes(5)
                .cntblLibroId(4L)
                .build();
        cuentaValida.setFlagEstado("1");
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
    }

    // ==================== TESTS DE VALIDACIÓN DE SALDO ====================

    @Test
    @DisplayName("validarSaldoNegativo_create_lanzaBusinessException")
    void validarSaldoNegativo_create_lanzaBusinessException() {
        // Given
        CuentaCobrar cuentaConSaldoNegativo = CuentaCobrar.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .total(new BigDecimal("1000"))
                .saldo(new BigDecimal("-100")) // Saldo negativo
                .build();
        cuentaConSaldoNegativo.setFlagEstado("1");

        // Mockear validaciones para que pasen
        when(cuentaCobrarRepository.existsSucursalActivaById(1L)).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(1L)).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(1L)).thenReturn(true);
        when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                any(), any(), any(), any(), any())).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.create(cuentaConSaldoNegativo, null, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("El saldo no puede ser negativo");
    }

    @Test
    @DisplayName("validarSaldoNegativo_update_lanzaBusinessException")
    void validarSaldoNegativo_update_lanzaBusinessException() {
        // Given
        CuentaCobrar cuentaConSaldoNegativo = CuentaCobrar.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .total(new BigDecimal("1000"))
                .saldo(new BigDecimal("-100")) // Saldo negativo
                .build();
        cuentaConSaldoNegativo.setFlagEstado("1");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));
        
        // Mockear validaciones para que pasen
        when(cuentaCobrarRepository.existsSucursalActivaById(1L)).thenReturn(true);
        when(cuentaCobrarRepository.existsClienteActivoById(1L)).thenReturn(true);
        when(cuentaCobrarRepository.existsDocTipoActivoById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.update(1L, cuentaConSaldoNegativo, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("El saldo no puede ser negativo");
    }

    // ==================== TESTS DE MOVIMIENTOS ====================

    @Test
    @DisplayName("registrarMovimiento_conSaldoNegativo_lanzaException")
    void registrarMovimiento_conSaldoNegativo_lanzaException() {
        // Given
        CuentaCobrarDet movimientoExcesivo = CuentaCobrarDet.builder()
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("1500")) // Mayor al saldo
                .conceptoFinancieroId(1L)
                .build();
        movimientoExcesivo.setFlagEstado("1");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(any(), any(), any(), any())).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimientoExcesivo, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("El movimiento generaría saldo negativo");
    }

    @Test
    @DisplayName("registrarMovimiento_conConceptoNulo_lanzaException")
    void registrarMovimiento_conConceptoNulo_lanzaException() {
        // Given
        CuentaCobrarDet movimientoSinConcepto = CuentaCobrarDet.builder()
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("200"))
                .conceptoFinancieroId(null) // Sin concepto
                .build();
        movimientoSinConcepto.setFlagEstado("1");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimientoSinConcepto, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("El concepto financiero es obligatorio");
    }

    // ==================== TESTS DE ESTADO ANULADO ====================

    @Test
    @DisplayName("update_conCuentaAnulada_lanzaException")
    void update_conCuentaAnulada_lanzaException() {
        // Given
        CuentaCobrar cuentaAnulada = CuentaCobrar.builder()
                .build();
        cuentaAnulada.setFlagEstado("0");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaAnulada));

        // When & Then
        assertThatThrownBy(() -> service.update(1L, cuentaValida, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("No se puede modificar cuenta anulada");
    }

    @Test
    @DisplayName("registrarMovimiento_conCuentaAnulada_lanzaException")
    void registrarMovimiento_conCuentaAnulada_lanzaException() {
        // Given
        CuentaCobrar cuentaAnulada = CuentaCobrar.builder()
                .build();
        cuentaAnulada.setFlagEstado("0");

        CuentaCobrarDet movimiento = CuentaCobrarDet.builder()
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("200"))
                .conceptoFinancieroId(1L)
                .build();
        movimiento.setFlagEstado("1");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaAnulada));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.registrarMovimiento(1L, movimiento, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("No se puede registrar movimiento en cuenta anulada");
    }

    // ==================== TESTS DE ANULACIÓN ====================

    @Test
    @DisplayName("anular_conCuentaYaAnulada_lanzaException")
    void anular_conCuentaYaAnulada_lanzaException() {
        // Given
        CuentaCobrar cuentaAnulada = CuentaCobrar.builder()
                .build();
        cuentaAnulada.setFlagEstado("0");

        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaAnulada));

        // When & Then
        assertThatThrownBy(() -> service.anular(1L, "Anulación duplicada", 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("La cuenta ya está anulada");
    }

    @Test
    @DisplayName("anular_conAbonosAplicados_lanzaException")
    void anular_conAbonosAplicados_lanzaException() {
        // Given
        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.anular(1L, "Anulación con abonos", 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("No se puede anular cuenta con abonos aplicados");
    }

    // ==================== TESTS DE DESACTIVACIÓN ====================

    @Test
    @DisplayName("desactivar_conAbonosAplicados_lanzaException")
    void desactivar_conAbonosAplicados_lanzaException() {
        // Given
        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.desactivar(1L, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("No se puede desactivar cuenta con abonos aplicados");
    }

    // ==================== TESTS DE ELIMINACIÓN ====================

    @Test
    @DisplayName("delete_conAbonosAplicados_lanzaException")
    void delete_conAbonosAplicados_lanzaException() {
        // Given
        when(cuentaCobrarRepository.findById(1L)).thenReturn(Optional.of(cuentaValida));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(1L)).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> service.delete(1L, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessage("No se puede eliminar cuenta con abonos aplicados");
    }

    // ==================== TESTS DE CONSULTA ====================

    @Test
    @DisplayName("findMovimientosByCuentaCobrarId_conCuentaInexistente_lanzaException")
    void findMovimientosByCuentaCobrarId_conCuentaInexistente_lanzaException() {
        // Given
        when(cuentaCobrarRepository.existsById(999L)).thenReturn(false);

        // When & Then
        assertThatThrownBy(() -> service.findMovimientosByCuentaCobrarId(999L))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("Cuenta por cobrar");
    }
}
