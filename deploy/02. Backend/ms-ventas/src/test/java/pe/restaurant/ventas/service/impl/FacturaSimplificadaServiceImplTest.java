package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.FacturaSimplCabeceraRequest;
import pe.restaurant.ventas.dto.request.FacturaSimplLineRequest;
import pe.restaurant.ventas.dto.request.FacturaSimplPagoRequest;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.entity.FsFacturaSimpl;
import pe.restaurant.ventas.entity.FsFacturaSimplDet;
import pe.restaurant.ventas.entity.FsFacturaSimplPago;
import pe.restaurant.ventas.entity.Propina;
import pe.restaurant.ventas.repository.ArticuloRepository;
import pe.restaurant.ventas.repository.CuentaCobrarRepository;
import pe.restaurant.ventas.repository.FsFacturaSimplRepository;
import pe.restaurant.ventas.repository.PropinaRepository;
import pe.restaurant.ventas.repository.ReservacionRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;
import pe.restaurant.ventas.service.CuentaCobrarService;
import pe.restaurant.ventas.support.CuentaCobrarCabeceraValidator;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class FacturaSimplificadaServiceImplTest {

    @Mock
    private FsFacturaSimplRepository fsRepository;
    @Mock
    private ArticuloRepository articuloRepository;
    @Mock
    private VentasFkValidator fkValidator;
    @Mock
    private CuentaCobrarService cuentaCobrarService;
    @Mock
    private CuentaCobrarRepository cuentaCobrarRepository;
    @Mock
    private PropinaRepository propinaRepository;
    @Mock
    private ReservacionRepository reservacionRepository;
    @Mock
    private CuentaCobrarCabeceraValidator cabeceraValidator;
    @InjectMocks
    private FacturaSimplificadaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(10L);
        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void findAll_delegaEnRepositorioConSpecification() {
        when(fsRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));
        assertThat(service.findAll(1L, null, null, null, null, null, null, null, Pageable.unpaged()).getContent()).isEmpty();
        verify(fsRepository).findAll(any(Specification.class), eq(Pageable.unpaged()));
    }

    @Test
    void emitir_generaCxCAutomaticamente() {
        FsFacturaSimpl f = buildFacturaEmitible();
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(fkValidator.existsFacturaTriplet(any(), any(), any(), any())).thenReturn(false);
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("CF001"))
                .thenReturn(Optional.of(99L));

        CuentaCobrar cxcCreada = CuentaCobrar.builder().id(500L).total(new BigDecimal("118.0000")).saldo(BigDecimal.ZERO).build();
        cxcCreada.setFlagEstado("5");
        when(cuentaCobrarService.create(any(CuentaCobrar.class), anyList(), eq(1L))).thenReturn(cxcCreada);

        var resp = service.emitir(1L);

        assertThat(resp.getFlagEstado()).isEqualTo("2");
        assertThat(resp.getCntasCobrarId()).isEqualTo(500L);
        verify(cuentaCobrarService).create(any(), anyList(), eq(1L));
    }

    @Test
    void emitir_sinConceptoFinanciero_throws() {
        FsFacturaSimpl f = buildFacturaEmitible();
        when(fsRepository.findById(2L)).thenReturn(Optional.of(f));
        when(fkValidator.existsFacturaTriplet(any(), any(), any(), any())).thenReturn(false);
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarRepository.findConceptoFinancieroIdByCodigo("CF001"))
                .thenReturn(Optional.empty());

        BusinessException ex = assertThrows(BusinessException.class, () -> service.emitir(2L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-085");
    }

    @Test
    void anular_anulaCxCVinculada() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        f.setCntasCobrarId(500L);
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(1L, "1", "CONFIRMADA"))
                .thenReturn(false);
        when(propinaRepository.findByFsFacturaSimplIdAndFlagEstado(1L, "1")).thenReturn(List.of());
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CuentaCobrar cxcAnulada = CuentaCobrar.builder().id(500L).build();
        cxcAnulada.setFlagEstado("0");
        when(cuentaCobrarService.anular(eq(500L), anyString(), eq(1L))).thenReturn(cxcAnulada);

        var resp = service.anular(1L);

        assertThat(resp.getFlagEstado()).isEqualTo("0");
        verify(cuentaCobrarService).anular(eq(500L), anyString(), eq(1L));
    }

    @Test
    void anular_bloqueadoSiReservaConfirmadaVinculada() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(1L, "1", "CONFIRMADA"))
                .thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.anular(1L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-088");
        verify(propinaRepository, never()).saveAll(any());
        verify(cuentaCobrarService, never()).anular(anyLong(), anyString(), anyLong());
    }

    @Test
    void anular_desactivaPropinasActivasAntesDeCxC() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        f.setCntasCobrarId(500L);
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(1L, "1", "CONFIRMADA"))
                .thenReturn(false);
        Propina pin = new Propina();
        pin.setId(77L);
        pin.setFsFacturaSimplId(1L);
        pin.setFlagEstado("1");
        when(propinaRepository.findByFsFacturaSimplIdAndFlagEstado(1L, "1")).thenReturn(List.of(pin));
        when(propinaRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(cuentaCobrarService.anular(eq(500L), anyString(), eq(1L)))
                .thenReturn(CuentaCobrar.builder().id(500L).build());

        service.anular(1L);

        assertThat(pin.getFlagEstado()).isEqualTo("0");
        assertThat(pin.getUpdatedBy()).isEqualTo(1L);
        verify(propinaRepository).saveAll(anyList());
    }

    @Test
    void anular_sinCntasCobrarId_noInvocaAnularCxc() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        f.setCntasCobrarId(null);
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(1L, "1", "CONFIRMADA"))
                .thenReturn(false);
        when(propinaRepository.findByFsFacturaSimplIdAndFlagEstado(1L, "1")).thenReturn(List.of());
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var resp = service.anular(1L);

        assertThat(resp.getFlagEstado()).isEqualTo("0");
        verify(cuentaCobrarService, never()).anular(anyLong(), anyString(), anyLong());
    }

    @Test
    void getById_ok() {
        FsFacturaSimpl f = buildFacturaEmitible();
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        assertThat(service.getById(1L).getSerie()).isEqualTo("F001");
    }

    @Test
    void create_ok() {
        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(10L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> {
            FsFacturaSimpl f = inv.getArgument(0);
            f.setId(20L);
            return f;
        });
        var resp = service.create(facturaRequest());
        assertThat(resp.getId()).isEqualTo(20L);
        assertThat(resp.getTotal()).isEqualByComparingTo("118.0000");
    }

    @Test
    void emitir_sinPagos_throws() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.getPagos().clear();
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        BusinessException ex = assertThrows(BusinessException.class, () -> service.emitir(1L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-084");
    }

    @Test
    void emitir_numeracionDuplicada_throws() {
        FsFacturaSimpl f = buildFacturaEmitible();
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(fkValidator.existsFacturaTriplet(any(), any(), any(), any())).thenReturn(true);
        BusinessException ex = assertThrows(BusinessException.class, () -> service.emitir(1L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-083");
    }

    @Test
    void deactivate_emitida_throws() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        BusinessException ex = assertThrows(BusinessException.class, () -> service.deactivate(1L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-081");
    }

    @Test
    void anular_noEmitida_throws() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("1");
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        BusinessException ex = assertThrows(BusinessException.class, () -> service.anular(1L));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-081");
    }

    @Test
    void anular_cuandoAnularCxcFalla_propagaYPropinasYaDesactivadas() {
        FsFacturaSimpl f = buildFacturaEmitible();
        f.setFlagEstado("2");
        f.setCntasCobrarId(500L);
        when(fsRepository.findById(1L)).thenReturn(Optional.of(f));
        when(reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(1L, "1", "CONFIRMADA"))
                .thenReturn(false);
        Propina pin = new Propina();
        pin.setId(1L);
        pin.setFsFacturaSimplId(1L);
        pin.setFlagEstado("1");
        when(propinaRepository.findByFsFacturaSimplIdAndFlagEstado(1L, "1")).thenReturn(List.of(pin));
        when(propinaRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
        doThrow(new BusinessException("CxC con abonos", HttpStatus.CONFLICT, "VEN-STATE"))
                .when(cuentaCobrarService).anular(eq(500L), anyString(), eq(1L));

        assertThrows(BusinessException.class, () -> service.anular(1L));
        assertThat(pin.getFlagEstado()).isEqualTo("0");
        verify(propinaRepository).saveAll(anyList());
        verify(cuentaCobrarService).anular(eq(500L), anyString(), eq(1L));
    }

    @Test
    void create_sinPagos() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(10L);
        line.setCantidad(new BigDecimal("10"));
        line.setPrecioUnitario(new BigDecimal("10"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000003");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setItems(List.of(line));

        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(10L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> {
            FsFacturaSimpl f = inv.getArgument(0);
            f.setId(21L);
            return f;
        });
        var resp = service.create(req);
        assertThat(resp.getId()).isEqualTo(21L);
    }

    @Test
    void create_conUnidadMedidaEnItem() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(11L);
        line.setUnidadMedidaId(5L);
        line.setCantidad(new BigDecimal("5"));
        line.setPrecioUnitario(new BigDecimal("20"));
        FacturaSimplPagoRequest pago = new FacturaSimplPagoRequest();
        pago.setMonto(new BigDecimal("118.0000"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000004");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setItems(List.of(line));
        req.setPagos(List.of(pago));

        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsUnidadMedidaActiva(5L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(11L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> {
            FsFacturaSimpl f = inv.getArgument(0);
            f.setId(22L);
            return f;
        });
        var resp = service.create(req);
        assertThat(resp.getId()).isEqualTo(22L);
    }

    @Test
    void create_sinSucursalEnRequest_usaContexto() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(10L);
        line.setCantidad(new BigDecimal("10"));
        line.setPrecioUnitario(new BigDecimal("10"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000005");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setItems(List.of(line));
        req.setPagos(List.of());

        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(10L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> {
            FsFacturaSimpl f = inv.getArgument(0);
            f.setId(23L);
            return f;
        });
        var resp = service.create(req);
        assertThat(resp.getId()).isEqualTo(23L);
    }

    @Test
    void create_conMonedaNula() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(10L);
        line.setCantidad(new BigDecimal("10"));
        line.setPrecioUnitario(new BigDecimal("10"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000006");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setItems(List.of(line));
        req.setPagos(List.of());

        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(10L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> {
            FsFacturaSimpl f = inv.getArgument(0);
            f.setId(24L);
            return f;
        });
        var resp = service.create(req);
        assertThat(resp.getId()).isEqualTo(24L);
    }

    @Test
    void update_ok() {
        FsFacturaSimpl existing = buildFacturaEmitible();
        existing.setFlagEstado("1");

        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(20L);
        line.setCantidad(new BigDecimal("2"));
        line.setPrecioUnitario(new BigDecimal("50"));
        FacturaSimplPagoRequest pago = new FacturaSimplPagoRequest();
        pago.setMonto(new BigDecimal("118.0000"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000002");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setPuntoVentaId(3L);
        req.setItems(List.of(line));
        req.setPagos(List.of(pago));

        when(fsRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsMonedaActiva(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsPuntoVentaActivo(3L, 10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(20L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var resp = service.update(1L, req);
        assertThat(resp.getSerie()).isEqualTo("F001");
    }

    @Test
    void update_sucursalIdNoCoincideConToken_throws() {
        FsFacturaSimpl existing = buildFacturaEmitible();
        existing.setFlagEstado("1");
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(99L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000002");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setItems(List.of());
        req.setPagos(List.of());

        when(fsRepository.findById(1L)).thenReturn(Optional.of(existing));

        var ex = assertThrows(BusinessException.class, () -> service.update(1L, req));
        assertThat(ex.getMessage()).contains("sucursalId no coincide con el token");
    }

    @Test
    void update_sinPagos() {
        FsFacturaSimpl existing = buildFacturaEmitible();
        existing.setFlagEstado("1");

        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(10L);
        line.setCantidad(new BigDecimal("1"));
        line.setPrecioUnitario(new BigDecimal("100"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000007");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setItems(List.of(line));

        when(fsRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(fkValidator.existsEntidadContribuyenteActiva(5L)).thenReturn(true);
        when(fkValidator.existsDocTipoActivo(1L)).thenReturn(true);
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(10L, "1")).thenReturn(true);
        when(fsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var resp = service.update(1L, req);
        assertThat(resp.getSerie()).isEqualTo("F001");
    }

    private static FacturaSimplCabeceraRequest facturaRequest() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(10L);
        line.setCantidad(new BigDecimal("10"));
        line.setPrecioUnitario(new BigDecimal("10"));
        FacturaSimplPagoRequest pago = new FacturaSimplPagoRequest();
        pago.setMonto(new BigDecimal("118.0000"));
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setSucursalId(10L);
        req.setClienteId(5L);
        req.setDocTipoId(1L);
        req.setSerie("F001");
        req.setNumero("00000002");
        req.setFechaEmision(LocalDate.now());
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setMonedaId(1L);
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setItems(List.of(line));
        req.setPagos(List.of(pago));
        return req;
    }

    private FsFacturaSimpl buildFacturaEmitible() {
        FsFacturaSimpl f = new FsFacturaSimpl();
        f.setId(1L);
        f.setSucursalId(10L);
        f.setClienteId(5L);
        f.setDocTipoId(1L);
        f.setSerie("F001");
        f.setNumero("00000001");
        f.setFechaEmision(LocalDate.now());
        f.setMonedaId(1L);
        f.setAno(2026);
        f.setMes(5);
        f.setCntblLibroId(4L);
        f.setFlagEstado("1");

        FsFacturaSimplDet det = new FsFacturaSimplDet();
        det.setFactura(f);
        det.setArticuloId(10L);
        det.setCantidad(new BigDecimal("10"));
        det.setPrecioUnitario(new BigDecimal("10"));
        det.setSubtotal(new BigDecimal("100.0000"));
        det.setFlagEstado("1");
        f.getDetalles().add(det);

        f.setSubtotal(new BigDecimal("100.0000"));
        f.setImpuesto(new BigDecimal("18.0000"));
        f.setTotal(new BigDecimal("118.0000"));

        FsFacturaSimplPago pago = new FsFacturaSimplPago();
        pago.setFactura(f);
        pago.setMonto(new BigDecimal("118.0000"));
        pago.setFlagEstado("1");
        pago.setFechaPago(Instant.now());
        f.getPagos().add(pago);

        return f;
    }
}
