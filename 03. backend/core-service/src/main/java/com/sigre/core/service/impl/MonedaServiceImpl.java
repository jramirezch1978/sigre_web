package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
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
import com.sigre.core.entity.Moneda;
import com.sigre.core.repository.MonedaRepository;
import com.sigre.core.service.MonedaService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MonedaServiceImpl implements MonedaService {

    private final MonedaRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "findAll"})
    @Override
    public Page<Moneda> findAll(Pageable pageable) {
        log.info("Listando monedas - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Moneda> page = repository.findAll(pageable);
        log.info("Monedas encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "findById"})
    @Override
    public Moneda findById(Long id) {
        log.info("Buscando moneda con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Moneda no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Moneda", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "create"})
    @Override
    @Transactional
    public Moneda create(Moneda entity) {
        log.info("Creando moneda con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Moneda saved = repository.save(entity);
        log.info("Moneda creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "update"})
    @Override
    @Transactional
    public Moneda update(Long id, Moneda entity) {
        log.info("Actualizando moneda con id: {}", id);
        Moneda existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setSimbolo(entity.getSimbolo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        Moneda updated = repository.save(existing);
        log.info("Moneda actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "activate"})
    @Override
    @Transactional
    public Moneda activate(Long id) {
        log.info("Activando moneda con id: {}", id);
        Moneda entity = findById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "deactivate"})
    @Override
    @Transactional
    public Moneda deactivate(Long id) {
        log.info("Desactivando moneda con id: {}", id);
        Moneda entity = findById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "moneda", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando moneda con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Moneda eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de moneda: {} (moneda existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe una moneda con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
