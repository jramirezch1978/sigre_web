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
import com.sigre.core.entity.ArticuloEquivalencia;
import com.sigre.core.repository.ArticuloEquivalenciaRepository;
import com.sigre.core.repository.ArticuloRepository;
import com.sigre.core.service.ArticuloEquivalenciaService;

import com.sigre.common.security.TenantContext;
import java.time.Instant;
import java.math.BigDecimal;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloEquivalenciaServiceImpl implements ArticuloEquivalenciaService {

    private final ArticuloEquivalenciaRepository repository;
    private final ArticuloRepository articuloRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "findAll"})
    @Override
    public Page<ArticuloEquivalencia> findAll(Long articuloId, Pageable pageable) {
        log.info("Listando equivalencias - articuloId: {}, page: {}, size: {}",
                articuloId, pageable.getPageNumber(), pageable.getPageSize());
        if (articuloId != null) {
            return repository.findByArticuloId(articuloId, pageable);
        }
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "findById"})
    @Override
    public ArticuloEquivalencia findById(Long id) {
        log.info("Buscando equivalencia con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Equivalencia no encontrada con id: {}", id);
                    return new ResourceNotFoundException("ArticuloEquivalencia", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "create"})
    @Override
    @Transactional
    public ArticuloEquivalencia create(ArticuloEquivalencia entity) {
        log.info("Creando equivalencia - articuloId: {}, articuloEquivalenteId: {}",
                entity.getArticuloId(), entity.getArticuloEquivalenteId());
        validateBusinessRules(entity);
        validateForeignKeys(entity);
        if (repository.existsByArticuloIdAndArticuloEquivalenteId(entity.getArticuloId(), entity.getArticuloEquivalenteId())) {
            throw new BusinessException("Ya existe una equivalencia entre estos articulos",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ArticuloEquivalencia saved = repository.save(entity);
        log.info("Equivalencia creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "update"})
    @Override
    @Transactional
    public ArticuloEquivalencia update(Long id, ArticuloEquivalencia entity) {
        log.info("Actualizando equivalencia con id: {}", id);
        ArticuloEquivalencia existing = findById(id);
        validateBusinessRules(entity);
        validateForeignKeys(entity);
        boolean parChanged = !existing.getArticuloId().equals(entity.getArticuloId())
                || !existing.getArticuloEquivalenteId().equals(entity.getArticuloEquivalenteId());
        if (parChanged && repository.existsByArticuloIdAndArticuloEquivalenteId(entity.getArticuloId(), entity.getArticuloEquivalenteId())) {
            throw new BusinessException("Ya existe una equivalencia entre estos articulos",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        existing.setArticuloId(entity.getArticuloId());
        existing.setArticuloEquivalenteId(entity.getArticuloEquivalenteId());
        existing.setFactor(entity.getFactor());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ArticuloEquivalencia updated = repository.save(existing);
        log.info("Equivalencia actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando equivalencia con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Equivalencia eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloEquivalencia activate(Long id) {
        log.info("Activando equivalencia con id: {}", id);
        ArticuloEquivalencia existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_equivalencias", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloEquivalencia deactivate(Long id) {
        log.info("Desactivando equivalencia con id: {}", id);
        ArticuloEquivalencia existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateBusinessRules(ArticuloEquivalencia entity) {
        if (entity.getArticuloId().equals(entity.getArticuloEquivalenteId())) {
            throw new BusinessException("Un artículo no puede ser equivalente de sí mismo",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
        if (entity.getFactor() == null || entity.getFactor().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("El factor de equivalencia debe ser mayor a 0",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private void validateForeignKeys(ArticuloEquivalencia entity) {
        if (!articuloRepository.existsById(entity.getArticuloId())) {
            throw new ResourceNotFoundException("Articulo", entity.getArticuloId());
        }
        if (!articuloRepository.existsById(entity.getArticuloEquivalenteId())) {
            throw new ResourceNotFoundException("Articulo (equivalente)", entity.getArticuloEquivalenteId());
        }
    }
}
