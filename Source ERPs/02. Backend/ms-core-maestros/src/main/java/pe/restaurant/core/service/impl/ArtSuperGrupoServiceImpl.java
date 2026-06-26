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
import pe.restaurant.core.entity.ArtSuperGrupo;
import pe.restaurant.core.repository.ArtSuperGrupoRepository;
import pe.restaurant.core.service.ArtSuperGrupoService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArtSuperGrupoServiceImpl implements ArtSuperGrupoService {

    private final ArtSuperGrupoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "findAll"})
    @Override
    public Page<ArtSuperGrupo> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "findById"})
    @Override
    public ArtSuperGrupo findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ArtSuperGrupo", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "create"})
    @Override @Transactional
    public ArtSuperGrupo create(ArtSuperGrupo entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "update"})
    @Override @Transactional
    public ArtSuperGrupo update(Long id, ArtSuperGrupo entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "activate"})
    @Override @Transactional
    public ArtSuperGrupo activate(Long id) {
        ArtSuperGrupo existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "art_super_grupo", "operation", "deactivate"})
    @Override @Transactional
    public ArtSuperGrupo deactivate(Long id) {
        ArtSuperGrupo existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
