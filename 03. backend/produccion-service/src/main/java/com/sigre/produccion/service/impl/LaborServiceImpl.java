package com.sigre.produccion.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.dto.response.LaborEjecutorResponse;
import com.sigre.produccion.entity.Labor;
import com.sigre.produccion.entity.LaborEjecutor;
import com.sigre.produccion.entity.LaborInsumo;
import com.sigre.produccion.entity.LaborProduccion;
import com.sigre.produccion.mapper.LaborEjecutorMapper;
import com.sigre.produccion.repository.LaborEjecutorRepository;
import com.sigre.produccion.repository.LaborInsumoRepository;
import com.sigre.produccion.repository.LaborProduccionRepository;
import com.sigre.produccion.repository.LaborRepository;
import com.sigre.produccion.service.LaborService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LaborServiceImpl implements LaborService {

    private final LaborRepository laborRepository;
    private final LaborInsumoRepository insumoRepository;
    private final LaborProduccionRepository produccionRepository;
    private final LaborEjecutorRepository ejecutorRepository;
    private final LaborEjecutorMapper ejecutorMapper;
    private final CoreArticuloClient coreArticuloClient;
    @PersistenceContext
    private EntityManager entityManager;

    // ───────────────────────── CRUD labor ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "findAll"})
    public Page<Labor> findAll(String codigo, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando labores - codigo: {}, nombre: {}, flagEstado: {}", codigo, nombre, flagEstado);
        Specification<Labor> spec = buildSpecification(codigo, nombre, flagEstado);
        Page<Labor> page = laborRepository.findAll(spec, pageable);
        log.info("Labores encontradas: {}", page.getTotalElements());
        return page;
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "findById"})
    public Labor findById(Long id) {
        log.info("Buscando labor con id: {}", id);
        return laborRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Labor no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Labor", id);
                });
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "create"})
    public Labor create(Labor entity) {
        log.info("Creando labor con codigo: {}", entity.getCodigo());
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), null);
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        Labor saved = laborRepository.save(entity);
        log.info("Labor creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "update"})
    public Labor update(Long id, Labor entity) {
        log.info("Actualizando labor con id: {}", id);
        Labor existing = findById(id);
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        Labor updated = laborRepository.save(existing);
        log.info("Labor actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "activate"})
    public Labor activate(Long id) {
        log.info("Activando labor con id: {}", id);
        Labor existing = findById(id);
        existing.setFlagEstado("1");
        return laborRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "deactivate"})
    public Labor deactivate(Long id) {
        log.info("Desactivando labor con id: {}", id);
        Labor existing = findById(id);
        existing.setFlagEstado("0");
        return laborRepository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor", "operation", "delete"})
    public void delete(Long id) {
        log.info("Eliminando labor con id: {}", id);
        Labor existing = findById(id);
        if (laborRepository.existsReferenciaByLaborId(id)) {
            log.warn("No se puede eliminar Labor id {}: tiene referencias en recetas u operaciones", id);
            throw new BusinessException(
                    "No se puede eliminar la labor porque tiene referencias asociadas",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "PRD-LB-005");
        }
        // Baja logica.
        existing.setFlagEstado("0");
        laborRepository.save(existing);
        log.info("Labor desactivada (baja logica) con id: {}", id);
    }

    // ───────────────────────── Sub-recurso insumos ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "labor_insumo", "operation", "findByLabor"})
    public List<LaborInsumo> findInsumos(Long laborId) {
        log.info("Listando insumos de labor id: {}", laborId);
        findById(laborId); // valida existencia
        return insumoRepository.findByLaborIdOrderByIdAsc(laborId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_insumo", "operation", "asignar"})
    public LaborInsumo asignarInsumo(Long laborId, Long articuloId) {
        log.info("Asignando articulo {} como insumo a labor {}", articuloId, laborId);
        findById(laborId);
        validarArticuloExiste(articuloId);
        if (insumoRepository.existsByLaborIdAndArticuloId(laborId, articuloId)) {
            log.warn("Articulo {} ya esta asignado como insumo de labor {}", articuloId, laborId);
            throw new BusinessException(
                    "El articulo ya esta asignado como insumo de esta labor",
                    HttpStatus.CONFLICT,
                    "PRD-LB-003");
        }
        LaborInsumo insumo = new LaborInsumo();
        insumo.setLaborId(laborId);
        insumo.setArticuloId(articuloId);
        insumo.setCreatedBy(TenantContext.getUsuarioId());
        LaborInsumo saved = insumoRepository.save(insumo);
        log.info("LaborInsumo creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_insumo", "operation", "desasignar"})
    public void desasignarInsumo(Long laborId, Long articuloId) {
        log.info("Desasignando articulo {} como insumo de labor {}", articuloId, laborId);
        findById(laborId);
        LaborInsumo insumo = insumoRepository.findByLaborIdAndArticuloId(laborId, articuloId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "LaborInsumo (labor=" + laborId + ", articulo=" + articuloId + ")", null));
        insumoRepository.delete(insumo);
        log.info("LaborInsumo eliminado: labor={}, articulo={}", laborId, articuloId);
    }

    // ───────────────────────── Sub-recurso producidos ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "labor_produccion", "operation", "findByLabor"})
    public List<LaborProduccion> findProducidos(Long laborId) {
        log.info("Listando producidos de labor id: {}", laborId);
        findById(laborId);
        return produccionRepository.findByLaborIdOrderByIdAsc(laborId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_produccion", "operation", "asignar"})
    public LaborProduccion asignarProducido(Long laborId, Long articuloId) {
        log.info("Asignando articulo {} como producido a labor {}", articuloId, laborId);
        findById(laborId);
        validarArticuloExiste(articuloId);
        if (produccionRepository.existsByLaborIdAndArticuloId(laborId, articuloId)) {
            log.warn("Articulo {} ya esta asignado como producido de labor {}", articuloId, laborId);
            throw new BusinessException(
                    "El articulo ya esta asignado como producido de esta labor",
                    HttpStatus.CONFLICT,
                    "PRD-LB-003");
        }
        LaborProduccion prod = new LaborProduccion();
        prod.setLaborId(laborId);
        prod.setArticuloId(articuloId);
        prod.setCreatedBy(TenantContext.getUsuarioId());
        LaborProduccion saved = produccionRepository.save(prod);
        log.info("LaborProduccion creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_produccion", "operation", "desasignar"})
    public void desasignarProducido(Long laborId, Long articuloId) {
        log.info("Desasignando articulo {} como producido de labor {}", articuloId, laborId);
        findById(laborId);
        LaborProduccion prod = produccionRepository.findByLaborIdAndArticuloId(laborId, articuloId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "LaborProduccion (labor=" + laborId + ", articulo=" + articuloId + ")", null));
        produccionRepository.delete(prod);
        log.info("LaborProduccion eliminado: labor={}, articulo={}", laborId, articuloId);
    }

    // ───────────────────────── Sub-recurso ejecutores ─────────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "labor_ejecutor", "operation", "findByLabor"})
    public List<LaborEjecutor> findEjecutores(Long laborId) {
        log.info("Listando ejecutores de labor id: {}", laborId);
        findById(laborId);
        return ejecutorRepository.findByLaborIdOrderByIdAsc(laborId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_ejecutor", "operation", "asignar"})
    public LaborEjecutor asignarEjecutor(Long laborId, Long ejecutorId, LaborEjecutor data) {
        log.info("Asignando ejecutor {} a labor {}", ejecutorId, laborId);
        findById(laborId);
        if (ejecutorRepository.existsByLaborIdAndEjecutorId(laborId, ejecutorId)) {
            throw new BusinessException(
                    "Ya existe una asignación activa del ejecutor " + ejecutorId + " a la labor " + laborId,
                    HttpStatus.CONFLICT, "PRD-LE-003");
        }
        LaborEjecutor le = new LaborEjecutor();
        le.setLaborId(laborId);
        le.setEjecutorId(ejecutorId);
        le.setUnidadMedidaAltId(data.getUnidadMedidaAltId());
        le.setMonedaId(data.getMonedaId());
        le.setFactorConversion(data.getFactorConversion());
        le.setNroPersonas(data.getNroPersonas());
        le.setRatioEstimado(data.getRatioEstimado());
        le.setCostoUnitario(data.getCostoUnitario());
        le.setFlagCostoFijo(data.getFlagCostoFijo());
        le.setFlagEstado("1");
        le.setCreatedBy(TenantContext.getUsuarioId());
        LaborEjecutor saved = ejecutorRepository.save(le);
        log.info("LaborEjecutor creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_ejecutor", "operation", "actualizar"})
    public LaborEjecutor actualizarEjecutor(Long laborId, Long ejecutorId, LaborEjecutor data) {
        log.info("Actualizando ejecutor {} de labor {}", ejecutorId, laborId);
        findById(laborId);
        LaborEjecutor le = ejecutorRepository.findByLaborIdAndEjecutorId(laborId, ejecutorId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "LaborEjecutor (labor=" + laborId + ", ejecutor=" + ejecutorId + ")", null));
        le.setUnidadMedidaAltId(data.getUnidadMedidaAltId());
        le.setMonedaId(data.getMonedaId());
        le.setFactorConversion(data.getFactorConversion());
        le.setNroPersonas(data.getNroPersonas());
        le.setRatioEstimado(data.getRatioEstimado());
        le.setCostoUnitario(data.getCostoUnitario());
        le.setFlagCostoFijo(data.getFlagCostoFijo());
        le.setUpdatedBy(TenantContext.getUsuarioId());
        LaborEjecutor saved = ejecutorRepository.save(le);
        log.info("LaborEjecutor actualizado: labor={}, ejecutor={}", laborId, ejecutorId);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "labor_ejecutor", "operation", "desasignar"})
    public void desasignarEjecutor(Long laborId, Long ejecutorId) {
        log.info("Desasignando ejecutor {} de labor {}", ejecutorId, laborId);
        findById(laborId);
        LaborEjecutor le = ejecutorRepository.findByLaborIdAndEjecutorId(laborId, ejecutorId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "LaborEjecutor (labor=" + laborId + ", ejecutor=" + ejecutorId + ")", null));
        ejecutorRepository.delete(le);
        log.info("LaborEjecutor eliminado: labor={}, ejecutor={}", laborId, ejecutorId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public void enrichEjecutores(List<LaborEjecutorResponse> responses) {
        if (responses == null || responses.isEmpty()) return;

        Set<Long> laborIds = responses.stream()
                .map(LaborEjecutorResponse::getLaborId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!laborIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM produccion.labor WHERE id IN (:ids)")
                        .setParameter("ids", laborIds)
                        .getResultList();
                Map<Long, String> labores = new HashMap<>();
                for (Object[] row : rows) {
                    labores.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (LaborEjecutorResponse r : responses) {
                    r.setLaborNombre(labores.get(r.getLaborId()));
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer laborNombre: {}", e.getMessage());
            }
        }

        Set<Long> ejecutorIds = responses.stream()
                .map(LaborEjecutorResponse::getEjecutorId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!ejecutorIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM produccion.ejecutor WHERE id IN (:ids)")
                        .setParameter("ids", ejecutorIds)
                        .getResultList();
                Map<Long, String> ejecutores = new HashMap<>();
                for (Object[] row : rows) {
                    ejecutores.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (LaborEjecutorResponse r : responses) {
                    r.setEjecutorNombre(ejecutores.get(r.getEjecutorId()));
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer ejecutorNombre: {}", e.getMessage());
            }
        }

        Set<Long> umIds = responses.stream()
                .map(LaborEjecutorResponse::getUnidadMedidaAltId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!umIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM core.unidad_medida WHERE id IN (:ids)")
                        .setParameter("ids", umIds)
                        .getResultList();
                Map<Long, String> ums = new HashMap<>();
                for (Object[] row : rows) {
                    ums.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (LaborEjecutorResponse r : responses) {
                    if (r.getUnidadMedidaAltId() != null) {
                        r.setUnidadMedidaAltNombre(ums.get(r.getUnidadMedidaAltId()));
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer unidadMedidaAltNombre: {}", e.getMessage());
            }
        }

        Set<Long> monedaIds = responses.stream()
                .map(LaborEjecutorResponse::getMonedaId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!monedaIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM core.moneda WHERE id IN (:ids)")
                        .setParameter("ids", monedaIds)
                        .getResultList();
                Map<Long, String> monedas = new HashMap<>();
                for (Object[] row : rows) {
                    monedas.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (LaborEjecutorResponse r : responses) {
                    if (r.getMonedaId() != null) {
                        r.setMonedaNombre(monedas.get(r.getMonedaId()));
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer monedaNombre: {}", e.getMessage());
            }
        }
    }

    // ───────────────────────── helpers ─────────────────────────

    private void normalizar(Labor entity) {
        if (entity.getCodigo() != null) {
            entity.setCodigo(entity.getCodigo().trim().toUpperCase());
        }
        if (entity.getNombre() != null) {
            entity.setNombre(entity.getNombre().trim());
        }
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? laborRepository.existsByCodigoIgnoreCase(codigo)
                : laborRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de labor: {}", codigo);
            throw new BusinessException(
                    "Ya existe una labor activa con codigo " + codigo,
                    HttpStatus.CONFLICT,
                    "PRD-LB-003");
        }
    }

    private void validarArticuloExiste(Long articuloId) {
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null) {
                log.warn("Articulo inexistente al asignar a labor: id={}", articuloId);
                throw new BusinessException("El articulo especificado no existe",
                        HttpStatus.UNPROCESSABLE_ENTITY, "PRD-LB-002");
            }
        } catch (FeignException e) {
            log.warn("Articulo inexistente al asignar a labor: id={}", articuloId);
            throw new BusinessException("El articulo especificado no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, "PRD-LB-002");
        }
    }

    private Specification<Labor> buildSpecification(String codigo, String nombre, String flagEstado) {
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
