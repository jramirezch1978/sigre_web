package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.compras.entity.EntidadDetraccion;
import pe.restaurant.compras.repository.EntidadDetraccionRepository;
import pe.restaurant.compras.service.EntidadDetraccionService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EntidadDetraccionServiceImpl implements EntidadDetraccionService {

    private final EntidadDetraccionRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "findAll"})
    @Override
    public Page<EntidadDetraccion> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "findById"})
    @Override
    public EntidadDetraccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("EntidadDetraccion", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "create"})
    @Override @Transactional
    public EntidadDetraccion create(EntidadDetraccion entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "update"})
    @Override @Transactional
    public EntidadDetraccion update(Long id, EntidadDetraccion entity) {
        findById(id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "activate"})
    @Override @Transactional
    public EntidadDetraccion activate(Long id) {
        EntidadDetraccion existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_detraccion", "operation", "deactivate"})
    @Override @Transactional
    public EntidadDetraccion deactivate(Long id) {
        EntidadDetraccion existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }
}
