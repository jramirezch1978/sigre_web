package com.sigre.compras.service.impl;

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
import com.sigre.compras.entity.ArticuloEstructura;
import com.sigre.compras.entity.ArticuloEstructuraId;
import com.sigre.compras.repository.ArticuloEstructuraRepository;
import com.sigre.compras.service.ArticuloEstructuraService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloEstructuraServiceImpl implements ArticuloEstructuraService {

    private final ArticuloEstructuraRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_estructura", "operation", "findAll"})
    @Override
    public Page<ArticuloEstructura> findAll(Long articuloPadreId, Pageable pageable) {
        log.info("Listando estructura de artículos - articuloPadreId: {}, page: {}, size: {}",
                articuloPadreId, pageable.getPageNumber(), pageable.getPageSize());
        Page<ArticuloEstructura> page;
        if (articuloPadreId != null) {
            page = repository.findByArticuloPadreId(articuloPadreId, pageable);
        } else {
            page = repository.findAll(pageable);
        }
        log.info("Estructuras de artículo encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_estructura", "operation", "findById"})
    @Override
    public ArticuloEstructura findById(ArticuloEstructuraId id) {
        log.info("Buscando estructura de artículo con articuloPadreId: {}, articuloHijoId: {}",
                id.getArticuloPadreId(), id.getArticuloHijoId());
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Estructura de artículo no encontrada con articuloPadreId: {}, articuloHijoId: {}",
                            id.getArticuloPadreId(), id.getArticuloHijoId());
                    return new ResourceNotFoundException("ArticuloEstructura", "articuloPadreId/articuloHijoId",
                            id.getArticuloPadreId() + "/" + id.getArticuloHijoId());
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_estructura", "operation", "create"})
    @Override
    @Transactional
    public ArticuloEstructura create(ArticuloEstructura entity) {
        log.info("Creando estructura de artículo - articuloPadreId: {}, articuloHijoId: {}",
                entity.getArticuloPadreId(), entity.getArticuloHijoId());

        if (entity.getArticuloPadreId().equals(entity.getArticuloHijoId())) {
            throw new BusinessException(
                    "El artículo padre no puede ser igual al artículo hijo",
                    HttpStatus.BAD_REQUEST, "BUSINESS_ERROR");
        }

        ArticuloEstructuraId id = new ArticuloEstructuraId(entity.getArticuloPadreId(), entity.getArticuloHijoId());
        if (repository.existsById(id)) {
            throw new BusinessException(
                    "Ya existe una estructura con articuloPadreId=" + entity.getArticuloPadreId()
                            + " y articuloHijoId=" + entity.getArticuloHijoId(),
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }

        ArticuloEstructura saved = repository.save(entity);
        log.info("Estructura de artículo creada exitosamente - articuloPadreId: {}, articuloHijoId: {}",
                saved.getArticuloPadreId(), saved.getArticuloHijoId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_estructura", "operation", "update"})
    @Override
    @Transactional
    public ArticuloEstructura update(ArticuloEstructuraId id, ArticuloEstructura entity) {
        log.info("Actualizando estructura de artículo - articuloPadreId: {}, articuloHijoId: {}",
                id.getArticuloPadreId(), id.getArticuloHijoId());
        ArticuloEstructura existing = findById(id);
        existing.setCantidad(entity.getCantidad());
        ArticuloEstructura updated = repository.save(existing);
        log.info("Estructura de artículo actualizada exitosamente - articuloPadreId: {}, articuloHijoId: {}",
                id.getArticuloPadreId(), id.getArticuloHijoId());
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_estructura", "operation", "delete"})
    @Override
    @Transactional
    public void delete(ArticuloEstructuraId id) {
        log.info("Eliminando estructura de artículo - articuloPadreId: {}, articuloHijoId: {}",
                id.getArticuloPadreId(), id.getArticuloHijoId());
        findById(id);
        repository.deleteById(id);
        log.info("Estructura de artículo eliminada exitosamente - articuloPadreId: {}, articuloHijoId: {}",
                id.getArticuloPadreId(), id.getArticuloHijoId());
    }
}
