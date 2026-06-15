package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.comercializacion.dto.request.ProformaDetLineRequest;
import com.sigre.comercializacion.dto.request.ProformaRequest;
import com.sigre.comercializacion.entity.Proforma;
import com.sigre.comercializacion.entity.ProformaDet;
import com.sigre.comercializacion.repository.ProformaRepository;
import com.sigre.comercializacion.service.ProformaService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.comercializacion.service.VentasNumeradorTablas;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProformaServiceImpl implements ProformaService {

    private static final BigDecimal IGV_RATE = new BigDecimal("0.18");
    private static final String FLAG_ACTIVO = "1";

    /** Numeración correlativa vía {@link NumeradorDocumentoService} (common) → {@code core.fn_get_document_number}. */
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final ProformaRepository repository;

    private static void requireCabeceraActiva(Proforma p) {
        if (!FLAG_ACTIVO.equals(p.getFlagEstado())) {
            throw new BusinessException("Operación no permitida sobre un documento inactivo", VentasErrorCodes.PROFORMA_STATE);
        }
    }

    @Override
    public Page<Proforma> findAll(Long sucursalId, Long clienteId, String numero, Pageable pageable) {
        return repository.findWithFilters(sucursalId, clienteId, numero, pageable);
    }

    @Override
    public Proforma findById(Long id) {
        return repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Proforma", id));
    }

    @Override
    @Transactional
    public Proforma create(ProformaRequest request) {
        String numero = request.getNumero();
        if (numero == null || numero.isBlank()) {
            Long sucursalId = request.getSucursalId();
            if (sucursalId == null) {
                throw new BusinessException(
                        "sucursalId es obligatoria para generar el número de proforma (numerador PostgreSQL).",
                        VentasErrorCodes.PROFORMA_SUCURSAL_NUMERADOR);
            }
            // Numerador corporativo: tabla + sucursal + año → CHAR(12). Ver NumeradorDocumentoService en common.
            numero = numeradorDocumentoService.siguienteNroDocumento(
                    VentasNumeradorTablas.PROFORMA,
                    sucursalId,
                    request.getFecha().getYear());
        } else if (repository.existsByNumero(numero)) {
            throw new BusinessException("Número de proforma duplicado", VentasErrorCodes.PROFORMA_NUMERO_DUPLICADO);
        }

        Proforma p = new Proforma();
        p.setSucursalId(request.getSucursalId());
        p.setClienteId(request.getClienteId());
        p.setNumero(numero);
        p.setFecha(request.getFecha());
        p.setFechaValidez(request.getFechaValidez());
        p.setMonedaId(request.getMonedaId());
        p.setCreatedBy(TenantContext.getUsuarioId());
        aplicarDetallesYTotales(p, request.getDetalles());
        return repository.save(p);
    }

    @Override
    @Transactional
    public Proforma update(Long id, ProformaRequest request) {
        Proforma p = findById(id);
        requireCabeceraActiva(p);
        p.setSucursalId(request.getSucursalId());
        p.setClienteId(request.getClienteId());
        p.setFecha(request.getFecha());
        p.setFechaValidez(request.getFechaValidez());
        p.setMonedaId(request.getMonedaId());
        p.setUpdatedBy(TenantContext.getUsuarioId());
        aplicarDetallesYTotales(p, request.getDetalles());
        return repository.save(p);
    }

    @Override
    @Transactional
    public Proforma anular(Long id) {
        Proforma p = findById(id);
        requireCabeceraActiva(p);
        p.setFlagEstado("0");
        p.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(p);
    }

    @Override
    @Transactional
    public Proforma marcarVencida(Long id) {
        Proforma p = findById(id);
        requireCabeceraActiva(p);
        p.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(p);
    }

    @Override
    @Transactional
    public Proforma marcarConvertida(Long id) {
        Proforma p = findById(id);
        requireCabeceraActiva(p);
        p.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(p);
    }

    private void aplicarDetallesYTotales(Proforma p, java.util.List<ProformaDetLineRequest> lines) {
        p.getDetalles().clear();
        if (lines == null || lines.isEmpty()) {
            p.setSubtotal(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP));
            p.setIgv(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP));
            p.setTotal(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP));
            return;
        }
        BigDecimal subtotal = BigDecimal.ZERO;
        for (ProformaDetLineRequest r : lines) {
            BigDecimal desc = r.getDescuento() != null ? r.getDescuento() : BigDecimal.ZERO;
            BigDecimal lineSub = r.getCantidad().multiply(r.getPrecioUnitario()).subtract(desc)
                    .setScale(4, RoundingMode.HALF_UP);
            ProformaDet d = new ProformaDet();
            d.setProforma(p);
            d.setArticuloId(r.getArticuloId());
            d.setDescripcion(r.getDescripcion());
            d.setCantidad(r.getCantidad());
            d.setPrecioUnitario(r.getPrecioUnitario());
            d.setDescuento(desc);
            d.setSubtotal(lineSub);
            p.getDetalles().add(d);
            subtotal = subtotal.add(lineSub);
        }
        subtotal = subtotal.setScale(4, RoundingMode.HALF_UP);
        BigDecimal igv = subtotal.multiply(IGV_RATE).setScale(4, RoundingMode.HALF_UP);
        p.setSubtotal(subtotal);
        p.setIgv(igv);
        p.setTotal(subtotal.add(igv).setScale(4, RoundingMode.HALF_UP));
    }
}
