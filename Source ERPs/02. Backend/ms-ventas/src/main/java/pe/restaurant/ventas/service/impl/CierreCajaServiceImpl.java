package pe.restaurant.ventas.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.CierreCajaCerrarRequest;
import pe.restaurant.ventas.dto.request.CierreCajaRequest;
import pe.restaurant.ventas.entity.CierreCaja;
import pe.restaurant.ventas.repository.CierreCajaRepository;
import pe.restaurant.ventas.service.CierreCajaService;
import pe.restaurant.ventas.service.VentasErrorCodes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CierreCajaServiceImpl implements CierreCajaService {

    private final CierreCajaRepository repository;

    @Override
    public Page<CierreCaja> findAll(Long turnoId, Boolean abierto, Pageable pageable) {
        return repository.findWithFilters(turnoId, abierto, pageable);
    }

    @Override
    public CierreCaja findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CierreCaja", id));
    }

    @Override
    @Transactional
    public CierreCaja create(CierreCajaRequest request) {
        if (request.getTurnoId() != null && repository.countAbiertoByTurno(request.getTurnoId()) > 0) {
            throw new BusinessException("Ya existe un cierre de caja abierto para este turno", VentasErrorCodes.CIERRE_CAJA_STATE);
        }
        CierreCaja c = new CierreCaja();
        c.setTurnoId(request.getTurnoId());
        c.setVentasEfectivo(nvl(request.getVentasEfectivo()));
        c.setVentasTarjeta(nvl(request.getVentasTarjeta()));
        c.setVentasDigital(nvl(request.getVentasDigital()));
        c.setVentasTotal(nvl(request.getVentasTotal()));
        c.setPropinasTotal(nvl(request.getPropinasTotal()));
        c.setFondoInicial(nvl(request.getFondoInicial()));
        c.setFondoFinal(null);
        c.setDiferencia(BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP));
        c.setObservaciones(request.getObservaciones());
        c.setFechaCierre(null);
        c.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(c);
    }

    @Override
    @Transactional
    public CierreCaja cerrar(Long id, CierreCajaCerrarRequest request) {
        CierreCaja c = findById(id);
        if (c.getFechaCierre() != null) {
            throw new BusinessException("El cierre ya fue finalizado", VentasErrorCodes.CIERRE_CAJA_STATE);
        }
        BigDecimal fondoIni = nvl(c.getFondoInicial());
        BigDecimal ventas = nvl(c.getVentasTotal());
        BigDecimal esperado = fondoIni.add(ventas).setScale(4, RoundingMode.HALF_UP);
        BigDecimal fondoFin = request.getFondoFinal().setScale(4, RoundingMode.HALF_UP);
        BigDecimal dif = request.getDiferencia();
        if (dif == null) {
            dif = fondoFin.subtract(esperado).setScale(4, RoundingMode.HALF_UP);
        } else {
            dif = dif.setScale(4, RoundingMode.HALF_UP);
        }
        c.setFondoFinal(fondoFin);
        c.setDiferencia(dif);
        if (request.getObservaciones() != null) {
            c.setObservaciones(request.getObservaciones());
        }
        c.setFechaCierre(Instant.now());
        c.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(c);
    }

    private static BigDecimal nvl(BigDecimal v) {
        return v != null ? v.setScale(4, RoundingMode.HALF_UP) : BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP);
    }
}
