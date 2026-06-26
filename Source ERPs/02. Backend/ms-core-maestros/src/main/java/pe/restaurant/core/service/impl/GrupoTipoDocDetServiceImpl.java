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
import pe.restaurant.core.entity.GrupoTipoDocDet;
import pe.restaurant.core.repository.GrupoTipoDocDetRepository;
import pe.restaurant.core.service.GrupoTipoDocDetService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GrupoTipoDocDetServiceImpl implements GrupoTipoDocDetService {

    private final GrupoTipoDocDetRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "findAll"})
    @Override
    public Page<GrupoTipoDocDet> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "findById"})
    @Override
    public GrupoTipoDocDet findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("GrupoTipoDocDet", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "create"})
    @Override @Transactional
    public GrupoTipoDocDet create(GrupoTipoDocDet entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "update"})
    @Override @Transactional
    public GrupoTipoDocDet update(Long id, GrupoTipoDocDet entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "activate"})
    @Override @Transactional
    public GrupoTipoDocDet activate(Long id) {
        GrupoTipoDocDet existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc_det", "operation", "deactivate"})
    @Override @Transactional
    public GrupoTipoDocDet deactivate(Long id) {
        GrupoTipoDocDet existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
