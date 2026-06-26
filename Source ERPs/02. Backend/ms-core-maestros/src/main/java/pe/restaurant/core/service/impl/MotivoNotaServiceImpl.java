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
import pe.restaurant.core.entity.MotivoNota;
import pe.restaurant.core.repository.MotivoNotaRepository;
import pe.restaurant.core.service.MotivoNotaService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MotivoNotaServiceImpl implements MotivoNotaService {

    private final MotivoNotaRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "findAll"})
    @Override
    public Page<MotivoNota> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "findById"})
    @Override
    public MotivoNota findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("MotivoNota", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "create"})
    @Override @Transactional
    public MotivoNota create(MotivoNota entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "update"})
    @Override @Transactional
    public MotivoNota update(Long id, MotivoNota entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "activate"})
    @Override @Transactional
    public MotivoNota activate(Long id) {
        MotivoNota existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_nota", "operation", "deactivate"})
    @Override @Transactional
    public MotivoNota deactivate(Long id) {
        MotivoNota existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
