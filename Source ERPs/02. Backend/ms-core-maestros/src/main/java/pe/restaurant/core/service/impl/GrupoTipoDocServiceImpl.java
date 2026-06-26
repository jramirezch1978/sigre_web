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
import pe.restaurant.core.entity.GrupoTipoDoc;
import pe.restaurant.core.repository.GrupoTipoDocRepository;
import pe.restaurant.core.service.GrupoTipoDocService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GrupoTipoDocServiceImpl implements GrupoTipoDocService {

    private final GrupoTipoDocRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "findAll"})
    @Override
    public Page<GrupoTipoDoc> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "findById"})
    @Override
    public GrupoTipoDoc findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("GrupoTipoDoc", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "create"})
    @Override @Transactional
    public GrupoTipoDoc create(GrupoTipoDoc entity) {
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "update"})
    @Override @Transactional
    public GrupoTipoDoc update(Long id, GrupoTipoDoc entity) {
        findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "activate"})
    @Override @Transactional
    public GrupoTipoDoc activate(Long id) {
        GrupoTipoDoc existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "grupo_tipo_doc", "operation", "deactivate"})
    @Override @Transactional
    public GrupoTipoDoc deactivate(Long id) {
        GrupoTipoDoc existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un grupo de tipo de documento con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
