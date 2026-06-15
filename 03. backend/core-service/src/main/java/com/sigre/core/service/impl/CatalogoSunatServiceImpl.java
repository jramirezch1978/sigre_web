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
import com.sigre.core.entity.CatalogoSunat;
import com.sigre.core.repository.CatalogoSunatRepository;
import com.sigre.core.service.CatalogoSunatService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CatalogoSunatServiceImpl implements CatalogoSunatService {

    private final CatalogoSunatRepository repository;

    @Override
    public Page<CatalogoSunat> findAll(String codigoCatalogo, String nombreCatalogo, String flagEstado, Pageable pageable) {
        return repository.findWithFilters(codigoCatalogo, nombreCatalogo, flagEstado, pageable);
    }

    @Override
    public CatalogoSunat findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CatalogoSunat", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat", "operation", "create"})
    public CatalogoSunat create(CatalogoSunat entity) {
        log.info("Creando catálogo SUNAT con código: {}", entity.getCodigoCatalogo());
        validateUniqueCodigo(entity.getCodigoCatalogo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        CatalogoSunat saved = repository.save(entity);
        log.info("Catálogo SUNAT creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat", "operation", "update"})
    public CatalogoSunat update(Long id, CatalogoSunat entity) {
        log.info("Actualizando catálogo SUNAT con id: {}", id);
        CatalogoSunat existing = findById(id);
        validateUniqueCodigo(entity.getCodigoCatalogo(), id);
        existing.setCodigoCatalogo(entity.getCodigoCatalogo());
        existing.setNombreCatalogo(entity.getNombreCatalogo());
        existing.setDescripcionCatalogo(entity.getDescripcionCatalogo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        CatalogoSunat updated = repository.save(existing);
        log.info("Catálogo SUNAT actualizado con id: {}", id);
        return updated;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat", "operation", "activate"})
    public CatalogoSunat activate(Long id) {
        CatalogoSunat entity = findById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat", "operation", "deactivate"})
    public CatalogoSunat deactivate(Long id) {
        CatalogoSunat entity = findById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigoCatalogo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un catálogo SUNAT con código: " + codigo,
                            HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
