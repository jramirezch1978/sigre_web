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
import pe.restaurant.core.entity.DocTipoNum;
import pe.restaurant.core.repository.DocTipoNumRepository;
import pe.restaurant.core.service.DocTipoNumService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DocTipoNumServiceImpl implements DocTipoNumService {

    private final DocTipoNumRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "findAll"})
    @Override
    public Page<DocTipoNum> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "findById"})
    @Override
    public DocTipoNum findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("DocTipoNum", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "create"})
    @Override @Transactional
    public DocTipoNum create(DocTipoNum entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "update"})
    @Override @Transactional
    public DocTipoNum update(Long id, DocTipoNum entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "activate"})
    @Override @Transactional
    public DocTipoNum activate(Long id) {
        DocTipoNum existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num", "operation", "deactivate"})
    @Override @Transactional
    public DocTipoNum deactivate(Long id) {
        DocTipoNum existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
