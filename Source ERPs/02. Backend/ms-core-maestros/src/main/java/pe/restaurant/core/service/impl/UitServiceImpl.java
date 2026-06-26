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
import pe.restaurant.core.entity.Uit;
import pe.restaurant.core.repository.UitRepository;
import pe.restaurant.core.service.UitService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UitServiceImpl implements UitService {

    private final UitRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "findAll"})
    @Override
    public Page<Uit> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "findById"})
    @Override
    public Uit findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Uit", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "create"})
    @Override @Transactional
    public Uit create(Uit entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "update"})
    @Override @Transactional
    public Uit update(Long id, Uit entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "activate"})
    @Override @Transactional
    public Uit activate(Long id) {
        Uit existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "uit", "operation", "deactivate"})
    @Override @Transactional
    public Uit deactivate(Long id) {
        Uit existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
