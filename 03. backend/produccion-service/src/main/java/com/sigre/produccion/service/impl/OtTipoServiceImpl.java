package com.sigre.produccion.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.produccion.entity.OtTipo;
import com.sigre.produccion.repository.OtTipoRepository;
import com.sigre.produccion.service.OtTipoService;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OtTipoServiceImpl implements OtTipoService {

    private final OtTipoRepository repository;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "findAll"})
    public Page<OtTipo> findAll(String codigo, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando tipos de OT - codigo: {}, nombre: {}, flagEstado: {}, page: {}, size: {}",
                codigo, nombre, flagEstado, pageable.getPageNumber(), pageable.getPageSize());
        Specification<OtTipo> spec = buildSpecification(codigo, nombre, flagEstado);
        Page<OtTipo> page = repository.findAll(spec, pageable);
        log.info("Tipos de OT encontrados: {}", page.getTotalElements());
        return page;
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "findById"})
    public OtTipo findById(Long id) {
        log.info("Buscando tipo de OT con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("OtTipo no encontrado con id: {}", id);
                    return new ResourceNotFoundException("OtTipo", id);
                });
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "create"})
    public OtTipo create(OtTipo entity) {
        log.info("Creando tipo de OT con codigo: {}", entity.getCodigo());
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), null);
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        OtTipo saved = repository.save(entity);
        log.info("OtTipo creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "update"})
    public OtTipo update(Long id, OtTipo entity) {
        log.info("Actualizando tipo de OT con id: {}", id);
        OtTipo existing = findById(id);
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        OtTipo updated = repository.save(existing);
        log.info("OtTipo actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "activate"})
    public OtTipo activate(Long id) {
        log.info("Activando tipo de OT con id: {}", id);
        OtTipo existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "deactivate"})
    public OtTipo deactivate(Long id) {
        log.info("Desactivando tipo de OT con id: {}", id);
        OtTipo existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ot_tipo", "operation", "delete"})
    public void delete(Long id) {
        log.info("Eliminando tipo de OT con id: {}", id);
        OtTipo existing = findById(id);
        if (repository.existsOrdenTrabajoByOtTipoId(id)) {
            log.warn("No se puede eliminar OtTipo id {}: tiene ordenes de trabajo asociadas", id);
            throw new BusinessException(
                    "No se puede eliminar el tipo de OT porque tiene ordenes de trabajo asociadas",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "PRD-OT-004");
        }
        // Baja logica: el contrato dice "Baja logica si no hay bloqueo por uso".
        existing.setFlagEstado("0");
        repository.save(existing);
        log.info("OtTipo desactivado (baja logica) exitosamente con id: {}", id);
    }

    private void normalizar(OtTipo entity) {
        if (entity.getCodigo() != null) {
            entity.setCodigo(entity.getCodigo().trim().toUpperCase());
        }
        if (entity.getNombre() != null) {
            entity.setNombre(entity.getNombre().trim());
        }
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de tipo de OT: {}", codigo);
            throw new BusinessException(
                    "Ya existe un tipo de OT con codigo " + codigo,
                    HttpStatus.CONFLICT,
                    "PRD-OT-003");
        }
    }

    private Specification<OtTipo> buildSpecification(String codigo, String nombre, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (codigo != null && !codigo.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("codigo")), "%" + codigo.trim().toUpperCase() + "%"));
            }
            if (nombre != null && !nombre.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("nombre")), "%" + nombre.trim().toUpperCase() + "%"));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
