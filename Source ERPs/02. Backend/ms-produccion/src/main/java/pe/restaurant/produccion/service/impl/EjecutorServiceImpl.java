package pe.restaurant.produccion.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.dto.response.EjecutorResponse;
import pe.restaurant.produccion.entity.Ejecutor;
import pe.restaurant.produccion.repository.EjecutorRepository;
import pe.restaurant.produccion.service.EjecutorService;
import pe.restaurant.produccion.service.ProduccionErrorCodes;

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
public class EjecutorServiceImpl implements EjecutorService {

    private final EjecutorRepository repository;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "findAll"})
    public Page<Ejecutor> findAll(String codigo, String nombre, String flagEstado, String flagExterno, Pageable pageable) {
        Specification<Ejecutor> spec = buildSpecification(codigo, nombre, flagEstado, flagExterno);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "findById"})
    public Ejecutor findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ejecutor", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "create"})
    public Ejecutor create(Ejecutor entity) {
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), null);
        validarCentrosCosto(entity.getCentrosCostoId());
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        if (entity.getFlagExterno() == null || entity.getFlagExterno().isBlank()) {
            entity.setFlagExterno("0");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "update"})
    public Ejecutor update(Long id, Ejecutor entity) {
        Ejecutor existing = findById(id);
        normalizar(entity);
        validateUniqueCodigo(entity.getCodigo(), id);
        validarCentrosCosto(entity.getCentrosCostoId());

        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setCentrosCostoId(entity.getCentrosCostoId());
        existing.setFlagExterno(entity.getFlagExterno());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "activate"})
    public Ejecutor activate(Long id) {
        Ejecutor existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "deactivate"})
    public Ejecutor deactivate(Long id) {
        Ejecutor existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "ejecutor", "operation", "delete"})
    public void delete(Long id) {
        Ejecutor existing = findById(id);
        if (entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.labor_ejecutor WHERE ejecutor_id = :id")
                .setParameter("id", id)
                .getSingleResult() instanceof Number count && count.intValue() > 0) {
            throw new BusinessException(
                    "No se puede eliminar el ejecutor porque tiene referencias asociadas en labor_ejecutor",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.EJECUTOR_REFERENCIAS_ASOCIADAS);
        }
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(existing);
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    @SuppressWarnings("unchecked")
    public void enrich(List<EjecutorResponse> responses) {
        if (responses == null || responses.isEmpty()) return;

        Set<Long> ccIds = responses.stream()
                .map(EjecutorResponse::getCentrosCostoId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!ccIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM contabilidad.centros_costo WHERE id IN (:ids)")
                        .setParameter("ids", ccIds)
                        .getResultList();
                Map<Long, String> nombres = new HashMap<>();
                for (Object[] row : rows) {
                    nombres.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (EjecutorResponse r : responses) {
                    if (r.getCentrosCostoId() != null) {
                        r.setCentrosCostoNombre(nombres.get(r.getCentrosCostoId()));
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer centrosCostoNombre: {}", e.getMessage());
            }
        }
    }

    // ───────────────────────── helpers ─────────────────────────

    private void normalizar(Ejecutor entity) {
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
            throw new BusinessException(
                    "Ya existe un ejecutor con código " + codigo,
                    HttpStatus.CONFLICT, ProduccionErrorCodes.EJECUTOR_CODIGO_DUPLICADO);
        }
    }

    private void validarCentrosCosto(Long centrosCostoId) {
        if (centrosCostoId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM contabilidad.centros_costo WHERE id = :id")
                .setParameter("id", centrosCostoId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("El centro de costo especificado no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.EJECUTOR_FK_INEXISTENTE);
        }
    }

    private Specification<Ejecutor> buildSpecification(String codigo, String nombre,
                                                        String flagEstado, String flagExterno) {
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
            if (flagExterno != null && !flagExterno.isBlank()) {
                predicates.add(cb.equal(root.get("flagExterno"), flagExterno));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
