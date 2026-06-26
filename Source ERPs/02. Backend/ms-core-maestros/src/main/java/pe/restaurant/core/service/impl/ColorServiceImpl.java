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
import pe.restaurant.core.entity.Color;
import pe.restaurant.core.repository.ColorRepository;
import pe.restaurant.core.service.ColorService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ColorServiceImpl implements ColorService {

    private final ColorRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "findAll"})
    @Override
    public Page<Color> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "findById"})
    @Override
    public Color findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Color", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "create"})
    @Override @Transactional
    public Color create(Color entity) {
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "update"})
    @Override @Transactional
    public Color update(Long id, Color entity) {
        findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "activate"})
    @Override @Transactional
    public Color activate(Long id) {
        Color existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "color", "operation", "deactivate"})
    @Override @Transactional
    public Color deactivate(Long id) {
        Color existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un color con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
