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
import pe.restaurant.compras.entity.EntidadArticulo;
import pe.restaurant.compras.repository.EntidadArticuloRepository;
import pe.restaurant.compras.service.EntidadArticuloService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EntidadArticuloServiceImpl implements EntidadArticuloService {

    private final EntidadArticuloRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "findAll"})
    @Override
    public Page<EntidadArticulo> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "findById"})
    @Override
    public EntidadArticulo findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("EntidadArticulo", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "create"})
    @Override @Transactional
    public EntidadArticulo create(EntidadArticulo entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "update"})
    @Override @Transactional
    public EntidadArticulo update(Long id, EntidadArticulo entity) {
        findById(id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "activate"})
    @Override @Transactional
    public EntidadArticulo activate(Long id) {
        EntidadArticulo existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "entidad_articulo", "operation", "deactivate"})
    @Override @Transactional
    public EntidadArticulo deactivate(Long id) {
        EntidadArticulo existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }
}
