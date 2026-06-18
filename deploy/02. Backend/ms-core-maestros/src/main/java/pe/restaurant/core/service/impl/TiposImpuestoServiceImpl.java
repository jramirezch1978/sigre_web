package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.TiposImpuesto;
import pe.restaurant.core.repository.TiposImpuestoRepository;
import pe.restaurant.core.service.TiposImpuestoService;

import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TiposImpuestoServiceImpl implements TiposImpuestoService {

    static final String SQL_PLAN_CONTABLE_DET_FLAG =
            "SELECT flag_estado FROM contabilidad.plan_contable_det WHERE id = ?";

    private final TiposImpuestoRepository repository;
    private final JdbcTemplate jdbcTemplate;

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "findAll"})
    @Override
    public List<TiposImpuesto> findAll() {
        log.info("Listando todos los tipos de impuesto");
        List<TiposImpuesto> result = repository.findAll();
        log.info("Tipos de impuesto encontrados: {}", result.size());
        return result;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "findById"})
    @Override
    public TiposImpuesto findById(Long id) {
        log.info("Buscando tipo de impuesto con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("TiposImpuesto no encontrado con id: {}", id);
                    return new ResourceNotFoundException("TiposImpuesto", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "findByTipoImpuesto"})
    @Override
    public TiposImpuesto findByTipoImpuesto(String tipoImpuesto) {
        log.info("Buscando tipo de impuesto: {}", tipoImpuesto);
        return repository.findByTipoImpuesto(tipoImpuesto)
                .orElseThrow(() -> {
                    log.warn("TiposImpuesto no encontrado: {}", tipoImpuesto);
                    return new ResourceNotFoundException("TiposImpuesto", "tipo_impuesto", tipoImpuesto);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "create"})
    @Override
    @Transactional
    public TiposImpuesto create(TiposImpuesto entity) {
        log.info("Creando tipo de impuesto: {}", entity.getTipoImpuesto());
        validarPlanContableDetFk(entity.getPlanContableDetId());
        if (entity.getTipoCalculo() == null) {
            entity.setTipoCalculo(1);
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        TiposImpuesto saved = repository.save(entity);
        log.info("TiposImpuesto creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "update"})
    @Override
    @Transactional
    public TiposImpuesto update(Long id, TiposImpuesto entity) {
        log.info("Actualizando tipo de impuesto con id: {}", id);
        validarPlanContableDetFk(entity.getPlanContableDetId());
        TiposImpuesto existing = findById(id);
        existing.setTipoImpuesto(entity.getTipoImpuesto());
        existing.setPlanContableDetId(entity.getPlanContableDetId());
        existing.setDescImpuesto(entity.getDescImpuesto());
        existing.setTasaImpuesto(entity.getTasaImpuesto());
        existing.setSigno(entity.getSigno());
        existing.setFlagDhCxp(entity.getFlagDhCxp());
        existing.setFlagIgv(entity.getFlagIgv());
        existing.setTipoCalculo(entity.getTipoCalculo() != null ? entity.getTipoCalculo() : 1);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        TiposImpuesto updated = repository.save(existing);
        log.info("TiposImpuesto actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando tipo de impuesto con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("TiposImpuesto eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "activate"})
    @Override
    @Transactional
    public TiposImpuesto activate(Long id) {
        log.info("Activando tipo de impuesto con id: {}", id);
        TiposImpuesto existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipos_impuesto", "operation", "deactivate"})
    @Override
    @Transactional
    public TiposImpuesto deactivate(Long id) {
        log.info("Desactivando tipo de impuesto con id: {}", id);
        TiposImpuesto existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    /**
     * FK core.tipos_impuesto.plan_contable_det_id → contabilidad.plan_contable_det:
     * debe existir y estar activo (flag_estado = '1').
     */
    private void validarPlanContableDetFk(Long planContableDetId) {
        if (planContableDetId == null) {
            return;
        }
        List<String> flags = jdbcTemplate.query(
                SQL_PLAN_CONTABLE_DET_FLAG,
                (rs, rowNum) -> rs.getString("flag_estado"),
                planContableDetId);
        if (flags.isEmpty()) {
            throw new BusinessException(
                    "No existe la cuenta contable (plan contable detalle) con id: " + planContableDetId,
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "VALIDATION_ERROR");
        }
        if (!"1".equals(flags.get(0))) {
            throw new BusinessException(
                    "La cuenta contable (plan contable detalle) no está activa: " + planContableDetId,
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "VALIDATION_ERROR");
        }
    }
}
