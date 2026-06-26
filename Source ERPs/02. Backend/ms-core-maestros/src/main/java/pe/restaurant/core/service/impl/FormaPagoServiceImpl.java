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
import pe.restaurant.core.entity.FormaPago;
import java.time.Instant;
import pe.restaurant.core.repository.FormaPagoRepository;
import pe.restaurant.core.service.FormaPagoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FormaPagoServiceImpl implements FormaPagoService {

    private final FormaPagoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "findAll"})
    @Override
    public Page<FormaPago> findAll(Pageable pageable) {
        log.info("Listando formas de pago - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<FormaPago> page = repository.findAll(pageable);
        log.info("Formas de pago encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "findById"})
    @Override
    public FormaPago findById(Long id) {
        log.info("Buscando forma de pago con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("FormaPago no encontrada con id: {}", id);
                    return new ResourceNotFoundException("FormaPago", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "create"})
    @Override @Transactional
    public FormaPago create(FormaPago entity) {
        log.info("Creando forma de pago con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        FormaPago saved = repository.save(entity);
        log.info("FormaPago creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "update"})
    @Override @Transactional
    public FormaPago update(Long id, FormaPago entity) {
        log.info("Actualizando forma de pago con id: {}", id);
        FormaPago existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setTipo(entity.getTipo());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        FormaPago updated = repository.save(existing);
        log.info("FormaPago actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando forma de pago con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("FormaPago eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "activate"})
    @Override @Transactional
    public FormaPago activate(Long id) {
        log.info("Activando forma de pago con id: {}", id);
        FormaPago existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "forma_pago", "operation", "deactivate"})
    @Override @Transactional
    public FormaPago deactivate(Long id) {
        log.info("Desactivando forma de pago con id: {}", id);
        FormaPago existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de forma de pago: {} (existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe una forma de pago con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
