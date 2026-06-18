package pe.restaurant.rrhh.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.SolicitarGoceRequest;
import pe.restaurant.rrhh.dto.request.VacacionCreateRequest;
import pe.restaurant.rrhh.dto.request.VacacionObservarRequest;
import pe.restaurant.rrhh.dto.request.VacacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.SaldoVacacionDto;
import pe.restaurant.rrhh.dto.response.VacacionResponse;
import pe.restaurant.rrhh.entity.Vacacion;
import pe.restaurant.rrhh.mapper.VacacionMapper;
import pe.restaurant.rrhh.repository.TrabajadorRepository;
import pe.restaurant.rrhh.repository.VacacionRepository;
import pe.restaurant.rrhh.service.VacacionService;
import pe.restaurant.rrhh.util.RrhhFlagEstadoLegacyNormalizer;

import java.time.Instant;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static java.util.stream.Collectors.groupingBy;
import static pe.restaurant.rrhh.constants.VacacionConstants.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class VacacionServiceImpl implements VacacionService {

    private final VacacionRepository repository;
    private final VacacionMapper mapper;
    private final TrabajadorRepository trabajadorRepository;

    private static final Set<String> ESTADOS_SOLICITABLES = Set.of(ESTADO_REGISTRADO);
    private static final Set<String> ESTADOS_APROBABLES = Set.of(ESTADO_PENDIENTE);
    private static final Set<String> ESTADOS_REPROGRAMABLES = Set.of(ESTADO_APROBADO);

    @Override @Timed("rrhh.vacacion.listar")
    public Page<VacacionResponse> listar(Long trabajadorId, Integer periodoAnio, String flagEstado, Pageable pageable) {
        if (trabajadorId != null) {
            return repository.findByTrabajadorId(trabajadorId, pageable)
                    .map(v -> mapper.toResponse(RrhhFlagEstadoLegacyNormalizer.normalizeVacacion(v)));
        }
        return repository.findAll(pageable)
                .map(v -> mapper.toResponse(RrhhFlagEstadoLegacyNormalizer.normalizeVacacion(v)));
    }

    @Override @Timed("rrhh.vacacion.obtener")
    public VacacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.vacacion.crear")
    public VacacionResponse crear(VacacionCreateRequest request) {
        if (repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(request.getTrabajadorId(), request.getPeriodoAnio(), List.of(ESTADO_ANULADO, ESTADO_CERRADO))) {
            throw new BusinessException("Ya existe un período vacacional para este trabajador y año",
                    HttpStatus.CONFLICT, "RH-VC-001");
        }
        Vacacion v = new Vacacion();
        v.setTrabajadorId(request.getTrabajadorId());
        v.setPeriodoAnio(request.getPeriodoAnio());
        v.setDiasDerecho(request.getDiasDerecho() != null ? request.getDiasDerecho() : 30);
        v.setDiasGozados(0);
        v.setDiasPendientes(v.getDiasDerecho());
        v.setFechaInicio(request.getFechaInicio());
        v.setFechaFin(request.getFechaFin());
        v.setFlagEstado(ESTADO_REGISTRADO);
        v.setCreatedBy(TenantContext.getUsuarioId());
        v.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.actualizar")
    public VacacionResponse actualizar(Long id, VacacionUpdateRequest request) {
        Vacacion v = buscarOrThrow(id);
        if (request.getDiasDerecho() != null) {
            v.setDiasDerecho(request.getDiasDerecho());
            v.setDiasPendientes(request.getDiasDerecho() - v.getDiasGozados());
        }
        if (request.getFechaInicio() != null) v.setFechaInicio(request.getFechaInicio());
        if (request.getFechaFin() != null) v.setFechaFin(request.getFechaFin());
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.solicitarGoce")
    public VacacionResponse solicitarGoce(Long id, SolicitarGoceRequest request) {
        Vacacion v = buscarOrThrow(id);
        if (!ESTADOS_SOLICITABLES.contains(v.getFlagEstado())) {
            throw new BusinessException("Solo se puede solicitar goce en período activo",
                    HttpStatus.BAD_REQUEST, "RH-VC-002");
        }
        if (request.getFechaFin().isBefore(request.getFechaInicio())) {
            throw new BusinessException("Fecha fin debe ser posterior a fecha inicio",
                    HttpStatus.BAD_REQUEST, "RH-VC-003");
        }
        int dias = (int) ChronoUnit.DAYS.between(request.getFechaInicio(), request.getFechaFin()) + 1;
        if (dias > v.getDiasPendientes()) {
            throw new BusinessException("Los días solicitados exceden los días pendientes",
                    HttpStatus.BAD_REQUEST, "RH-VC-004");
        }
        v.setFechaInicio(request.getFechaInicio());
        v.setFechaFin(request.getFechaFin());
        v.setFlagEstado(ESTADO_PENDIENTE);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.aprobar")
    public VacacionResponse aprobar(Long id) {
        Vacacion v = buscarOrThrow(id);
        if (!ESTADOS_APROBABLES.contains(v.getFlagEstado())) {
            throw new BusinessException("Solo se pueden aprobar solicitudes pendientes",
                    HttpStatus.BAD_REQUEST, "RH-VC-002");
        }
        if (v.getFechaInicio() != null && v.getFechaFin() != null) {
            int dias = (int) ChronoUnit.DAYS.between(v.getFechaInicio(), v.getFechaFin()) + 1;
            v.setDiasGozados(v.getDiasGozados() + dias);
            v.setDiasPendientes(v.getDiasDerecho() - v.getDiasGozados());
        }
        v.setFlagEstado(ESTADO_APROBADO);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.rechazar")
    public VacacionResponse rechazar(Long id) {
        Vacacion v = buscarOrThrow(id);
        if (!ESTADOS_APROBABLES.contains(v.getFlagEstado())) {
            throw new BusinessException("Solo se pueden rechazar solicitudes pendientes",
                    HttpStatus.BAD_REQUEST, "RH-VC-002");
        }
        v.setFlagEstado(ESTADO_RECHAZADO);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.reprogramar")
    public VacacionResponse reprogramar(Long id, SolicitarGoceRequest request) {
        Vacacion v = buscarOrThrow(id);
        if (!ESTADOS_REPROGRAMABLES.contains(v.getFlagEstado())) {
            throw new BusinessException("Solo se puede reprogramar un goce aprobado",
                    HttpStatus.BAD_REQUEST, "RH-VC-002");
        }
        if (request.getFechaFin().isBefore(request.getFechaInicio())) {
            throw new BusinessException("Fecha fin debe ser posterior a fecha inicio",
                    HttpStatus.BAD_REQUEST, "RH-VC-003");
        }
        int dias = (int) ChronoUnit.DAYS.between(request.getFechaInicio(), request.getFechaFin()) + 1;
        if (dias > v.getDiasPendientes() + v.getDiasGozados()) {
            throw new BusinessException("Los días solicitados exceden los días disponibles",
                    HttpStatus.BAD_REQUEST, "RH-VC-004");
        }
        v.setFechaInicio(request.getFechaInicio());
        v.setFechaFin(request.getFechaFin());
        v.setFlagEstado(ESTADO_PENDIENTE);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.desactivar")
    public VacacionResponse desactivar(Long id) {
        Vacacion v = buscarOrThrow(id);
        v.setFlagEstado(ESTADO_ANULADO);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO — NUEVAS
    // ══════════════════════════════════════════════════════════════

    @Override @Transactional @Timed("rrhh.vacacion.observar")
    public VacacionResponse observar(Long id, VacacionObservarRequest request) {
        Vacacion v = buscarOrThrow(id);
        if (!List.of(ESTADO_PENDIENTE, ESTADO_APROBADO).contains(v.getFlagEstado())) {
            throw new BusinessException("Solo se pueden observar solicitudes pendientes o aprobadas",
                    HttpStatus.BAD_REQUEST, ERROR_ESTADO_INVALIDO);
        }
        v.setFlagEstado(ESTADO_PENDIENTE);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.anular")
    public VacacionResponse anular(Long id) {
        Vacacion v = buscarOrThrow(id);
        if (List.of(ESTADO_ANULADO, ESTADO_CERRADO).contains(v.getFlagEstado())) {
            throw new BusinessException("No se puede anular una vacación ya cerrada o anulada",
                    HttpStatus.BAD_REQUEST, ERROR_ESTADO_INVALIDO);
        }
        v.setFlagEstado(ESTADO_ANULADO);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    @Override @Transactional @Timed("rrhh.vacacion.cerrar")
    public VacacionResponse cerrar(Long id) {
        Vacacion v = buscarOrThrow(id);
        if (!ESTADO_APROBADO.equals(v.getFlagEstado())) {
            throw new BusinessException("Solo se pueden cerrar vacaciones aprobadas",
                    HttpStatus.BAD_REQUEST, ERROR_ESTADO_INVALIDO);
        }
        v.setFlagEstado(ESTADO_CERRADO);
        v.setUpdatedBy(TenantContext.getUsuarioId());
        v.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(v));
    }

    // ══════════════════════════════════════════════════════════════
    //  CONSULTAS Y PROCESOS BATCH
    // ══════════════════════════════════════════════════════════════

    @Override @Timed("rrhh.vacacion.bandejaAprobacion")
    public Page<VacacionResponse> bandejaAprobacion(Integer periodoAnio, Pageable pageable) {
        Specification<Vacacion> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            var estadosBandeja = new ArrayList<>(List.of(ESTADO_PENDIENTE, ESTADO_REGISTRADO));
            estadosBandeja.addAll(RrhhFlagEstadoLegacyNormalizer.vacacionFlagEstadosParaFiltro(ESTADO_PENDIENTE));
            predicates.add(root.get("flagEstado").in(estadosBandeja.stream().distinct().toList()));
            if (periodoAnio != null) {
                predicates.add(cb.equal(root.get("periodoAnio"), periodoAnio));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        return repository.findAll(spec, pageable)
                .map(v -> mapper.toResponse(RrhhFlagEstadoLegacyNormalizer.normalizeVacacion(v)));
    }

    @Override @Timed("rrhh.vacacion.consultarSaldos")
    public List<SaldoVacacionDto> consultarSaldos(Integer periodoAnio) {
        Specification<Vacacion> spec = (root, query, cb) -> {
            if (periodoAnio != null) {
                return cb.equal(root.get("periodoAnio"), periodoAnio);
            }
            return cb.conjunction();
        };
        return repository.findAll(spec).stream()
                .collect(groupingBy(v -> v.getTrabajadorId() + "|" + v.getPeriodoAnio()))
                .values().stream()
                .map(list -> {
                    Vacacion first = list.getFirst();
                    return new SaldoVacacionDto(
                            first.getTrabajadorId(),
                            null, // trabajadorNombres — se resuelve desde el frontend o en futura ampliación
                            first.getPeriodoAnio(),
                            list.stream().mapToInt(Vacacion::getDiasDerecho).sum(),
                            list.stream().mapToInt(Vacacion::getDiasGozados).sum(),
                            list.stream().mapToInt(Vacacion::getDiasPendientes).sum(),
                            0   // diasProgramados — se obtiene de program_vacacion si aplica
                    );
                })
                .toList();
    }

    @Override @Transactional @Timed("rrhh.vacacion.procesar")
    public VacacionResponse procesar(Integer periodoAnio) {
        Long usuarioId = TenantContext.getUsuarioId();
        List<Long> activosIds = trabajadorRepository.findActivosIds();
        Vacacion ultimo = null;
        for (Long tid : activosIds) {
            if (repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(tid, periodoAnio, List.of(ESTADO_ANULADO, ESTADO_CERRADO))) {
                continue;
            }
            Vacacion v = new Vacacion();
            v.setTrabajadorId(tid);
            v.setPeriodoAnio(periodoAnio);
            v.setDiasDerecho(30);
            v.setDiasGozados(0);
            v.setDiasPendientes(30);
            v.setFlagEstado(ESTADO_REGISTRADO);
            v.setCreatedBy(usuarioId);
            v.setFecCreacion(Instant.now());
            ultimo = repository.save(v);
        }
        if (ultimo == null) {
            throw new BusinessException("Todos los trabajadores activos ya tienen registro en el año " + periodoAnio,
                    HttpStatus.CONFLICT, "RH-VC-005");
        }
        return mapper.toResponse(ultimo);
    }

    private Vacacion buscarOrThrow(Long id) {
        return repository.findById(id)
                .map(RrhhFlagEstadoLegacyNormalizer::normalizeVacacion)
                .orElseThrow(() -> {
                    log.warn("Vacación no encontrada: {}", id);
                    return new ResourceNotFoundException("Vacacion", id);
                });
    }
}
