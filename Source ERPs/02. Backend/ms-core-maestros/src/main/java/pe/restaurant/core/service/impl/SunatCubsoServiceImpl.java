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
import pe.restaurant.core.entity.SunatCubso;
import pe.restaurant.core.repository.SunatCubsoRepository;
import pe.restaurant.core.service.SunatCubsoService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SunatCubsoServiceImpl implements SunatCubsoService {

    private final SunatCubsoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "findAll"})
    @Override
    public Page<SunatCubso> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "findById"})
    @Override
    public SunatCubso findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SunatCubso", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "create"})
    @Override @Transactional
    public SunatCubso create(SunatCubso entity) {
        validateUniqueCodigo(entity.getCodCubso(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "update"})
    @Override @Transactional
    public SunatCubso update(Long id, SunatCubso entity) {
        findById(id);
        validateUniqueCodigo(entity.getCodCubso(), id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "activate"})
    @Override @Transactional
    public SunatCubso activate(Long id) {
        SunatCubso existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sunat_cubso", "operation", "deactivate"})
    @Override @Transactional
    public SunatCubso deactivate(Long id) {
        SunatCubso existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codCubso, Long excludeId) {
        repository.findByCodCubso(codCubso)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un CUBSO con codigo: " + codCubso, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
