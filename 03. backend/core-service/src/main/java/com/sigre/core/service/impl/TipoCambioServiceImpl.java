package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.core.entity.TipoCambio;
import com.sigre.core.repository.MonedaRepository;
import com.sigre.core.repository.TipoCambioRepository;
import com.sigre.core.service.TipoCambioService;

import java.time.Instant;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoCambioServiceImpl implements TipoCambioService {

    private final TipoCambioRepository repository;
    private final MonedaRepository monedaRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "findAll"})
    @Override
    public Page<TipoCambio> findAll(Long monedaId, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        log.info("Listando tipos de cambio - monedaId: {}, fechaDesde: {}, fechaHasta: {}, page: {}, size: {}",
                monedaId, fechaDesde, fechaHasta, pageable.getPageNumber(), pageable.getPageSize());
        Specification<TipoCambio> spec = Specification.allOf();
        if (monedaId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("monedaId"), monedaId));
        }
        if (fechaDesde != null) {
            spec = spec.and((root, q, cb) -> cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
        }
        if (fechaHasta != null) {
            spec = spec.and((root, q, cb) -> cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
        }
        Page<TipoCambio> page = repository.findAll(spec, pageable);
        log.info("Tipos de cambio encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "findByFecha"})
    @Override
    public TipoCambio findByFecha(LocalDate fecha, Long monedaId) {
        log.info("Buscando tipo de cambio - fecha: {}, monedaId: {}", fecha, monedaId);
        return repository.findByFechaAndMonedaId(fecha, monedaId)
                .orElseThrow(() -> {
                    log.warn("Tipo de cambio no encontrado - fecha: {}, monedaId: {}", fecha, monedaId);
                    return new ResourceNotFoundException("TipoCambio", "fecha/moneda", fecha.toString());
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "findUltimoByFecha"})
    @Override
    public TipoCambio findUltimoByFecha(LocalDate fecha, Long monedaId) {
        log.info("Buscando último tipo de cambio - fecha: {}, monedaId: {}", fecha, monedaId);
        return repository.findFirstByMonedaIdAndFechaLessThanEqualOrderByFechaDesc(monedaId, fecha)
                .orElseThrow(() -> {
                    log.warn("Tipo de cambio no encontrado para fecha: {}, monedaId: {}", fecha, monedaId);
                    return new ResourceNotFoundException("TipoCambio", "fecha/moneda", fecha.toString());
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "findById"})
    @Override
    public TipoCambio findById(Long id) {
        log.info("Buscando tipo de cambio con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Tipo de cambio no encontrado con id: {}", id);
                    return new ResourceNotFoundException("TipoCambio", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "create"})
    @Override
    @Transactional
    public TipoCambio create(TipoCambio entity) {
        log.info("Creando tipo de cambio - fecha: {}, monedaId: {}", entity.getFecha(), entity.getMonedaId());
        validateMoneda(entity.getMonedaId());
        repository.findByFechaAndMonedaId(entity.getFecha(), entity.getMonedaId())
                .ifPresent(existing -> {
                    log.warn("Intento de duplicar tipo de cambio - fecha: {}, monedaId: {}",
                            entity.getFecha(), entity.getMonedaId());
                    throw new BusinessException("Ya existe un tipo de cambio para esa fecha y moneda", HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        TipoCambio saved = repository.save(entity);
        log.info("Tipo de cambio creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "update"})
    @Override
    @Transactional
    public TipoCambio update(Long id, TipoCambio entity) {
        log.info("Actualizando tipo de cambio con id: {}", id);
        TipoCambio existing = findById(id);
        validateMoneda(entity.getMonedaId());
        repository.findByFechaAndMonedaId(entity.getFecha(), entity.getMonedaId())
                .filter(e -> !e.getId().equals(id))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar tipo de cambio - fecha: {}, monedaId: {}",
                            entity.getFecha(), entity.getMonedaId());
                    throw new BusinessException("Ya existe un tipo de cambio para esa fecha y moneda", HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
        existing.setMonedaId(entity.getMonedaId());
        existing.setFecha(entity.getFecha());
        existing.setCompra(entity.getCompra());
        existing.setVenta(entity.getVenta());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        TipoCambio updated = repository.save(existing);
        log.info("Tipo de cambio actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando tipo de cambio con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Tipo de cambio eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "activate"})
    @Override
    @Transactional
    public TipoCambio activate(Long id) {
        log.info("Activando tipo de cambio con id: {}", id);
        TipoCambio existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_cambio", "operation", "deactivate"})
    @Override
    @Transactional
    public TipoCambio deactivate(Long id) {
        log.info("Desactivando tipo de cambio con id: {}", id);
        TipoCambio existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateMoneda(Long monedaId) {
        if (!monedaRepository.existsById(monedaId)) {
            throw new ResourceNotFoundException("Moneda", monedaId);
        }
    }
}
