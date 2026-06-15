package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.UnidadMedida;
import com.sigre.core.repository.UnidadMedidaRepository;
import com.sigre.common.security.TenantContext;
import java.time.Instant;
import com.sigre.core.service.UnidadMedidaService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UnidadMedidaServiceImpl implements UnidadMedidaService {

    private final UnidadMedidaRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "findAll"})
    @Override
    public Page<UnidadMedida> findAll(Pageable pageable) {
        log.info("Listando unidades de medida - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<UnidadMedida> page = repository.findAll(pageable);
        log.info("Unidades de medida encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "findById"})
    @Override
    public UnidadMedida findById(Long id) {
        log.info("Buscando unidad de medida con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("UnidadMedida no encontrada con id: {}", id);
                    return new ResourceNotFoundException("UnidadMedida", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "create"})
    @Override
    @Transactional
    public UnidadMedida create(UnidadMedida entity) {
        log.info("Creando unidad de medida con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        UnidadMedida saved = repository.save(entity);
        log.info("UnidadMedida creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "update"})
    @Override
    @Transactional
    public UnidadMedida update(Long id, UnidadMedida entity) {
        log.info("Actualizando unidad de medida con id: {}", id);
        UnidadMedida existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setAbreviatura(entity.getAbreviatura());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        UnidadMedida updated = repository.save(existing);
        log.info("UnidadMedida actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando unidad de medida con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("UnidadMedida eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "activate"})
    @Override
    @Transactional
    public UnidadMedida activate(Long id) {
        log.info("Activando unidad de medida con id: {}", id);
        UnidadMedida existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "unidad_medida", "operation", "deactivate"})
    @Override
    @Transactional
    public UnidadMedida deactivate(Long id) {
        log.info("Desactivando unidad de medida con id: {}", id);
        UnidadMedida existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de unidad de medida: {} (existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe una unidad de medida con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
