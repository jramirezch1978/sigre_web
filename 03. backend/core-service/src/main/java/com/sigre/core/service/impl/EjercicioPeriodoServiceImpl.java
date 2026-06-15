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
import com.sigre.core.entity.EjercicioPeriodo;
import com.sigre.core.repository.EjercicioPeriodoRepository;
import com.sigre.common.security.TenantContext;
import java.time.Instant;
import com.sigre.core.service.EjercicioPeriodoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EjercicioPeriodoServiceImpl implements EjercicioPeriodoService {

    private final EjercicioPeriodoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "findAll"})
    @Override
    public Page<EjercicioPeriodo> findAll(Integer anio, Pageable pageable) {
        log.info("Listando ejercicios/periodos - anio: {}, page: {}, size: {}",
                anio, pageable.getPageNumber(), pageable.getPageSize());
        Page<EjercicioPeriodo> page;
        if (anio != null) {
            page = repository.findByAnio(anio, pageable);
        } else {
            page = repository.findAll(pageable);
        }
        log.info("Ejercicios/periodos encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "findById"})
    @Override
    public EjercicioPeriodo findById(Long id) {
        log.info("Buscando ejercicio/periodo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("EjercicioPeriodo no encontrado con id: {}", id);
                    return new ResourceNotFoundException("EjercicioPeriodo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "create"})
    @Override @Transactional
    public EjercicioPeriodo create(EjercicioPeriodo entity) {
        log.info("Creando ejercicio/periodo - anio: {}", entity.getAnio());
        validateUniqueAnio(entity.getAnio(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        EjercicioPeriodo saved = repository.save(entity);
        log.info("EjercicioPeriodo creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "update"})
    @Override @Transactional
    public EjercicioPeriodo update(Long id, EjercicioPeriodo entity) {
        log.info("Actualizando ejercicio/periodo con id: {}", id);
        EjercicioPeriodo existing = findById(id);
        validateUniqueAnio(entity.getAnio(), id);
        existing.setAnio(entity.getAnio());
        existing.setFechaInicio(entity.getFechaInicio());
        existing.setFechaFin(entity.getFechaFin());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        EjercicioPeriodo updated = repository.save(existing);
        log.info("EjercicioPeriodo actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando ejercicio/periodo con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("EjercicioPeriodo eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "activate"})
    @Override @Transactional
    public EjercicioPeriodo activate(Long id) {
        log.info("Activando ejercicio/periodo con id: {}", id);
        EjercicioPeriodo existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ejercicio_periodo", "operation", "deactivate"})
    @Override @Transactional
    public EjercicioPeriodo deactivate(Long id) {
        log.info("Cerrando ejercicio/periodo con id: {}", id);
        EjercicioPeriodo existing = findById(id);
        existing.setFlagEstado("2");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueAnio(Integer anio, Long excludeId) {
        repository.findByAnio(anio).ifPresent(existing -> {
            if (excludeId == null || !existing.getId().equals(excludeId)) {
                log.warn("Intento de duplicar ejercicio/periodo - anio: {}", anio);
                throw new BusinessException("Ya existe un ejercicio para el anio indicado", HttpStatus.CONFLICT, "BUSINESS_ERROR");
            }
        });
    }
}
