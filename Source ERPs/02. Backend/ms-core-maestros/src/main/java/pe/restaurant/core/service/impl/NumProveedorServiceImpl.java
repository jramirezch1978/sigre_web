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
import pe.restaurant.core.entity.NumProveedor;
import pe.restaurant.core.repository.NumProveedorRepository;
import pe.restaurant.core.service.NumProveedorService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NumProveedorServiceImpl implements NumProveedorService {

    private final NumProveedorRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "num_proveedor", "operation", "findAll"})
    @Override
    public Page<NumProveedor> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_proveedor", "operation", "findById"})
    @Override
    public NumProveedor findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("NumProveedor", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_proveedor", "operation", "create"})
    @Override @Transactional
    public NumProveedor create(NumProveedor entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_proveedor", "operation", "update"})
    @Override @Transactional
    public NumProveedor update(Long id, NumProveedor entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_proveedor", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }
}
