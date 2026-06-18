package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.ParametroSistema;
import java.time.Instant;
import pe.restaurant.core.repository.ParametroSistemaRepository;
import pe.restaurant.core.service.ParametroSistemaService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ParametroSistemaServiceImpl implements ParametroSistemaService {

    private final ParametroSistemaRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "findAll"})
    @Override
    public Page<ParametroSistema> findAll(String codigo, String modulo, Pageable pageable) {
        log.info("Listando parametros del sistema - codigo: {}, modulo: {}, page: {}, size: {}",
                codigo, modulo, pageable.getPageNumber(), pageable.getPageSize());
        Specification<ParametroSistema> spec = Specification.where(null);
        if (codigo != null && !codigo.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%"));
        }
        if (modulo != null && !modulo.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(cb.lower(root.get("modulo")), modulo.toLowerCase()));
        }
        Page<ParametroSistema> page = repository.findAll(spec, pageable);
        log.info("Parametros del sistema encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "findById"})
    @Override
    public ParametroSistema findById(Long id) {
        log.info("Buscando parametro del sistema con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("ParametroSistema no encontrado con id: {}", id);
                    return new ResourceNotFoundException("ParametroSistema", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "create"})
    @Override @Transactional
    public ParametroSistema create(ParametroSistema entity) {
        log.info("Creando parametro del sistema con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        ParametroSistema saved = repository.save(entity);
        log.info("ParametroSistema creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "update"})
    @Override @Transactional
    public ParametroSistema update(Long id, ParametroSistema entity) {
        log.info("Actualizando parametro del sistema con id: {}", id);
        ParametroSistema existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setModulo(entity.getModulo());
        existing.setValor(entity.getValor());
        existing.setTipoDato(entity.getTipoDato());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        ParametroSistema updated = repository.save(existing);
        log.info("ParametroSistema actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando parametro del sistema con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("ParametroSistema eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "activate"})
    @Override @Transactional
    public ParametroSistema activate(Long id) {
        log.info("Activando parametro del sistema con id: {}", id);
        ParametroSistema existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "deactivate"})
    @Override @Transactional
    public ParametroSistema deactivate(Long id) {
        log.info("Desactivando parametro del sistema con id: {}", id);
        ParametroSistema existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "parametro_sistema", "operation", "updateBatch"})
    @Override @Transactional
    public java.util.List<ParametroSistema> updateBatch(java.util.List<ParametroSistema> entities) {
        log.info("Actualización masiva de parametros del sistema - cantidad: {}", entities.size());
        java.util.List<ParametroSistema> results = new java.util.ArrayList<>();
        for (ParametroSistema entity : entities) {
            results.add(update(entity.getId(), entity));
        }
        log.info("Actualización masiva completada - {} parametros actualizados", results.size());
        return results;
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de parametro: {} (parametro existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe un parametro con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
