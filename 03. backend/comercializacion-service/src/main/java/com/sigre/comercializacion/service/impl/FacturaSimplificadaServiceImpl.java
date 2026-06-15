package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.FacturaSimplCabeceraRequest;
import com.sigre.comercializacion.dto.request.FacturaSimplLineRequest;
import com.sigre.comercializacion.dto.request.FacturaSimplPagoRequest;
import com.sigre.comercializacion.dto.response.FacturaSimplDetResponse;
import com.sigre.comercializacion.dto.response.FacturaSimplPagoResponse;
import com.sigre.comercializacion.dto.response.FacturaSimplificadaResponse;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.entity.FsFacturaSimpl;
import com.sigre.comercializacion.entity.FsFacturaSimplDet;
import com.sigre.comercializacion.entity.FsFacturaSimplPago;
import com.sigre.comercializacion.entity.Propina;
import com.sigre.comercializacion.repository.ArticuloRepository;
import com.sigre.comercializacion.repository.CuentaCobrarRepository;
import com.sigre.comercializacion.repository.FsFacturaSimplRepository;
import com.sigre.comercializacion.repository.PropinaRepository;
import com.sigre.comercializacion.repository.ReservacionRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;
import com.sigre.comercializacion.service.CuentaCobrarService;
import com.sigre.comercializacion.support.CuentaCobrarCabeceraValidator;
import com.sigre.comercializacion.specification.FsFacturaSimplSpecifications;
import com.sigre.comercializacion.service.FacturaSimplificadaService;
import com.sigre.comercializacion.service.VentasErrorCodes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FacturaSimplificadaServiceImpl implements FacturaSimplificadaService {

    private static final BigDecimal IGV_RATE = new BigDecimal("0.18");
    private static final String CONCEPTO_FINANCIERO_VENTA = "CF001";

    private final FsFacturaSimplRepository fsRepository;
    private final ArticuloRepository articuloRepository;
    private final VentasFkValidator fkValidator;
    private final CuentaCobrarService cuentaCobrarService;
    private final CuentaCobrarRepository cuentaCobrarRepository;
    private final PropinaRepository propinaRepository;
    private final ReservacionRepository reservacionRepository;
    private final CuentaCobrarCabeceraValidator cabeceraValidator;

    @Override
    public Page<FsFacturaSimpl> findAll(Long sucursalId, Long clienteId, Long docTipoId, String serie, String numero,
                                        String flagEstado, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        Long sid = sucursalId != null ? sucursalId : TenantContext.getSucursalId();
        return fsRepository.findAll(
                FsFacturaSimplSpecifications.filtered(sid, clienteId, docTipoId, serie, numero, flagEstado, fechaDesde, fechaHasta),
                pageable);
    }

    @Override
    public FacturaSimplificadaResponse getById(Long id) {
        return toResponse(loadFull(id));
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse create(FacturaSimplCabeceraRequest request) {
        Long usuarioId = requireUsuario();
        Long sucursalId = resolveSucursalId(request.getSucursalId());
        validateCabecera(sucursalId, request);
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());

        FsFacturaSimpl f = new FsFacturaSimpl();
        f.setSucursalId(sucursalId);
        f.setPuntoVentaId(request.getPuntoVentaId());
        f.setClienteId(request.getClienteId());
        f.setDocTipoId(request.getDocTipoId());
        f.setSerie(request.getSerie().trim());
        f.setNumero(request.getNumero().trim());
        f.setFechaEmision(request.getFechaEmision());
        f.setMonedaId(request.getMonedaId());
        f.setAno(request.getAno());
        f.setMes(request.getMes());
        f.setCntblLibroId(request.getCntblLibroId());
        f.setCreatedBy(usuarioId);
        f.setFlagEstado("1");

        f.getDetalles().addAll(buildDetalles(f, request.getItems()));
        if (request.getPagos() != null) {
            f.getPagos().addAll(buildPagos(f, request.getPagos()));
        }
        recalcMontos(f);

        return toResponse(fsRepository.save(f));
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse update(Long id, FacturaSimplCabeceraRequest request) {
        Long usuarioId = requireUsuario();
        FsFacturaSimpl f = loadFull(id);
        requireActivo(f);

        Long sucursalId = resolveSucursalId(request.getSucursalId());
        if (!Objects.equals(f.getSucursalId(), sucursalId)) {
            throw new BusinessException("sucursalId inconsistente", HttpStatus.CONFLICT, VentasErrorCodes.FS_FK);
        }
        validateCabecera(sucursalId, request);
        cabeceraValidator.validar(request.getAno(), request.getMes(), request.getCntblLibroId());

        f.setPuntoVentaId(request.getPuntoVentaId());
        f.setClienteId(request.getClienteId());
        f.setDocTipoId(request.getDocTipoId());
        f.setSerie(request.getSerie().trim());
        f.setNumero(request.getNumero().trim());
        f.setFechaEmision(request.getFechaEmision());
        f.setMonedaId(request.getMonedaId());
        f.setAno(request.getAno());
        f.setMes(request.getMes());
        f.setCntblLibroId(request.getCntblLibroId());
        f.getDetalles().clear();
        f.getDetalles().addAll(buildDetalles(f, request.getItems()));
        f.getPagos().clear();
        if (request.getPagos() != null) {
            f.getPagos().addAll(buildPagos(f, request.getPagos()));
        }
        recalcMontos(f);
        f.setUpdatedBy(usuarioId);

        return toResponse(fsRepository.save(f));
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse emitir(Long id) {
        Long usuarioId = requireUsuario();
        FsFacturaSimpl f = loadFull(id);
        requireActivo(f);
        recalcMontos(f);
        validatePagosParaEmitir(f);
        if (fkValidator.existsFacturaTriplet(f.getDocTipoId(), f.getSerie(), f.getNumero(), f.getId())) {
            throw new BusinessException("Ya existe comprobante activo con misma serie/número/tipo", HttpStatus.CONFLICT, VentasErrorCodes.FS_DUPLICATE_NUMERACION);
        }
        f.setFlagEstado("2");
        f.setUpdatedBy(usuarioId);
        FsFacturaSimpl saved = fsRepository.save(f);

        try {
            CuentaCobrar cxc = generarCxCDesdeFactura(saved, usuarioId);
            saved.setCntasCobrarId(cxc.getId());
            saved = fsRepository.save(saved);
        } catch (BusinessException e) {
            log.warn("No se pudo generar CxC para factura {}: {} [{}]", id, e.getMessage(), e.getErrorCode());
            throw e;
        }

        return toResponse(saved);
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse anular(Long id) {
        Long usuarioId = requireUsuario();
        FsFacturaSimpl f = loadFull(id);
        if (!"2".equals(f.getFlagEstado())) {
            throw new BusinessException("Solo se puede anular un comprobante cerrado/emitido", HttpStatus.CONFLICT, VentasErrorCodes.FS_STATE);
        }
        assertSinReservaConfirmadaVinculada(f.getId());
        desactivarPropinasActivas(f.getId(), usuarioId);

        f.setFlagEstado("0");
        f.setUpdatedBy(usuarioId);

        if (f.getCntasCobrarId() != null) {
            cuentaCobrarService.anular(f.getCntasCobrarId(),
                    "Anulación por factura " + f.getSerie() + "-" + f.getNumero(), usuarioId);
        }

        return toResponse(fsRepository.save(f));
    }

    @Override
    public List<FacturaSimplPagoResponse> listPagos(Long id) {
        FsFacturaSimpl f = loadFull(id);
        return mapPagos(f.getPagos());
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse activate(Long id) {
        Long usuarioId = requireUsuario();
        FsFacturaSimpl f = loadFull(id);
        f.setFlagEstado("1");
        f.setUpdatedBy(usuarioId);
        return toResponse(fsRepository.save(f));
    }

    @Override
    @Transactional
    public FacturaSimplificadaResponse deactivate(Long id) {
        Long usuarioId = requireUsuario();
        FsFacturaSimpl f = loadFull(id);
        if ("2".equals(f.getFlagEstado())) {
            throw new BusinessException("No se puede desactivar una factura emitida; use anular", HttpStatus.CONFLICT, VentasErrorCodes.FS_STATE);
        }
        f.setFlagEstado("0");
        f.setUpdatedBy(usuarioId);
        return toResponse(fsRepository.save(f));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        deactivate(id);
    }

    private CuentaCobrar generarCxCDesdeFactura(FsFacturaSimpl f, Long usuarioId) {
        Long conceptoId = cuentaCobrarRepository.findConceptoFinancieroIdByCodigo(CONCEPTO_FINANCIERO_VENTA)
                .orElseThrow(() -> new BusinessException(
                        "No existe concepto financiero '" + CONCEPTO_FINANCIERO_VENTA
                                + "' activo; requerido para generar CxC desde factura",
                        HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_CXC_CONCEPTO_NO_CONFIGURADO));

        BigDecimal sumPagos = BigDecimal.ZERO;
        if (f.getPagos() != null) {
            sumPagos = f.getPagos().stream()
                    .filter(p -> "1".equals(p.getFlagEstado()))
                    .map(FsFacturaSimplPago::getMonto)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
        }
        BigDecimal saldo = f.getTotal().subtract(sumPagos).max(BigDecimal.ZERO);

        cabeceraValidator.validar(f.getAno(), f.getMes(), f.getCntblLibroId());

        CuentaCobrar cxc = CuentaCobrar.builder()
                .sucursalId(f.getSucursalId())
                .clienteId(f.getClienteId())
                .docTipoId(f.getDocTipoId())
                .serie(f.getSerie())
                .numero(f.getNumero())
                .fechaEmision(f.getFechaEmision())
                .monedaId(f.getMonedaId())
                .total(f.getTotal())
                .saldo(saldo)
                .ano(f.getAno())
                .mes(f.getMes())
                .cntblLibroId(f.getCntblLibroId())
                .build();

        CuentaCobrarDet cargo = CuentaCobrarDet.builder()
                .fechaMov(f.getFechaEmision())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(f.getTotal())
                .referencia("Factura " + f.getSerie() + "-" + f.getNumero())
                .conceptoFinancieroId(conceptoId)
                .build();

        return cuentaCobrarService.create(cxc, List.of(cargo), usuarioId);
    }

    private FsFacturaSimpl loadFull(Long id) {
        return fsRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FacturaSimplificada", id));
    }

    private static final String RESERVA_ESTADO_CONFIRMADA = "CONFIRMADA";

    private void assertSinReservaConfirmadaVinculada(Long facturaId) {
        if (reservacionRepository.existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(
                facturaId, "1", RESERVA_ESTADO_CONFIRMADA)) {
            throw new BusinessException(
                    "Existen reservaciones confirmadas vinculadas a este comprobante; cancele la reservación o quite el vínculo antes de anular.",
                    HttpStatus.CONFLICT, VentasErrorCodes.FS_ANULAR_RESERVACION_PENDIENTE);
        }
    }

    private void desactivarPropinasActivas(Long facturaId, Long usuarioId) {
        List<Propina> activas = propinaRepository.findByFsFacturaSimplIdAndFlagEstado(facturaId, "1");
        if (activas.isEmpty()) {
            return;
        }
        for (Propina p : activas) {
            p.setFlagEstado("0");
            p.setUpdatedBy(usuarioId);
        }
        propinaRepository.saveAll(activas);
        log.info("Desactivadas {} propina(s) al anular factura simplificada id={}", activas.size(), facturaId);
    }

    private void requireActivo(FsFacturaSimpl f) {
        if (!"1".equals(f.getFlagEstado())) {
            throw new BusinessException("Factura inactiva", HttpStatus.CONFLICT, VentasErrorCodes.FS_STATE);
        }
    }

    private void validateCabecera(Long sucursalId, FacturaSimplCabeceraRequest request) {
        if (!fkValidator.existsEntidadContribuyenteActiva(request.getClienteId())) {
            throw new BusinessException("Cliente no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
        }
        if (!fkValidator.existsDocTipoActivo(request.getDocTipoId())) {
            throw new BusinessException("Tipo de documento no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
        }
        if (request.getMonedaId() != null && !fkValidator.existsMonedaActiva(request.getMonedaId())) {
            throw new BusinessException("Moneda no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
        }
        if (request.getPuntoVentaId() != null && !fkValidator.existsPuntoVentaActivo(request.getPuntoVentaId(), sucursalId)) {
            throw new BusinessException("Punto de venta no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
        }
    }

    private void validatePagosParaEmitir(FsFacturaSimpl f) {
        if (f.getPagos() == null || f.getPagos().isEmpty()) {
            throw new BusinessException("Se requiere al menos un pago para emitir", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_PAGOS);
        }
        BigDecimal sum = f.getPagos().stream()
                .filter(p -> "1".equals(p.getFlagEstado()))
                .map(FsFacturaSimplPago::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(4, RoundingMode.HALF_UP);
        if (sum.compareTo(f.getTotal()) != 0) {
            throw new BusinessException("La suma de pagos debe igualar el total", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_PAGOS);
        }
    }

    private List<FsFacturaSimplDet> buildDetalles(FsFacturaSimpl f, List<FacturaSimplLineRequest> items) {
        List<FsFacturaSimplDet> list = new ArrayList<>();
        Long uid = TenantContext.getUsuarioId();
        for (FacturaSimplLineRequest it : items) {
            if (!articuloRepository.existsByIdAndFlagEstado(it.getArticuloId(), "1")) {
                throw new BusinessException("Artículo no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
            }
            if (it.getUnidadMedidaId() != null && !fkValidator.existsUnidadMedidaActiva(it.getUnidadMedidaId())) {
                throw new BusinessException("Unidad de medida no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
            }
            FsFacturaSimplDet d = new FsFacturaSimplDet();
            d.setFactura(f);
            d.setArticuloId(it.getArticuloId());
            d.setUnidadMedidaId(it.getUnidadMedidaId());
            d.setCantidad(it.getCantidad());
            d.setPrecioUnitario(it.getPrecioUnitario());
            d.setSubtotal(lineSubtotal(it.getCantidad(), it.getPrecioUnitario()));
            d.setCreatedBy(uid);
            d.setFlagEstado("1");
            list.add(d);
        }
        return list;
    }

    private List<FsFacturaSimplPago> buildPagos(FsFacturaSimpl f, List<FacturaSimplPagoRequest> pagos) {
        List<FsFacturaSimplPago> list = new ArrayList<>();
        Long uid = TenantContext.getUsuarioId();
        for (FacturaSimplPagoRequest p : pagos) {
            FsFacturaSimplPago row = new FsFacturaSimplPago();
            row.setFactura(f);
            row.setFormaPagoId(p.getFormaPagoId());
            row.setMonto(p.getMonto());
            row.setReferencia(p.getReferencia());
            row.setFechaPago(p.getFechaPago() != null ? p.getFechaPago() : Instant.now());
            row.setCreatedBy(uid);
            row.setFlagEstado("1");
            list.add(row);
        }
        return list;
    }

    private static BigDecimal lineSubtotal(BigDecimal cantidad, BigDecimal precioUnitario) {
        return cantidad.multiply(precioUnitario).setScale(4, RoundingMode.HALF_UP);
    }

    private static void recalcMontos(FsFacturaSimpl f) {
        BigDecimal subtotal = f.getDetalles().stream()
                .map(FsFacturaSimplDet::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(4, RoundingMode.HALF_UP);
        f.setSubtotal(subtotal);
        BigDecimal igv = subtotal.multiply(IGV_RATE).setScale(4, RoundingMode.HALF_UP);
        f.setImpuesto(igv);
        f.setTotal(subtotal.add(igv).setScale(4, RoundingMode.HALF_UP));
    }

    private Long resolveSucursalId(Long requested) {
        Long ctx = TenantContext.getSucursalId();
        if (requested == null) {
            if (ctx == null) {
                throw new BusinessException("sucursalId requerido", HttpStatus.BAD_REQUEST, VentasErrorCodes.FS_FK);
            }
            return ctx;
        }
        if (ctx != null && !ctx.equals(requested)) {
            throw new BusinessException("sucursalId no coincide con el token", HttpStatus.FORBIDDEN, VentasErrorCodes.FS_FK);
        }
        if (!fkValidator.existsSucursalActiva(requested)) {
            throw new BusinessException("Sucursal no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.FS_FK);
        }
        return requested;
    }

    private Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no resoluble desde el token", HttpStatus.UNAUTHORIZED, VentasErrorCodes.FS_FK);
        }
        return uid;
    }

    private FacturaSimplificadaResponse toResponse(FsFacturaSimpl f) {
        List<FacturaSimplDetResponse> items = f.getDetalles() == null ? List.of() : f.getDetalles().stream()
                .map(d -> FacturaSimplDetResponse.builder()
                        .id(d.getId())
                        .articuloId(d.getArticuloId())
                        .unidadMedidaId(d.getUnidadMedidaId())
                        .cantidad(d.getCantidad())
                        .precioUnitario(d.getPrecioUnitario())
                        .subtotal(d.getSubtotal())
                        .flagEstado(d.getFlagEstado())
                        .build())
                .toList();
        return FacturaSimplificadaResponse.builder()
                .id(f.getId())
                .sucursalId(f.getSucursalId())
                .puntoVentaId(f.getPuntoVentaId())
                .clienteId(f.getClienteId())
                .docTipoId(f.getDocTipoId())
                .serie(f.getSerie())
                .numero(f.getNumero())
                .fechaEmision(f.getFechaEmision())
                .monedaId(f.getMonedaId())
                .subtotal(f.getSubtotal())
                .impuesto(f.getImpuesto())
                .total(f.getTotal())
                .cntasCobrarId(f.getCntasCobrarId())
                .flagEstado(f.getFlagEstado())
                .createdBy(f.getCreatedBy())
                .fecCreacion(f.getFecCreacion())
                .updatedBy(f.getUpdatedBy())
                .fecModificacion(f.getFecModificacion())
                .items(items)
                .pagos(mapPagos(f.getPagos()))
                .build();
    }

    private List<FacturaSimplPagoResponse> mapPagos(List<FsFacturaSimplPago> pagos) {
        if (pagos == null) {
            return List.of();
        }
        return pagos.stream()
                .map(p -> FacturaSimplPagoResponse.builder()
                        .id(p.getId())
                        .formaPagoId(p.getFormaPagoId())
                        .monto(p.getMonto())
                        .referencia(p.getReferencia())
                        .fechaPago(p.getFechaPago())
                        .flagEstado(p.getFlagEstado())
                        .build())
                .toList();
    }
}
