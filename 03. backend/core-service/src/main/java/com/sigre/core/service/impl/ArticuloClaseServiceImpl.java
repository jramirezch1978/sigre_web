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
import com.sigre.core.entity.ArticuloClase;
import com.sigre.core.repository.ArticuloClaseRepository;
import com.sigre.core.service.ArticuloClaseService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloClaseServiceImpl implements ArticuloClaseService {

    private final ArticuloClaseRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "findAll"})
    @Override
    public Page<ArticuloClase> findAll(Pageable pageable) {
        log.info("Listando clases de artículo - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ArticuloClase> page = repository.findAll(pageable);
        log.info("Clases de artículo encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "findById"})
    @Override
    public ArticuloClase findById(Long id) {
        log.info("Buscando clase de artículo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("ArticuloClase no encontrada con id: {}", id);
                    return new ResourceNotFoundException("ArticuloClase", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "create"})
    @Override
    @Transactional
    public ArticuloClase create(ArticuloClase entity) {
        log.info("Creando clase de artículo con codClase: {}", entity.getCodClase());
        if (repository.existsByCodClaseIgnoreCase(entity.getCodClase())) {
            throw new BusinessException("Ya existe una clase de artículo con codClase: " + entity.getCodClase(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ArticuloClase saved = repository.save(entity);
        log.info("ArticuloClase creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "update"})
    @Override
    @Transactional
    public ArticuloClase update(Long id, ArticuloClase entity) {
        log.info("Actualizando clase de artículo con id: {}", id);
        findById(id);
        if (repository.existsByCodClaseIgnoreCaseAndIdNot(entity.getCodClase(), id)) {
            throw new BusinessException("Ya existe una clase de artículo con codClase: " + entity.getCodClase(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        ArticuloClase updated = repository.save(entity);
        log.info("ArticuloClase actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloClase activate(Long id) {
        log.info("Activando clase de artículo con id: {}", id);
        ArticuloClase existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloClase saved = repository.save(existing);
        log.info("ArticuloClase activada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloClase deactivate(Long id) {
        log.info("Desactivando clase de artículo con id: {}", id);
        ArticuloClase existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloClase saved = repository.save(existing);
        log.info("ArticuloClase desactivada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_clase", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando clase de artículo con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("ArticuloClase eliminada exitosamente con id: {}", id);
    }
}
