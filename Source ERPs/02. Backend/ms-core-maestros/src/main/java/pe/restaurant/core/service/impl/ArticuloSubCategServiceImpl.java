package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.ArticuloSubCateg;
import pe.restaurant.core.repository.ArticuloCategRepository;
import pe.restaurant.core.repository.ArticuloSubCategRepository;
import pe.restaurant.core.service.ArticuloSubCategService;

import java.util.List;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloSubCategServiceImpl implements ArticuloSubCategService {

    private final ArticuloSubCategRepository repository;
    private final ArticuloCategRepository articuloCategRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "findAll"})
    @Override
    public Page<ArticuloSubCateg> findAll(Pageable pageable) {
        log.info("Listando sub-categorías de artículo - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ArticuloSubCateg> page = repository.findAll(pageable);
        log.info("Sub-categorías de artículo encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "findByCategoria"})
    @Override
    public List<ArticuloSubCateg> findByCategoria(Long articuloCategId) {
        log.info("Listando sub-categorías por categoría id: {}", articuloCategId);
        return repository.findByArticuloCategId(articuloCategId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "findById"})
    @Override
    public ArticuloSubCateg findById(Long id) {
        log.info("Buscando sub-categoría de artículo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("ArticuloSubCateg no encontrada con id: {}", id);
                    return new ResourceNotFoundException("ArticuloSubCateg", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "create"})
    @Override
    @Transactional
    public ArticuloSubCateg create(ArticuloSubCateg entity) {
        log.info("Creando sub-categoría de artículo con codSubCat: {}", entity.getCodSubCat());
        articuloCategRepository.findById(entity.getArticuloCategId())
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloCateg", entity.getArticuloCategId()));
        if (repository.existsByCodSubCatIgnoreCase(entity.getCodSubCat())) {
            throw new BusinessException("Ya existe una sub-categoría con codSubCat: " + entity.getCodSubCat(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ArticuloSubCateg saved = repository.save(entity);
        log.info("ArticuloSubCateg creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "update"})
    @Override
    @Transactional
    public ArticuloSubCateg update(Long id, ArticuloSubCateg entity) {
        log.info("Actualizando sub-categoría de artículo con id: {}", id);
        findById(id);
        articuloCategRepository.findById(entity.getArticuloCategId())
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloCateg", entity.getArticuloCategId()));
        if (repository.existsByCodSubCatIgnoreCaseAndIdNot(entity.getCodSubCat(), id)) {
            throw new BusinessException("Ya existe una sub-categoría con codSubCat: " + entity.getCodSubCat(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        ArticuloSubCateg updated = repository.save(entity);
        log.info("ArticuloSubCateg actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloSubCateg activate(Long id) {
        log.info("Activando sub-categoría de artículo con id: {}", id);
        ArticuloSubCateg existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloSubCateg saved = repository.save(existing);
        log.info("ArticuloSubCateg activada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloSubCateg deactivate(Long id) {
        log.info("Desactivando sub-categoría de artículo con id: {}", id);
        ArticuloSubCateg existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloSubCateg saved = repository.save(existing);
        log.info("ArticuloSubCateg desactivada exitosamente con id: {}", id);
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_sub_categ", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando sub-categoría de artículo con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("ArticuloSubCateg eliminada exitosamente con id: {}", id);
    }
}
