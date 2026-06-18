package pe.restaurant.produccion.service.impl;

import io.micrometer.core.annotation.Timed;
import feign.FeignException;
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
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.dto.response.ProgramacionProduccionResponse;
import pe.restaurant.produccion.entity.ProgramacionProduccion;
import pe.restaurant.produccion.repository.ProgramacionProduccionRepository;
import pe.restaurant.produccion.service.ProduccionErrorCodes;
import pe.restaurant.produccion.service.ProgramacionProduccionService;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProgramacionProduccionServiceImpl implements ProgramacionProduccionService {

    private final ProgramacionProduccionRepository repository;
    private final CoreSucursalClient coreSucursalClient;
    @PersistenceContext
    private EntityManager entityManager;

    private static final Set<String> FRECUENCIAS_VALIDAS = Set.of("DIARIA", "SEMANAL", "MENSUAL");

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "findAll"})
    public Page<ProgramacionProduccion> findAll(Long recetaId, Long sucursalId, String frecuencia,
                                                LocalDate fechaDesde, LocalDate fechaHasta,
                                                String flagEstado, Pageable pageable) {
        Specification<ProgramacionProduccion> spec = buildSpecification(
                recetaId, sucursalId, frecuencia, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "findById"})
    public ProgramacionProduccion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ProgramacionProduccion", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "create"})
    public ProgramacionProduccion create(ProgramacionProduccion entity) {
        validarReceta(entity.getRecetaId());
        validarOrdenTrabajoObligatoria(entity.getOrdenTrabajoId());
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());
        validarFrecuencia(entity.getFrecuencia());
        validarOT(entity.getOrdenTrabajoId());
        if (entity.getSucursalId() != null) {
            validarSucursal(entity.getSucursalId());
        }
        entity.setFrecuencia(entity.getFrecuencia().trim().toUpperCase());
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "update"})
    public ProgramacionProduccion update(Long id, ProgramacionProduccion entity) {
        ProgramacionProduccion existing = findById(id);
        validarReceta(entity.getRecetaId());
        validarOrdenTrabajoObligatoria(entity.getOrdenTrabajoId());
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());
        validarFrecuencia(entity.getFrecuencia());
        validarOT(entity.getOrdenTrabajoId());
        if (entity.getSucursalId() != null) {
            validarSucursal(entity.getSucursalId());
        }

        existing.setSucursalId(entity.getSucursalId());
        existing.setRecetaId(entity.getRecetaId());
        existing.setOrdenTrabajoId(entity.getOrdenTrabajoId());
        existing.setFrecuencia(entity.getFrecuencia().trim().toUpperCase());
        existing.setFechaInicio(entity.getFechaInicio());
        existing.setFechaFin(entity.getFechaFin());
        existing.setCantidadPorPeriodo(entity.getCantidadPorPeriodo());
        existing.setTurno(entity.getTurno());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "activate"})
    public ProgramacionProduccion activate(Long id) {
        ProgramacionProduccion existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "deactivate"})
    public ProgramacionProduccion deactivate(Long id) {
        ProgramacionProduccion existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "programacion_produccion", "operation", "delete"})
    public void delete(Long id) {
        ProgramacionProduccion existing = findById(id);
        existing.setFlagEstado("0");
        repository.save(existing);
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    @SuppressWarnings("unchecked")
    public void enrichResponses(List<ProgramacionProduccionResponse> responses) {
        if (responses == null || responses.isEmpty()) return;

        Set<Long> recetaIds = responses.stream()
                .map(ProgramacionProduccionResponse::getRecetaId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!recetaIds.isEmpty()) {
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, nro_receta, nombre FROM produccion.receta WHERE id IN (:ids)")
                    .setParameter("ids", recetaIds)
                    .getResultList();
            Map<Long, String[]> recetas = new java.util.HashMap<>();
            for (Object[] row : rows) {
                recetas.put(((Number) row[0]).longValue(), new String[]{(String) row[1], (String) row[2]});
            }
            for (ProgramacionProduccionResponse r : responses) {
                String[] info = recetas.get(r.getRecetaId());
                if (info != null) {
                    r.setRecetaCodigo(info[0]);
                    r.setRecetaNombre(info[1]);
                }
            }
        }

        Set<Long> otIds = responses.stream()
                .map(ProgramacionProduccionResponse::getOrdenTrabajoId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!otIds.isEmpty()) {
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, codigo FROM produccion.orden_trabajo WHERE id IN (:ids)")
                    .setParameter("ids", otIds)
                    .getResultList();
            Map<Long, String> ots = new java.util.HashMap<>();
            for (Object[] row : rows) {
                ots.put(((Number) row[0]).longValue(), (String) row[1]);
            }
            for (ProgramacionProduccionResponse r : responses) {
                if (r.getOrdenTrabajoId() != null) {
                    r.setOrdenTrabajoCodigo(ots.get(r.getOrdenTrabajoId()));
                }
            }
        }

        Set<Long> sucursalIds = responses.stream()
                .map(ProgramacionProduccionResponse::getSucursalId)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toSet());
        if (!sucursalIds.isEmpty()) {
            List<Object[]> rows = entityManager.createNativeQuery(
                    "SELECT id, nombre FROM auth.sucursal WHERE id IN (:ids)")
                    .setParameter("ids", sucursalIds)
                    .getResultList();
            Map<Long, String> sucursales = new java.util.HashMap<>();
            for (Object[] row : rows) {
                sucursales.put(((Number) row[0]).longValue(), (String) row[1]);
            }
            for (ProgramacionProduccionResponse r : responses) {
                if (r.getSucursalId() != null) {
                    r.setSucursalNombre(sucursales.get(r.getSucursalId()));
                }
            }
        }
    }

    // ───────────────────────── helpers ─────────────────────────

    private void validarReceta(Long recetaId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.receta WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", recetaId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La receta no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PROG_RECETA_INEXISTENTE);
        }
    }

    private void validarFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaFin != null && fechaFin.isBefore(fechaInicio)) {
            throw new BusinessException("La fecha fin no puede ser anterior a la fecha inicio",
                    HttpStatus.BAD_REQUEST, null);
        }
    }

    private void validarOrdenTrabajoObligatoria(Long ordenTrabajoId) {
        if (ordenTrabajoId == null) {
            throw new BusinessException("La orden de trabajo es obligatoria",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.PROG_DATOS_INCOMPLETOS);
        }
    }

    private void validarOT(Long ordenTrabajoId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.orden_trabajo WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", ordenTrabajoId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La orden de trabajo no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PROG_OT_INEXISTENTE);
        }
    }

    private void validarSucursal(Long sucursalId) {
        try {
            var response = coreSucursalClient.obtenerPorId(sucursalId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                throw new BusinessException("La sucursal no existe o está inactiva",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.PROG_SUCURSAL_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("La sucursal no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.PROG_SUCURSAL_INEXISTENTE);
        }
    }

    private void validarFrecuencia(String frecuencia) {
        if (frecuencia == null || frecuencia.isBlank()) return;
        String normalizada = frecuencia.trim().toUpperCase();
        if (!FRECUENCIAS_VALIDAS.contains(normalizada)) {
            throw new BusinessException("Frecuencia inválida: " + frecuencia + ". Valores permitidos: DIARIA, SEMANAL, MENSUAL",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.PROG_FRECUENCIA_INVALIDA);
        }
    }

    private Specification<ProgramacionProduccion> buildSpecification(Long recetaId, Long sucursalId,
                                                                      String frecuencia,
                                                                      LocalDate fechaDesde, LocalDate fechaHasta,
                                                                      String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (recetaId != null) {
                predicates.add(cb.equal(root.get("recetaId"), recetaId));
            }
            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (frecuencia != null && !frecuencia.isBlank()) {
                predicates.add(cb.equal(cb.upper(root.get("frecuencia")), frecuencia.toUpperCase()));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaInicio"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaInicio"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
