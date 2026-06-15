package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.core.entity.TipoDocIdentidad;
import com.sigre.core.repository.TipoDocIdentidadRepository;
import com.sigre.core.service.TipoDocIdentidadService;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoDocIdentidadServiceImpl implements TipoDocIdentidadService {

    private final TipoDocIdentidadRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "findAll"})
    @Override
    public List<TipoDocIdentidad> findAll(String flagEstado) {
        log.info("Listando tipos documento identidad - flagEstado: {}", flagEstado);
        return Optional.ofNullable(flagEstado)
                .map(repository::findByFlagEstadoOrderByNombre)
                .orElseGet(repository::findAll);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "findById"})
    @Override
    public TipoDocIdentidad findById(Long id) {
        log.info("Buscando tipo documento identidad con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("TipoDocIdentidad no encontrado con id: {}", id);
                    return new ResourceNotFoundException("TipoDocIdentidad", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "create"})
    @Override @Transactional
    public TipoDocIdentidad create(TipoDocIdentidad entity) {
        log.info("Creando tipo documento identidad con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        TipoDocIdentidad saved = repository.save(entity);
        log.info("TipoDocIdentidad creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "update"})
    @Override @Transactional
    public TipoDocIdentidad update(Long id, TipoDocIdentidad entity) {
        log.info("Actualizando tipo documento identidad con id: {}", id);
        TipoDocIdentidad existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        TipoDocIdentidad updated = repository.save(existing);
        log.info("TipoDocIdentidad actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando tipo documento identidad con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("TipoDocIdentidad eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "activate"})
    @Override @Transactional
    public TipoDocIdentidad activate(Long id) {
        log.info("Activando tipo documento identidad con id: {}", id);
        TipoDocIdentidad existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_doc_identidad", "operation", "deactivate"})
    @Override @Transactional
    public TipoDocIdentidad deactivate(Long id) {
        log.info("Desactivando tipo documento identidad con id: {}", id);
        TipoDocIdentidad existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo tipo doc identidad: {} (existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe un tipo documento identidad con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
