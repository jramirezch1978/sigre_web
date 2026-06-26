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
import pe.restaurant.core.entity.SecuenciaDocumento;
import pe.restaurant.core.repository.SecuenciaDocumentoRepository;
import pe.restaurant.core.service.SecuenciaDocumentoService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SecuenciaDocumentoServiceImpl implements SecuenciaDocumentoService {

    private final SecuenciaDocumentoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "secuencia_documento", "operation", "findAll"})
    @Override
    public Page<SecuenciaDocumento> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "secuencia_documento", "operation", "findById"})
    @Override
    public SecuenciaDocumento findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SecuenciaDocumento", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "secuencia_documento", "operation", "create"})
    @Override @Transactional
    public SecuenciaDocumento create(SecuenciaDocumento entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "secuencia_documento", "operation", "update"})
    @Override @Transactional
    public SecuenciaDocumento update(Long id, SecuenciaDocumento entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "secuencia_documento", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }
}
