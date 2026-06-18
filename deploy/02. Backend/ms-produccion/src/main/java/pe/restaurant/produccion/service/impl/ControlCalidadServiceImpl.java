package pe.restaurant.produccion.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.client.AuthUsuarioClient;
import pe.restaurant.produccion.entity.ControlCalidad;
import pe.restaurant.produccion.dto.response.ControlCalidadResponse;
import pe.restaurant.produccion.repository.ControlCalidadRepository;
import pe.restaurant.produccion.service.ControlCalidadService;
import pe.restaurant.produccion.service.ProduccionErrorCodes;

import java.time.LocalDate;
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
public class ControlCalidadServiceImpl implements ControlCalidadService {

    private static final Set<String> RESULTADOS_VALIDOS = Set.of("APROBADO", "RECHAZADO", "OBSERVADO");

    private final ControlCalidadRepository repository;
    private final AuthUsuarioClient authUsuarioClient;
    @PersistenceContext
    private EntityManager entityManager;
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ControlCalidadServiceImpl.class);

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "control_calidad", "operation", "findAll"})
    public Page<ControlCalidad> findAll(Long ordenTrabajoId, String resultado, LocalDate fechaDesde,
                                        LocalDate fechaHasta, Long inspectorId, Pageable pageable) {
        Specification<ControlCalidad> spec = buildSpecification(ordenTrabajoId, resultado, fechaDesde, fechaHasta, inspectorId);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "control_calidad", "operation", "findById"})
    public ControlCalidad findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException("Control de calidad no encontrado",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.CONTROL_CALIDAD_NO_ENCONTRADO));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "control_calidad", "operation", "create"})
    public ControlCalidad create(ControlCalidad entity) {
        validarDatosObligatorios(entity);
        validarFKs(entity);
        validarResultado(entity.getResultado());

        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "control_calidad", "operation", "update"})
    public ControlCalidad update(Long id, ControlCalidad entity) {
        ControlCalidad existing = findById(id);
        validarDatosObligatorios(entity);
        validarFKs(entity);
        validarResultado(entity.getResultado());

        existing.setOrdenTrabajoId(entity.getOrdenTrabajoId());
        existing.setInspectorId(entity.getInspectorId());
        existing.setFecha(entity.getFecha());
        existing.setResultado(entity.getResultado());
        existing.setObservaciones(entity.getObservaciones());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "control_calidad", "operation", "delete"})
    public void delete(Long id) {
        ControlCalidad existing = findById(id);
        repository.delete(existing);
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    @SuppressWarnings("unchecked")
    public void enrich(List<ControlCalidadResponse> responses) {
        if (responses == null || responses.isEmpty()) return;

        Set<Long> otIds = responses.stream()
                .map(ControlCalidadResponse::getOrdenTrabajoId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!otIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, codigo FROM produccion.orden_trabajo WHERE id IN (:ids)")
                        .setParameter("ids", otIds)
                        .getResultList();
                Map<Long, String> codigos = new HashMap<>();
                for (Object[] row : rows) {
                    codigos.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (ControlCalidadResponse r : responses) {
                    if (r.getOrdenTrabajoId() != null) {
                        r.setOrdenTrabajoCodigo(codigos.get(r.getOrdenTrabajoId()));
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer ordenTrabajoCodigo: {}", e.getMessage());
            }
        }

        Set<Long> inspectorIds = responses.stream()
                .map(ControlCalidadResponse::getInspectorId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!inspectorIds.isEmpty()) {
            try {
                List<Object[]> rows = entityManager.createNativeQuery(
                        "SELECT id, nombre FROM auth.usuario WHERE id IN (:ids)")
                        .setParameter("ids", inspectorIds)
                        .getResultList();
                Map<Long, String> nombres = new HashMap<>();
                for (Object[] row : rows) {
                    nombres.put(((Number) row[0]).longValue(), (String) row[1]);
                }
                for (ControlCalidadResponse r : responses) {
                    if (r.getInspectorId() != null) {
                        r.setInspectorNombre(nombres.get(r.getInspectorId()));
                    }
                }
            } catch (Exception e) {
                log.warn("No se pudo enriquecer inspectorNombre: {}", e.getMessage());
            }
        }
    }

    // ───────────────────────── helpers ─────────────────────────

    private void validarDatosObligatorios(ControlCalidad entity) {
        if (entity.getFecha() == null || entity.getResultado() == null || entity.getResultado().isBlank()) {
            throw new BusinessException("Faltan datos obligatorios para el control de calidad",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.CONTROL_CALIDAD_DATOS_INCOMPLETOS);
        }
    }

    private void validarFKs(ControlCalidad entity) {
        if (entity.getOrdenTrabajoId() != null) {
            Integer count = (Integer) entityManager.createNativeQuery(
                    "SELECT COUNT(*)::int FROM produccion.orden_trabajo WHERE id = :id")
                    .setParameter("id", entity.getOrdenTrabajoId())
                    .getSingleResult();
            if (count == null || count == 0) {
                throw new BusinessException("La orden de trabajo no existe",
                        HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.CONTROL_CALIDAD_FK_INEXISTENTE);
            }
        }
        if (entity.getInspectorId() != null) {
            try {
                var response = authUsuarioClient.obtenerPorId(entity.getInspectorId());
                if (!response.isSuccess() || response.getData() == null) {
                    throw new BusinessException("El inspector no existe",
                            HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.CONTROL_CALIDAD_FK_INEXISTENTE);
                }
            } catch (FeignException e) {
                throw new BusinessException("El inspector no existe",
                        HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.CONTROL_CALIDAD_FK_INEXISTENTE);
            }
        }
    }

    private void validarResultado(String resultado) {
        if (resultado != null && !RESULTADOS_VALIDOS.contains(resultado.toUpperCase())) {
            throw new BusinessException(
                    "El resultado debe ser uno de: " + String.join(", ", RESULTADOS_VALIDOS),
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.CONTROL_CALIDAD_RESULTADO_INVALIDO);
        }
    }

    private Specification<ControlCalidad> buildSpecification(Long ordenTrabajoId, String resultado,
                                                              LocalDate fechaDesde, LocalDate fechaHasta,
                                                              Long inspectorId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (ordenTrabajoId != null) {
                predicates.add(cb.equal(root.get("ordenTrabajoId"), ordenTrabajoId));
            }
            if (resultado != null && !resultado.isBlank()) {
                predicates.add(cb.equal(root.get("resultado"), resultado.toUpperCase()));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            if (inspectorId != null) {
                predicates.add(cb.equal(root.get("inspectorId"), inspectorId));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
