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
import pe.restaurant.core.entity.NaturalezaContable;
import pe.restaurant.core.repository.NaturalezaContableRepository;
import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import pe.restaurant.core.service.NaturalezaContableService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NaturalezaContableServiceImpl implements NaturalezaContableService {

    private final NaturalezaContableRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "findAll"})
    @Override
    public Page<NaturalezaContable> findAll(Pageable pageable) {
        log.info("Listando naturalezas contables - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<NaturalezaContable> page = repository.findAll(pageable);
        log.info("Naturalezas contables encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "findById"})
    @Override
    public NaturalezaContable findById(Long id) {
        log.info("Buscando naturaleza contable con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("NaturalezaContable no encontrada con id: {}", id);
                    return new ResourceNotFoundException("NaturalezaContable", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "create"})
    @Override
    @Transactional
    public NaturalezaContable create(NaturalezaContable entity) {
        log.info("Creando naturaleza contable con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        NaturalezaContable saved = repository.save(entity);
        log.info("NaturalezaContable creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "update"})
    @Override
    @Transactional
    public NaturalezaContable update(Long id, NaturalezaContable entity) {
        log.info("Actualizando naturaleza contable con id: {}", id);
        NaturalezaContable existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setCuentaContable(entity.getCuentaContable());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        NaturalezaContable updated = repository.save(existing);
        log.info("NaturalezaContable actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando naturaleza contable con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("NaturalezaContable eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "activate"})
    @Override
    @Transactional
    public NaturalezaContable activate(Long id) {
        log.info("Activando naturaleza contable con id: {}", id);
        NaturalezaContable existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "naturaleza_contable", "operation", "deactivate"})
    @Override
    @Transactional
    public NaturalezaContable deactivate(Long id) {
        log.info("Desactivando naturaleza contable con id: {}", id);
        NaturalezaContable existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de naturaleza contable: {} (existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe una naturaleza contable con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
