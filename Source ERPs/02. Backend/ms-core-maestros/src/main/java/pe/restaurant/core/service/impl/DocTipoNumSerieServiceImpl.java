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
import pe.restaurant.core.entity.DocTipoNumSerie;
import pe.restaurant.core.repository.DocTipoNumSerieRepository;
import pe.restaurant.core.service.DocTipoNumSerieService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DocTipoNumSerieServiceImpl implements DocTipoNumSerieService {

    private final DocTipoNumSerieRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "findAll"})
    @Override
    public Page<DocTipoNumSerie> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "findById"})
    @Override
    public DocTipoNumSerie findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("DocTipoNumSerie", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "create"})
    @Override @Transactional
    public DocTipoNumSerie create(DocTipoNumSerie entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "update"})
    @Override @Transactional
    public DocTipoNumSerie update(Long id, DocTipoNumSerie entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "activate"})
    @Override @Transactional
    public DocTipoNumSerie activate(Long id) {
        DocTipoNumSerie existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo_num_serie", "operation", "deactivate"})
    @Override @Transactional
    public DocTipoNumSerie deactivate(Long id) {
        DocTipoNumSerie existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
