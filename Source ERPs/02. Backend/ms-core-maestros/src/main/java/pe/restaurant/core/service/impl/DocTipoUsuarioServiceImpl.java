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
import pe.restaurant.core.entity.DocTipoUsuario;
import pe.restaurant.core.repository.DocTipoUsuarioRepository;
import pe.restaurant.core.service.DocTipoUsuarioService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DocTipoUsuarioServiceImpl implements DocTipoUsuarioService {

    private final DocTipoUsuarioRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "findAll"})
    @Override
    public Page<DocTipoUsuario> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "findById"})
    @Override
    public DocTipoUsuario findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("DocTipoUsuario", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "create"})
    @Override @Transactional
    public DocTipoUsuario create(DocTipoUsuario entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "update"})
    @Override @Transactional
    public DocTipoUsuario update(Long id, DocTipoUsuario entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "activate"})
    @Override @Transactional
    public DocTipoUsuario activate(Long id) {
        DocTipoUsuario existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_usuario", "operation", "deactivate"})
    @Override @Transactional
    public DocTipoUsuario deactivate(Long id) {
        DocTipoUsuario existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
