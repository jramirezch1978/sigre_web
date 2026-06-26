package pe.restaurant.finanzas.service;

import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.constants.SolicitudGiroConstants;
import pe.restaurant.finanzas.dto.request.AprobarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.request.OperacionMasivaGiroRequest;
import pe.restaurant.finanzas.dto.request.RechazarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.response.OperacionMasivaGiroResultadoResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroDetalleResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.mapper.SolicitudGiroMapper;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Lógica de <b>Aprobación de Órdenes de Giro</b> (HU-FIN-ADL-002), implementada
 * <b>sin modificar la base de datos</b> y sin tocar los endpoints/servicios existentes de
 * {@code /api/finanzas/solicitudes-giro}.
 *
 * <p>Aporta, reutilizando la tabla {@code solicitud_giro} tal cual:</p>
 * <ul>
 *   <li><b>Estado "Rechazada" diferenciado</b> de "Anulada": el endpoint legacy
 *       {@code /solicitudes-giro/{id}/rechazar} deja {@code flag_estado = '0'} (Anulada); aquí se
 *       usa {@code '5'} (Rechazada). Posible sin BD porque {@code flag_estado} no tiene CHECK.</li>
 *   <li><b>Rechazo con observación OBLIGATORIA</b> ({@link RechazarOrdenGiroRequest} es
 *       {@code @NotBlank}); se persiste en la columna existente {@code motivo_rechazo}.</li>
 *   <li><b>Aprobación / rechazo masivo</b> (cada orden en su propia transacción).</li>
 *   <li><b>Validación de rol "Aprobador Financiero"</b> vía RBAC existente
 *       ({@link PermisoAprobacionGiroValidator}, solo lectura).</li>
 *   <li><b>Filtros</b> del listado de pendientes (estado, fechas, beneficiario, centro de costo,
 *       sucursal) sobre columnas existentes.</li>
 * </ul>
 *
 * <p><b>Transaccionalidad:</b> la clase NO se anota {@code @Transactional} a nivel de clase. Las
 * mutaciones unitarias ({@link #aprobarUno}/{@link #rechazarUno}) son {@code REQUIRES_NEW} y se
 * invocan a través de la auto-referencia {@code @Lazy self}, por lo que cada orden de los masivos
 * se confirma/revierte de forma independiente y el fallo de una no tumba a las demás.</p>
 *
 * <p><b>Pendiente por BD (no implementado aquí):</b> persistir la observación de <i>aprobación</i>
 * (no hay columna; hoy se hace eco + log), generar/registrar el asiento contable de la aprobación,
 * y la auditoría con IP/Acción. Ver brechas ADL-002.</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenGiroAprobacionService {

    private final SolicitudGiroRepository repository;
    private final SolicitudGiroMapper mapper;
    private final PermisoAprobacionGiroValidator permisoValidator;

    /** Auto-referencia para que los masivos invoquen las mutaciones unitarias a través del
     *  proxy transaccional (REQUIRES_NEW) y cada orden sea independiente. */
    @Autowired
    @Lazy
    private OrdenGiroAprobacionService self;

    // ------------------------------------------------------------------
    // 1) Listados (solo tipo "O") con filtros del servidor
    // ------------------------------------------------------------------
    @Transactional(readOnly = true)
    public Page<SolicitudGiroResponse> listar(
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            String estado,
            Long beneficiarioId,
            Long centrosCostoId,
            Long sucursalId,
            Pageable pageable) {
        return repository.findAll(spec(fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId, sucursalId), pageable)
                .map(mapper::toResponse);
    }

    /** Atajo: solo las Órdenes de Giro pendientes de aprobación (flag_estado = '3'). */
    @Transactional(readOnly = true)
    public Page<SolicitudGiroResponse> listarPendientes(
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            Long beneficiarioId,
            Long centrosCostoId,
            Long sucursalId,
            Pageable pageable) {
        return listar(fechaDesde, fechaHasta, SolicitudGiroConstants.FLAG_PENDIENTE,
                beneficiarioId, centrosCostoId, sucursalId, pageable);
    }

    private Specification<SolicitudGiro> spec(LocalDate fechaDesde, LocalDate fechaHasta, String estado,
                                              Long beneficiarioId, Long centrosCostoId, Long sucursalId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("tipoSolicitud"), SolicitudGiroConstants.TIPO_ORDEN_GIRO));
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            if (estado != null && !estado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), estado));
            }
            if (beneficiarioId != null) {
                predicates.add(cb.equal(root.get("solicitanteId"), beneficiarioId));
            }
            if (centrosCostoId != null) {
                predicates.add(cb.equal(root.get("centrosCostoId"), centrosCostoId));
            }
            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    // ------------------------------------------------------------------
    // 2) Aprobar (RBAC + estado Aprobada)
    // ------------------------------------------------------------------
    public SolicitudGiroDetalleResponse aprobar(Long id, AprobarOrdenGiroRequest request) {
        permisoValidator.validar(PermisoAprobacionGiroValidator.ACCION_APROBAR);
        return self.aprobarUno(id, request != null ? request.getObservacion() : null);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public SolicitudGiroDetalleResponse aprobarUno(Long id, String observacion) {
        SolicitudGiro orden = cargarOrdenGiro(id);
        exigirPendiente(orden, "aprobar");

        Long usuarioId = TenantContext.getUsuarioId();
        orden.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        orden.setAprobadorId(usuarioId);
        orden.setFecAprobacion(Instant.now());
        orden.setUpdatedBy(usuarioId);
        orden = repository.save(orden);

        // La observación de aprobación NO tiene columna: se registra en el log (eco en la respuesta
        // del controlador). Persistirla requiere ampliar la BD.
        if (observacion != null && !observacion.isBlank()) {
            log.info("OG {} aprobada por usuario {} con observación (no persistida): {}",
                    orden.getId(), usuarioId, observacion);
        }
        return mapper.toDetalleResponse(orden);
    }

    // ------------------------------------------------------------------
    // 3) Rechazar (RBAC + estado Rechazada diferenciado + observación obligatoria)
    // ------------------------------------------------------------------
    public SolicitudGiroDetalleResponse rechazar(Long id, RechazarOrdenGiroRequest request) {
        permisoValidator.validar(PermisoAprobacionGiroValidator.ACCION_RECHAZAR);
        return self.rechazarUno(id, request.getObservacion());
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public SolicitudGiroDetalleResponse rechazarUno(Long id, String observacion) {
        if (observacion == null || observacion.isBlank()) {
            throw new BusinessException(
                    "La observación (motivo de rechazo) es obligatoria",
                    FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
        SolicitudGiro orden = cargarOrdenGiro(id);
        exigirPendiente(orden, "rechazar");

        Long usuarioId = TenantContext.getUsuarioId();
        orden.setFlagEstado(SolicitudGiroConstants.FLAG_RECHAZADA); // '5' ≠ Anulada '0'
        orden.setMotivoRechazo(observacion);
        orden.setFecRechazo(Instant.now());
        orden.setAprobadorId(usuarioId);
        orden.setUpdatedBy(usuarioId);
        orden = repository.save(orden);

        return mapper.toDetalleResponse(orden);
    }

    // ------------------------------------------------------------------
    // 4) Aprobación masiva (cada orden en su propia transacción)
    // ------------------------------------------------------------------
    public OperacionMasivaGiroResultadoResponse aprobarMasivo(OperacionMasivaGiroRequest req) {
        permisoValidator.validar(PermisoAprobacionGiroValidator.ACCION_MASIVO);
        return procesarMasivo(req.getOrdenGiroIds(),
                id -> { self.aprobarUno(id, req.getObservacion()); return "Aprobada"; });
    }

    // ------------------------------------------------------------------
    // 5) Rechazo masivo (observación obligatoria, cada orden en su propia transacción)
    // ------------------------------------------------------------------
    public OperacionMasivaGiroResultadoResponse rechazarMasivo(OperacionMasivaGiroRequest req) {
        permisoValidator.validar(PermisoAprobacionGiroValidator.ACCION_MASIVO);
        if (req.getObservacion() == null || req.getObservacion().isBlank()) {
            throw new BusinessException(
                    "La observación (motivo de rechazo) es obligatoria para el rechazo masivo",
                    FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
        return procesarMasivo(req.getOrdenGiroIds(),
                id -> { self.rechazarUno(id, req.getObservacion()); return "Rechazada"; });
    }

    // ------------------------------------------------------------------
    // Helpers privados
    // ------------------------------------------------------------------
    private interface OperacionUnitaria {
        String ejecutar(Long id);
    }

    private OperacionMasivaGiroResultadoResponse procesarMasivo(List<Long> ids, OperacionUnitaria op) {
        OperacionMasivaGiroResultadoResponse resultado = new OperacionMasivaGiroResultadoResponse();
        List<OperacionMasivaGiroResultadoResponse.Item> items = new ArrayList<>();
        int exitosas = 0;
        int fallidas = 0;
        for (Long id : ids) {
            try {
                String mensaje = op.ejecutar(id);
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, true, mensaje));
                exitosas++;
            } catch (Exception e) {
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, false, e.getMessage()));
                fallidas++;
            }
        }
        resultado.setTotalProcesadas(ids.size());
        resultado.setExitosas(exitosas);
        resultado.setFallidas(fallidas);
        resultado.setResultados(items);
        return resultado;
    }

    private SolicitudGiro cargarOrdenGiro(Long id) {
        SolicitudGiro orden = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));
        if (!SolicitudGiroConstants.TIPO_ORDEN_GIRO.equals(orden.getTipoSolicitud())) {
            throw new BusinessException(
                    "El documento " + id + " no es una Orden de Giro (tipo O)",
                    FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
        return orden;
    }

    private void exigirPendiente(SolicitudGiro orden, String accion) {
        if (!SolicitudGiroConstants.FLAG_PENDIENTE.equals(orden.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden " + accion + " Órdenes de Giro pendientes de aprobación",
                    FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
    }
}
