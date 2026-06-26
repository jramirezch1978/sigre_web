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
import pe.restaurant.core.entity.NumeradorDocumento;
import pe.restaurant.core.repository.NumeradorDocumentoRepository;
import pe.restaurant.core.service.NumeradorDocumentoService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NumeradorDocumentoServiceImpl implements NumeradorDocumentoService {

    private final NumeradorDocumentoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "findAll"})
    @Override
    public Page<NumeradorDocumento> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "findById"})
    @Override
    public NumeradorDocumento findById(NumeradorDocumento.NumeradorDocumentoId id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("NumeradorDocumento", "clave",
                        id.getNombreTabla() + "/" + id.getSucursalId() + "/" + id.getAno()));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "create"})
    @Override @Transactional
    public NumeradorDocumento create(NumeradorDocumento entity) {
        NumeradorDocumento.NumeradorDocumentoId id = new NumeradorDocumento.NumeradorDocumentoId();
        id.setNombreTabla(entity.getNombreTabla());
        id.setSucursalId(entity.getSucursalId());
        id.setAno(entity.getAno());
        repository.findById(id).ifPresent(e -> {
            throw new BusinessException("Ya existe numerador_documento para esa clave", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        });
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "update"})
    @Override @Transactional
    public NumeradorDocumento update(NumeradorDocumento entity) {
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "delete"})
    @Override @Transactional
    public void delete(NumeradorDocumento.NumeradorDocumentoId id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "activate"})
    @Override @Transactional
    public NumeradorDocumento activate(NumeradorDocumento.NumeradorDocumentoId id) {
        NumeradorDocumento existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador_documento", "operation", "deactivate"})
    @Override @Transactional
    public NumeradorDocumento deactivate(NumeradorDocumento.NumeradorDocumentoId id) {
        NumeradorDocumento existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
