package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.EntidadDireccion;
import pe.restaurant.core.repository.EntidadDireccionRepository;
import pe.restaurant.core.service.EntidadDireccionService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EntidadDireccionServiceImpl implements EntidadDireccionService {

    private final EntidadDireccionRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "findAll"})
    @Override
    public Page<EntidadDireccion> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "findById"})
    @Override
    public EntidadDireccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("EntidadDireccion", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "create"})
    @Override @Transactional
    public EntidadDireccion create(EntidadDireccion entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "update"})
    @Override @Transactional
    public EntidadDireccion update(Long id, EntidadDireccion entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "activate"})
    @Override @Transactional
    public EntidadDireccion activate(Long id) {
        EntidadDireccion existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_direccion", "operation", "deactivate"})
    @Override @Transactional
    public EntidadDireccion deactivate(Long id) {
        EntidadDireccion existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
