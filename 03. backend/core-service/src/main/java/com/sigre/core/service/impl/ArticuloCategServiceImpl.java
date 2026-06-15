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
import com.sigre.core.entity.ArticuloCateg;
import com.sigre.core.repository.ArticuloCategRepository;
import com.sigre.core.service.ArticuloCategService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloCategServiceImpl implements ArticuloCategService {

    private final ArticuloCategRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "findAll"})
    @Override
    public Page<ArticuloCateg> findAll(Pageable pageable) {
        if (pageable.isUnpaged()) {
            log.info("Listando todas las categorías de artículo (sin paginación)");
        } else {
            log.info("Listando categorías de artículo - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        }
        Page<ArticuloCateg> page = repository.findAll(pageable);
        log.info("Categorías de artículo encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "findById"})
    @Override
    public ArticuloCateg findById(Long id) {
        log.info("Buscando categoría de artículo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("ArticuloCateg no encontrada con id: {}", id);
                    return new ResourceNotFoundException("ArticuloCateg", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "create"})
    @Override
    @Transactional
    public ArticuloCateg create(ArticuloCateg entity) {
        log.info("Creando categoría de artículo con catArt: {}", entity.getCatArt());
        if (repository.existsByCatArtIgnoreCase(entity.getCatArt())) {
            throw new BusinessException("Ya existe una categoría de artículo con catArt: " + entity.getCatArt(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ArticuloCateg saved = repository.save(entity);
        log.info("ArticuloCateg creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "update"})
    @Override
    @Transactional
    public ArticuloCateg update(Long id, ArticuloCateg entity) {
        log.info("Actualizando categoría de artículo con id: {}", id);
        findById(id);
        if (repository.existsByCatArtIgnoreCaseAndIdNot(entity.getCatArt(), id)) {
            throw new BusinessException("Ya existe una categoría de artículo con catArt: " + entity.getCatArt(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        ArticuloCateg updated = repository.save(entity);
        log.info("ArticuloCateg actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloCateg activate(Long id) {
        log.info("Activando categoría de artículo con id: {}", id);
        ArticuloCateg existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloCateg saved = repository.save(existing);
        log.info("ArticuloCateg activada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloCateg deactivate(Long id) {
        log.info("Desactivando categoría de artículo con id: {}", id);
        ArticuloCateg existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloCateg saved = repository.save(existing);
        log.info("ArticuloCateg desactivada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_categ", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando categoría de artículo con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("ArticuloCateg eliminada exitosamente con id: {}", id);
    }
}
