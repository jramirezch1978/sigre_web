package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.entity.DescuentoPromocion;
import com.sigre.comercializacion.repository.DescuentoPromocionRepository;
import com.sigre.comercializacion.service.DescuentoPromocionService;
import com.sigre.comercializacion.service.VentasErrorCodes;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DescuentoPromocionServiceImpl implements DescuentoPromocionService {

    private final DescuentoPromocionRepository repository;

    @Override
    public Page<DescuentoPromocion> findAll(String nombre, String tipo, String flagEstado, Pageable pageable) {
        return repository.findWithFilters(nombre, tipo, flagEstado, pageable);
    }

    @Override
    public DescuentoPromocion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("DescuentoPromocion", id));
    }

    @Override
    @Transactional
    public DescuentoPromocion create(DescuentoPromocionRequest request) {
        validarTipo(request.getTipo());
        DescuentoPromocion d = map(request);
        d.setCreatedBy(TenantContext.getUsuarioId());
        d.setFlagEstado("1");
        return repository.save(d);
    }

    @Override
    @Transactional
    public DescuentoPromocion update(Long id, DescuentoPromocionRequest request) {
        validarTipo(request.getTipo());
        DescuentoPromocion d = findById(id);
        d.setNombre(request.getNombre());
        d.setTipo(request.getTipo());
        d.setValor(request.getValor());
        d.setFechaInicio(request.getFechaInicio());
        d.setFechaFin(request.getFechaFin());
        d.setDiasAplicacion(request.getDiasAplicacion());
        d.setHoraInicio(request.getHoraInicio());
        d.setHoraFin(request.getHoraFin());
        d.setMontoMinimo(request.getMontoMinimo());
        d.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(d);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        DescuentoPromocion d = findById(id);
        d.setFlagEstado("0");
        d.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(d);
    }

    @Override
    @Transactional
    public DescuentoPromocion activar(Long id) {
        DescuentoPromocion d = findById(id);
        d.setFlagEstado("1");
        d.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(d);
    }

    @Override
    @Transactional
    public DescuentoPromocion desactivar(Long id) {
        DescuentoPromocion d = findById(id);
        d.setFlagEstado("0");
        d.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(d);
    }

    private void validarTipo(String tipo) {
        if (tipo == null || tipo.isBlank()) {
            throw new BusinessException("tipo es obligatorio (ej. PORCENTAJE, MONTO_FIJO)", VentasErrorCodes.DESCUENTO_PROMOCION_INVALIDO);
        }
    }

    private static DescuentoPromocion map(DescuentoPromocionRequest r) {
        DescuentoPromocion d = new DescuentoPromocion();
        d.setNombre(r.getNombre());
        d.setTipo(r.getTipo());
        d.setValor(r.getValor());
        d.setFechaInicio(r.getFechaInicio());
        d.setFechaFin(r.getFechaFin());
        d.setDiasAplicacion(r.getDiasAplicacion());
        d.setHoraInicio(r.getHoraInicio());
        d.setHoraFin(r.getHoraFin());
        d.setMontoMinimo(r.getMontoMinimo());
        return d;
    }
}
