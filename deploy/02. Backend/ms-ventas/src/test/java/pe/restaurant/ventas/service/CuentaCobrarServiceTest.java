package pe.restaurant.ventas.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.ventas.client.ContabilidadGenerarAsientoClient;
import pe.restaurant.ventas.client.FinanzasClient;
import pe.restaurant.ventas.client.dto.GenerarAsientoResponse;
import pe.restaurant.ventas.dto.request.CuentaCobrarDetraccionRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarDirectoRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarNotaCreditoRequest;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.entity.CuentaCobrarDet;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.entity.ServiciosCxC;
import pe.restaurant.ventas.repository.CuentaCobrarDetRepository;
import pe.restaurant.ventas.repository.CuentaCobrarRepository;
import pe.restaurant.ventas.repository.EntidadCreditosCxcRepository;
import pe.restaurant.ventas.repository.ServiciosCxCRepository;
import pe.restaurant.ventas.support.CuentaCobrarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CuentaCobrarServiceTest {

    @Mock
    private CuentaCobrarRepository cuentaCobrarRepository;
    @Mock
    private CuentaCobrarDetRepository cuentaCobrarDetRepository;
    @Mock
    private ContabilidadGenerarAsientoClient contabilidadClient;
    @Mock
    private FinanzasClient finanzasClient;
    @Mock
    private EntidadCreditosCxcRepository entidadCreditosCxcRepository;
    @Mock
    private ServiciosCxCRepository serviciosCxCRepository;
    @Mock
    private CuentaCobrarCabeceraValidator cabeceraValidator;
    @Mock
    private CntasCobrarDetImpService cntasCobrarDetImpService;
    @InjectMocks
    private CuentaCobrarService service;

    @BeforeEach
    void stubFksValidas() {
        lenient().when(cuentaCobrarRepository.existsSucursalActivaById(anyLong())).thenReturn(true);
        lenient().when(cuentaCobrarRepository.existsClienteActivoById(anyLong())).thenReturn(true);
        lenient().when(cuentaCobrarRepository.existsDocTipoActivoById(anyLong())).thenReturn(true);
        lenient().when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(anyLong())).thenReturn(true);
        lenient().when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo(anyString())).thenReturn(Optional.of(1L));
        lenient().when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                anyLong(), anyLong(), anyString(), anyString(), eq("1"))).thenReturn(false);
        lenient().when(cuentaCobrarRepository.existsAbonosAplicadosById(anyLong())).thenReturn(false);
        lenient().when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("CF004"))
                .thenReturn(Optional.of(99L));
        lenient().when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("FI-108")).thenReturn(Optional.of(10L));
        lenient().when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("FI-098")).thenReturn(Optional.of(11L));
        lenient().when(cuentaCobrarRepository.findDocTipoIdByCodigo("DTRC")).thenReturn(Optional.of(20L));
        lenient().when(cuentaCobrarRepository.findDocTipoIdByCodigo("NCC")).thenReturn(Optional.of(21L));
        lenient().when(cuentaCobrarRepository.sumSaldoPendienteByCliente(anyLong(), any())).thenReturn(BigDecimal.ZERO);
        lenient().when(entidadCreditosCxcRepository.findActiveByEntidadAndMoneda(anyLong(), any())).thenReturn(Optional.empty());
        GenerarAsientoResponse asiento = new GenerarAsientoResponse();
        asiento.setAsientoId(1000L);
        lenient().when(contabilidadClient.generarRegistroCntasCobrar(any()))
                .thenReturn(ApiResponse.<GenerarAsientoResponse>builder()
                        .success(true)
                        .message("OK")
                        .data(asiento)
                        .build());
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
        lenient().doNothing().when(cabeceraValidator).copiarPeriodoContable(any(), any());
    }

    private static CuentaCobrar cuentaBase() {
        return CuentaCobrar.builder()
                .sucursalId(1L)
                .clienteId(2L)
                .docTipoId(3L)
                .serie("CXB")
                .numero("00001")
                .fechaEmision(LocalDate.of(2026, 5, 18))
                .total(new BigDecimal("100"))
                .saldo(new BigDecimal("100"))
                .ano(2026)
                .mes(5)
                .cntblLibroId(4L)
                .build();
    }

    @Test
    void findByIdWithMovimientos_notFound() {
        when(cuentaCobrarRepository.findByIdWithMovimientos(9L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> service.findByIdWithMovimientos(9L));
    }

    @Test
    void findAllWithFilters_ok() {
        when(cuentaCobrarRepository.findAllWithFilters(any(), any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(cuentaBase())));
        assertThat(service.findAllWithFilters(null, null, null, null, null, null, Pageable.unpaged()).getTotalElements())
                .isEqualTo(1);
    }

    @Test
    void create_sinMovimientos_ok() {
        CuentaCobrar cc = cuentaBase();
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(10L);
            return c;
        });
        CuentaCobrar out = service.create(cc, List.of(), 1L);
        assertThat(out.getId()).isEqualTo(10L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        verify(cuentaCobrarDetRepository, never()).save(any());
    }

    @Test
    void create_saldoNegativo_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setSaldo(new BigDecimal("-1"));
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    @Test
    void create_conCargo_calculaTotal() {
        CuentaCobrar cc = cuentaBase();
        cc.setTotal(null);
        cc.setSaldo(null);
        CuentaCobrarDet cargo = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("50"))
                .conceptoFinancieroId(1L)
                .build();
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            if (c.getId() == null) {
                c.setId(11L);
            }
            return c;
        });
        CuentaCobrar out = service.create(cc, List.of(cargo), 1L);
        assertThat(out.getTotal()).isEqualByComparingTo("50");
    }

    @Test
    void update_cuentaAnulada_throws() {
        CuentaCobrar existing = cuentaBase();
        existing.setId(5L);
        existing.setFlagEstado("0");
        when(cuentaCobrarRepository.findById(5L)).thenReturn(Optional.of(existing));
        assertThrows(BusinessException.class, () -> service.update(5L, cuentaBase(), 1L));
    }

    @Test
    void activar_y_desactivar() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(6L);
        cc.setFlagEstado("0");
        when(cuentaCobrarRepository.findById(6L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CuentaCobrar activada = service.activar(6L, 1L);
        assertThat(activada.getFlagEstado()).isEqualTo("1");

        CuentaCobrar desactivada = service.desactivar(6L, 1L);
        assertThat(desactivada.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void delete_softDelete() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(7L);
        cc.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(7L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.delete(7L, 1L);

        assertThat(cc.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void registrarMovimiento_abono_reduceSaldo() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("1");
        cc.setSaldo(new BigDecimal("100"));
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CuentaCobrarDet abono = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("40"))
                .conceptoFinancieroId(2L)
                .build();

        CuentaCobrar out = service.registrarMovimiento(8L, abono, 1L);
        assertThat(out.getSaldo()).isEqualByComparingTo("60");
    }

    @Test
    void anular_generaMovimientoReverso() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        cc.setFlagEstado("1");
        cc.setSaldo(new BigDecimal("30"));
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CuentaCobrar out = service.anular(9L, "error de carga", 1L);

        assertThat(out.getFlagEstado()).isEqualTo("0");
        verify(cuentaCobrarDetRepository, atLeastOnce()).save(any(CuentaCobrarDet.class));
    }

    @Test
    void findMovimientos_cuentaInexistente() {
        when(cuentaCobrarRepository.existsById(99L)).thenReturn(false);
        assertThrows(ResourceNotFoundException.class, () -> service.findMovimientosByCuentaCobrarId(99L));
    }

    // ==== Tests de validación FK en create ====

    @Test
    void create_sucursalInvalida_throws() {
        when(cuentaCobrarRepository.existsSucursalActivaById(1L)).thenReturn(false);
        CuentaCobrar cc = cuentaBase();
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    @Test
    void create_clienteInvalido_throws() {
        when(cuentaCobrarRepository.existsClienteActivoById(2L)).thenReturn(false);
        CuentaCobrar cc = cuentaBase();
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    @Test
    void create_docTipoInvalido_throws() {
        when(cuentaCobrarRepository.existsDocTipoActivoById(3L)).thenReturn(false);
        CuentaCobrar cc = cuentaBase();
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    @Test
    void create_monedaInvalida_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setMonedaId(99L);
        when(cuentaCobrarRepository.existsMonedaActivaById(99L)).thenReturn(false);
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    @Test
    void create_duplicado_throws() {
        when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                2L, 3L, "CXB", "00001", "1")).thenReturn(true);
        CuentaCobrar cc = cuentaBase();
        assertThrows(BusinessException.class, () -> service.create(cc, List.of(), 1L));
    }

    // ==== Tests de validación FK en update ====

    @Test
    void update_sucursalInvalida_throws() {
        CuentaCobrar existing = cuentaBase();
        existing.setId(5L);
        existing.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(5L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsSucursalActivaById(1L)).thenReturn(false);
        
        CuentaCobrar update = cuentaBase();
        assertThrows(BusinessException.class, () -> service.update(5L, update, 1L));
    }

    @Test
    void update_clienteInvalido_throws() {
        CuentaCobrar existing = cuentaBase();
        existing.setId(5L);
        existing.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(5L)).thenReturn(Optional.of(existing));
        when(cuentaCobrarRepository.existsClienteActivoById(2L)).thenReturn(false);
        
        CuentaCobrar update = cuentaBase();
        assertThrows(BusinessException.class, () -> service.update(5L, update, 1L));
    }

    @Test
    void update_duplicadoCambioClaveNatural_throws() {
        CuentaCobrar existing = cuentaBase();
        existing.setId(5L);
        existing.setFlagEstado("1");
        existing.setNumero("00001");
        when(cuentaCobrarRepository.findById(5L)).thenReturn(Optional.of(existing));
        
        CuentaCobrar update = cuentaBase();
        update.setNumero("00002");
        when(cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                2L, 3L, "CXB", "00002", "1")).thenReturn(true);
        
        assertThrows(BusinessException.class, () -> service.update(5L, update, 1L));
    }

    @Test
    void update_saldoNegativo_throws() {
        CuentaCobrar existing = cuentaBase();
        existing.setId(5L);
        existing.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(5L)).thenReturn(Optional.of(existing));
        
        CuentaCobrar update = cuentaBase();
        update.setSaldo(new BigDecimal("-10"));
        assertThrows(BusinessException.class, () -> service.update(5L, update, 1L));
    }

    // ==== Tests de desactivar/delete con abonos ====

    @Test
    void desactivar_conAbonos_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(6L);
        when(cuentaCobrarRepository.findById(6L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(6L)).thenReturn(true);
        
        assertThrows(BusinessException.class, () -> service.desactivar(6L, 1L));
    }

    @Test
    void delete_conAbonos_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(7L);
        when(cuentaCobrarRepository.findById(7L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(7L)).thenReturn(true);
        
        assertThrows(BusinessException.class, () -> service.delete(7L, 1L));
    }

    // ==== Tests de registrarMovimiento ====

    @Test
    void registrarMovimiento_conceptoNull_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        
        CuentaCobrarDet mov = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(null)
                .build();
        
        assertThrows(BusinessException.class, () -> service.registrarMovimiento(8L, mov, 1L));
    }

    @Test
    void registrarMovimiento_conceptoInvalido_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.existsConceptoFinancieroActivoById(99L)).thenReturn(false);
        
        CuentaCobrarDet mov = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(99L)
                .build();
        
        assertThrows(BusinessException.class, () -> service.registrarMovimiento(8L, mov, 1L));
    }

    @Test
    void registrarMovimiento_cuentaAnulada_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("0");
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        
        CuentaCobrarDet mov = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(1L)
                .build();
        
        assertThrows(BusinessException.class, () -> service.registrarMovimiento(8L, mov, 1L));
    }

    @Test
    void registrarMovimiento_duplicado_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(
                anyLong(), any(), any(), any())).thenReturn(true);
        
        CuentaCobrarDet mov = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("10"))
                .conceptoFinancieroId(1L)
                .build();
        
        assertThrows(BusinessException.class, () -> service.registrarMovimiento(8L, mov, 1L));
    }

    @Test
    void registrarMovimiento_saldoNegativo_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("1");
        cc.setSaldo(new BigDecimal("10"));
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        
        CuentaCobrarDet abono = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("100"))
                .conceptoFinancieroId(1L)
                .build();
        
        assertThrows(BusinessException.class, () -> service.registrarMovimiento(8L, abono, 1L));
    }

    @Test
    void registrarMovimiento_cargo_aumentaSaldo() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("1");
        cc.setSaldo(new BigDecimal("100"));
        cc.setTotal(new BigDecimal("100"));
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        
        CuentaCobrarDet cargo = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("50"))
                .conceptoFinancieroId(1L)
                .build();
        
        CuentaCobrar out = service.registrarMovimiento(8L, cargo, 1L);
        assertThat(out.getSaldo()).isEqualByComparingTo("150");
    }

    @Test
    void registrarMovimiento_ajuste_estableceSaldo() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(8L);
        cc.setFlagEstado("1");
        cc.setSaldo(new BigDecimal("100"));
        cc.setTotal(new BigDecimal("100"));
        when(cuentaCobrarRepository.findById(8L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarDetRepository.existsMovimientoDuplicado(anyLong(), any(), any(), any())).thenReturn(false);
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        
        CuentaCobrarDet ajuste = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.AJUSTE)
                .monto(new BigDecimal("75"))
                .conceptoFinancieroId(1L)
                .build();
        
        CuentaCobrar out = service.registrarMovimiento(8L, ajuste, 1L);
        assertThat(out.getSaldo()).isEqualByComparingTo("75");
    }

    // ==== Tests de anular ====

    @Test
    void anular_conAbonos_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.existsAbonosAplicadosById(9L)).thenReturn(true);
        
        assertThrows(BusinessException.class, () -> service.anular(9L, "motivo", 1L));
    }

    @Test
    void anular_yaAnulada_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        cc.setFlagEstado("0");
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        
        assertThrows(BusinessException.class, () -> service.anular(9L, "motivo", 1L));
    }

    @Test
    void anular_sinMotivo_noGeneraMovimiento() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        cc.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        
        CuentaCobrar out = service.anular(9L, null, 1L);
        
        assertThat(out.getFlagEstado()).isEqualTo("0");
        assertThat(out.getSaldo()).isEqualByComparingTo("0");
        verify(cuentaCobrarDetRepository, never()).save(any());
    }

    @Test
    void anular_motivoVacio_noGeneraMovimiento() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        cc.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        
        CuentaCobrar out = service.anular(9L, "  ", 1L);
        
        assertThat(out.getFlagEstado()).isEqualTo("0");
        verify(cuentaCobrarDetRepository, never()).save(any());
    }

    @Test
    void anular_sinConceptoSistema_throws() {
        CuentaCobrar cc = cuentaBase();
        cc.setId(9L);
        cc.setFlagEstado("1");
        when(cuentaCobrarRepository.findById(9L)).thenReturn(Optional.of(cc));
        when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("CF004"))
                .thenReturn(Optional.empty());
        
        assertThrows(BusinessException.class, () -> service.anular(9L, "error", 1L));
    }

    // ==== Tests de estados por saldo ====

    @Test
    void create_saldoCero_estadoCancelado() {
        CuentaCobrar cc = cuentaBase();
        cc.setTotal(new BigDecimal("100"));
        cc.setSaldo(new BigDecimal("0"));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(10L);
            return c;
        });
        
        CuentaCobrar out = service.create(cc, List.of(), 1L);
        assertThat(out.getFlagEstado()).isEqualTo("5"); // Cancelado
    }

    @Test
    void create_saldoParcial_estadoParcial() {
        CuentaCobrar cc = cuentaBase();
        cc.setTotal(new BigDecimal("100"));
        cc.setSaldo(new BigDecimal("50"));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(10L);
            return c;
        });
        
        CuentaCobrar out = service.create(cc, List.of(), 1L);
        assertThat(out.getFlagEstado()).isEqualTo("4"); // Parcial
    }

    // ==== Tests de findMovimientos ====

    @Test
    void findMovimientos_ok() {
        when(cuentaCobrarRepository.existsById(10L)).thenReturn(true);
        when(cuentaCobrarDetRepository.findByCuentaCobrarIdAndFlagEstadoOrderByFechaMovDesc(10L, "1"))
                .thenReturn(List.of());
        
        List<CuentaCobrarDet> result = service.findMovimientosByCuentaCobrarId(10L);
        assertThat(result).isEmpty();
    }

    @Test
    void crearDocumentoDirecto_ok() {
        when(serviciosCxCRepository.findById(5L)).thenReturn(Optional.of(servicioActivo()));
        when(cuentaCobrarRepository.save(any(CuentaCobrar.class))).thenAnswer(inv -> {
            CuentaCobrar c = inv.getArgument(0);
            c.setId(100L);
            return c;
        });
        when(cuentaCobrarDetRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cntasCobrarDetImpService.listarPorDetalle(any())).thenReturn(List.of());

        CuentaCobrarDirectoRequest req = CuentaCobrarDirectoRequest.builder()
                .sucursalId(1L).clienteId(2L).docTipoId(3L)
                .serie("F001").numero("00099")
                .fechaEmision(LocalDate.of(2026, 5, 27))
                .monto(new BigDecimal("1500"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .servicioCxcId(5L)
                .descripcion("Catering evento")
                .build();

        CuentaCobrar out = service.crearDocumentoDirecto(req, 1L);
        assertThat(out.getId()).isEqualTo(100L);
        verify(cuentaCobrarDetRepository).save(argThat(m ->
                m.getReferencia().startsWith("ORIGEN=DIRECTO")));
    }

    @Test
    void generarDetraccion_montoMinimo_lanzaExcepcion() {
        CuentaCobrar origen = cuentaBase();
        origen.setId(50L);
        origen.setTotal(new BigDecimal("500"));
        when(cuentaCobrarRepository.findById(50L)).thenReturn(Optional.of(origen));

        assertThrows(BusinessException.class,
                () -> service.generarDetraccionPorCobrar(50L, new CuentaCobrarDetraccionRequest(), 1L));
    }

    @Test
    void crearNotaCredito_saldoInsuficiente_lanzaExcepcion() {
        CuentaCobrar origen = cuentaBase();
        origen.setId(60L);
        origen.setSaldo(new BigDecimal("50"));
        when(cuentaCobrarRepository.findById(60L)).thenReturn(Optional.of(origen));

        CuentaCobrarNotaCreditoRequest req = CuentaCobrarNotaCreditoRequest.builder()
                .cuentaCobrarOrigenId(60L)
                .serie("NC01").numero("00001")
                .fechaEmision(LocalDate.of(2026, 5, 27))
                .monto(new BigDecimal("100"))
                .motivo("Devolución parcial")
                .conceptoFinancieroId(1L)
                .build();

        assertThrows(BusinessException.class, () -> service.crearNotaCreditoPorCobrar(req, 1L));
    }

    private static ServiciosCxC servicioActivo() {
        ServiciosCxC s = new ServiciosCxC();
        s.setId(5L);
        s.setDescServicio("Catering");
        s.setFlagEstado("1");
        return s;
    }
}
