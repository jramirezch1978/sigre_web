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
import pe.restaurant.produccion.client.CoreArticuloClient;
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.client.CoreUnidadMedidaClient;
import pe.restaurant.produccion.dto.response.ArticuloInfo;
import pe.restaurant.produccion.dto.response.CentrosCostoInfo;
import pe.restaurant.produccion.dto.response.EjecutorInfo;
import pe.restaurant.produccion.dto.response.EntidadContribuyenteInfo;
import pe.restaurant.produccion.dto.response.LaborInfo;
import pe.restaurant.produccion.dto.response.OperacionDetalleInfo;
import pe.restaurant.produccion.dto.response.OperacionInfo;
import pe.restaurant.produccion.dto.response.OtAdministracionInfo;
import pe.restaurant.produccion.dto.response.OtTipoInfo;
import pe.restaurant.produccion.dto.response.OrdenTrabajoResponse;
import pe.restaurant.produccion.dto.response.SucursalInfo;
import pe.restaurant.produccion.dto.response.UnidadMedidaInfo;
import pe.restaurant.produccion.entity.Labor;
import pe.restaurant.produccion.entity.OperacionesDet;
import pe.restaurant.produccion.entity.OrdenTrabajo;
import pe.restaurant.produccion.entity.OtAdministracion;
import pe.restaurant.produccion.entity.OtTipo;
import pe.restaurant.produccion.repository.LaborRepository;
import pe.restaurant.produccion.repository.OperacionRepository;
import pe.restaurant.produccion.repository.OperacionesDetRepository;
import pe.restaurant.produccion.repository.OtAdministracionRepository;
import pe.restaurant.produccion.repository.OtTipoRepository;
import pe.restaurant.produccion.repository.OrdenTrabajoRepository;
import pe.restaurant.produccion.event.publisher.ProduccionEventPublisher;
import pe.restaurant.produccion.service.OrdenTrabajoService;
import pe.restaurant.produccion.service.ProduccionErrorCodes;

import java.time.LocalDate;
import java.time.Year;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OrdenTrabajoServiceImpl implements OrdenTrabajoService {

    private final OrdenTrabajoRepository repository;
    private final CoreSucursalClient coreSucursalClient;
    private final CoreArticuloClient coreArticuloClient;
    private final CoreUnidadMedidaClient coreUnidadMedidaClient;
    private final OtTipoRepository otTipoRepository;
    private final OtAdministracionRepository otAdministracionRepository;
    private final OperacionRepository operacionRepository;
    private final OperacionesDetRepository operacionesDetRepository;
    private final LaborRepository laborRepository;
    private final ProduccionEventPublisher eventPublisher;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "findAll"})
    public Page<OrdenTrabajo> findAll(String codigo, Long sucursalId, Long otTipoId, Long otAdministracionId,
                                      LocalDate fechaInicio, LocalDate fechaFin,
                                      String flagEstado, Pageable pageable) {
        Specification<OrdenTrabajo> spec = buildSpecification(codigo, sucursalId, otTipoId, otAdministracionId,
                fechaInicio, fechaFin, flagEstado);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "findById"})
    public OrdenTrabajo findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenTrabajo", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "create"})
    public OrdenTrabajo create(OrdenTrabajo entity) {
        validarSucursal(entity.getSucursalId());
        validarOtTipo(entity.getOtTipoId());
        validarOtAdministracion(entity.getOtAdministracionId());
        validarFechaInicioRequerida(entity.getFechaInicio());
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());

        if (entity.getCodigo() == null || entity.getCodigo().isBlank()) {
            entity.setCodigo(generarCodigo());
        } else if (repository.existsByCodigo(entity.getCodigo())) {
            throw new BusinessException("Ya existe una orden de trabajo con el código " + entity.getCodigo(),
                    HttpStatus.CONFLICT, "PRD-OT-003");
        }
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "update"})
    public OrdenTrabajo update(Long id, OrdenTrabajo entity) {
        OrdenTrabajo existing = findById(id);
        validarEstadoActiva(existing);
        validarSucursal(entity.getSucursalId());
        validarOtTipo(entity.getOtTipoId());
        validarOtAdministracion(entity.getOtAdministracionId());
        validarFechaInicioRequerida(entity.getFechaInicio());
        validarFechas(entity.getFechaInicio(), entity.getFechaFin());

        existing.setSucursalId(entity.getSucursalId());
        existing.setOtTipoId(entity.getOtTipoId());
        existing.setOtAdministracionId(entity.getOtAdministracionId());
        existing.setFechaInicio(entity.getFechaInicio());
        existing.setFechaFin(entity.getFechaFin());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "activate"})
    public OrdenTrabajo activate(Long id) {
        OrdenTrabajo existing = findById(id);
        if ("1".equals(existing.getFlagEstado())) {
            throw new BusinessException("La orden de trabajo ya se encuentra activa",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_CONFLICTO_ESTADO);
        }
        if ("2".equals(existing.getFlagEstado())) {
            throw new BusinessException("No se puede activar una orden de trabajo cerrada",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_CONFLICTO_ESTADO);
        }
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "deactivate"})
    public OrdenTrabajo deactivate(Long id) {
        OrdenTrabajo existing = findById(id);
        validarEstadoActiva(existing);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "cerrar"})
    public OrdenTrabajo cerrar(Long id) {
        OrdenTrabajo existing = findById(id);
        validarEstadoActiva(existing);
        validarTieneOperacionesActivas(existing.getId());
        existing.setFlagEstado("2");
        if (existing.getFechaFin() == null) {
            existing.setFechaFin(LocalDate.now());
        }
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        OrdenTrabajo saved = repository.save(existing);
        eventPublisher.publicarOrdenCompletada(saved);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "anular"})
    public OrdenTrabajo anular(Long id) {
        OrdenTrabajo existing = findById(id);
        validarEstadoActiva(existing);
        validarSinValesVinculados(existing.getId());
        validarSinOrdenesCompraVinculadas(existing.getId());
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        OrdenTrabajo saved = repository.save(existing);
        eventPublisher.publicarOrdenCancelada(saved);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "delete"})
    public void delete(Long id) {
        OrdenTrabajo existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(existing);
    }

    // ───────────────────────── enrichment ──────────────────────

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "orden_trabajo", "operation", "enrich"})
    public void enrich(OrdenTrabajoResponse response) {
        if (response == null) return;

        if (response.getSucursal() != null && response.getSucursal().getId() != null) {
            try {
                var sucResp = coreSucursalClient.obtenerPorId(response.getSucursal().getId());
                if (sucResp.isSuccess() && sucResp.getData() != null) {
                    response.getSucursal().setNombre(sucResp.getData().getNombre());
                }
            } catch (FeignException e) {
                log.warn("No se pudo obtener sucursal {}: {}", response.getSucursal().getId(), e.getMessage());
            }
        }

        if (response.getOtTipo() != null && response.getOtTipo().getId() != null) {
            otTipoRepository.findById(response.getOtTipo().getId())
                    .ifPresent(tipo -> {
                        response.getOtTipo().setCodigo(tipo.getCodigo());
                        response.getOtTipo().setNombre(tipo.getNombre());
                    });
        }

        if (response.getOtAdministracion() != null && response.getOtAdministracion().getId() != null) {
            otAdministracionRepository.findById(response.getOtAdministracion().getId())
                    .ifPresent(admin -> {
                        response.getOtAdministracion().setCodigo(admin.getCodigo());
                        response.getOtAdministracion().setNombre(admin.getNombre());
                    });
        }
    }

    @Override
    public void enrichDetail(OrdenTrabajoResponse response) {
        enrich(response);
        enrichOperaciones(response);
    }

    private void enrichOperaciones(OrdenTrabajoResponse response) {
        if (response.getId() == null) return;
        List<pe.restaurant.produccion.entity.Operacion> operaciones =
                operacionRepository.findByOrdenTrabajoIdOrderByIdAsc(response.getId());
        if (operaciones.isEmpty()) return;

        List<OperacionInfo> opsInfo = new ArrayList<>();
        for (var op : operaciones) {
            List<OperacionesDet> detalles = operacionesDetRepository.findByOperacionIdOrderByIdAsc(op.getId());
            List<OperacionDetalleInfo> detsInfo = new ArrayList<>();
            for (var det : detalles) {
                ArticuloInfo articuloInfo = null;
                if (det.getArticuloId() != null) {
                    try {
                        var artResp = coreArticuloClient.obtenerPorId(det.getArticuloId());
                        if (artResp.isSuccess() && artResp.getData() != null) {
                            articuloInfo = new ArticuloInfo(
                                    artResp.getData().getId(), artResp.getData().getNombre());
                        }
                    } catch (FeignException e) {
                        log.warn("No se pudo obtener articulo {}: {}", det.getArticuloId(), e.getMessage());
                    }
                }

                detsInfo.add(OperacionDetalleInfo.builder()
                        .id(det.getId())
                        .articulo(articuloInfo)
                        .cantidadRequerida(det.getCantidadRequerida())
                        .flagEstado(det.getFlagEstado())
                        .build());
            }

            LaborInfo laborInfo = null;
            if (op.getLaborId() != null) {
                laborInfo = laborRepository.findById(op.getLaborId())
                        .map(l -> new LaborInfo(l.getId(), l.getNombre()))
                        .orElse(null);
            }

            EjecutorInfo ejecutorInfo = null;
            if (op.getEjecutorId() != null) {
                try {
                    var nombre = (String) entityManager.createNativeQuery(
                            "SELECT nombre FROM produccion.ejecutor WHERE id = :id")
                            .setParameter("id", op.getEjecutorId())
                            .getSingleResult();
                    ejecutorInfo = new EjecutorInfo(op.getEjecutorId(), nombre);
                } catch (Exception e) {
                    log.warn("No se pudo obtener ejecutor {}: {}", op.getEjecutorId(), e.getMessage());
                }
            }

            EntidadContribuyenteInfo entidadInfo = null;
            if (op.getEntidadContribuyenteId() != null) {
                try {
                    var rs = (Object[]) entityManager.createNativeQuery(
                            "SELECT id, razon_social FROM core.entidad_contribuyente WHERE id = :id")
                            .setParameter("id", op.getEntidadContribuyenteId())
                            .getSingleResult();
                    entidadInfo = new EntidadContribuyenteInfo(
                            ((Number) rs[0]).longValue(), (String) rs[1]);
                } catch (Exception e) {
                    log.warn("No se pudo obtener entidad contribuyente {}: {}", op.getEntidadContribuyenteId(), e.getMessage());
                }
            }

            CentrosCostoInfo centrosInfo = null;
            if (op.getCentrosCostoId() != null) {
                try {
                    var nombre = (String) entityManager.createNativeQuery(
                            "SELECT nombre FROM contabilidad.centros_costo WHERE id = :id")
                            .setParameter("id", op.getCentrosCostoId())
                            .getSingleResult();
                    centrosInfo = new CentrosCostoInfo(op.getCentrosCostoId(), nombre);
                } catch (Exception e) {
                    log.warn("No se pudo obtener centros_costo {}: {}", op.getCentrosCostoId(), e.getMessage());
                }
            }

            UnidadMedidaInfo umInfo = null;
            if (op.getUnidadMedidaId() != null) {
                try {
                    var umResp = coreUnidadMedidaClient.obtenerPorId(op.getUnidadMedidaId());
                    if (umResp.isSuccess() && umResp.getData() != null) {
                        umInfo = new UnidadMedidaInfo(
                                umResp.getData().getId(),
                                umResp.getData().getNombre(),
                                umResp.getData().getAbreviatura());
                    }
                } catch (FeignException e) {
                    log.warn("No se pudo obtener unidadMedida {}: {}", op.getUnidadMedidaId(), e.getMessage());
                }
            }

            opsInfo.add(OperacionInfo.builder()
                    .id(op.getId())
                    .nroOperacion(op.getNroOperacion())
                    .labor(laborInfo)
                    .ejecutor(ejecutorInfo)
                    .entidadContribuyente(entidadInfo)
                    .centrosCosto(centrosInfo)
                    .unidadMedida(umInfo)
                    .descripcion(op.getDescripcion())
                    .nroPersonas(op.getNroPersonas())
                    .fecInicioEstimado(op.getFecInicioEstimado())
                    .fecInicio(op.getFecInicio())
                    .fecFin(op.getFecFin())
                    .diasParaInicio(op.getDiasParaInicio())
                    .diasDuracionProy(op.getDiasDuracionProy())
                    .diasHolgura(op.getDiasHolgura())
                    .cantidadProyectada(op.getCantidadProyectada())
                    .cantidadReal(op.getCantidadReal())
                    .costoUnitario(op.getCostoUnitario())
                    .costoProyectado(op.getCostoProyectado())
                    .observacion(op.getObservacion())
                    .flagEstado(op.getFlagEstado())
                    .detalles(detsInfo)
                    .build());
        }
        response.setOperaciones(opsInfo);
    }

    // ───────────────────────── helpers ─────────────────────────

    private void validarSucursal(Long sucursalId) {
        try {
            var response = coreSucursalClient.obtenerPorId(sucursalId);
            if (!response.isSuccess() || response.getData() == null
                    || !"1".equals(response.getData().getFlagEstado())) {
                throw new BusinessException("La sucursal no existe o está inactiva",
                        HttpStatus.NOT_FOUND, ProduccionErrorCodes.OT_SUCURSAL_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("La sucursal no existe o está inactiva",
                    HttpStatus.NOT_FOUND, ProduccionErrorCodes.OT_SUCURSAL_INEXISTENTE);
        }
    }

    private void validarOtTipo(Long otTipoId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.ot_tipo WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", otTipoId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("El tipo de OT no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_TIPO_INEXISTENTE);
        }
    }

    private void validarOtAdministracion(Long otAdministracionId) {
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.ot_administracion WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", otAdministracionId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La administración de OT no existe o está inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_ADMIN_INEXISTENTE);
        }
    }

    private void validarFechaInicioRequerida(LocalDate fechaInicio) {
        if (fechaInicio == null) {
            throw new BusinessException("La fecha de inicio es obligatoria",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_FECHA_INICIO_REQUERIDA);
        }
    }

    private void validarEstadoActiva(OrdenTrabajo entity) {
        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException("La orden de trabajo no está en estado activa",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_CONFLICTO_ESTADO);
        }
    }

    private void validarFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaFin == null) {
            throw new BusinessException("La fecha fin es obligatoria: la orden de trabajo debe ser finita",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_FECHA_FIN_REQUERIDA);
        }
        if (fechaFin.isBefore(fechaInicio)) {
            throw new BusinessException("La fecha fin no puede ser anterior a la fecha inicio",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_FECHA_FIN_INVALIDA);
        }
    }

    private void validarTieneOperacionesActivas(Long ordenTrabajoId) {
        long count = operacionRepository.countByOrdenTrabajoIdAndFlagEstado(ordenTrabajoId, "1");
        if (count == 0) {
            throw new BusinessException("La orden de trabajo debe tener al menos una operación activa para cerrar",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_SIN_OPERACIONES);
        }
    }

    private void validarSinValesVinculados(Long ordenTrabajoId) {
        if (existeSqlNativo(
                "SELECT COUNT(*)::bigint FROM almacen.vale_mov "
                        + "WHERE orden_trabajo_id = :otId AND flag_estado <> '0'",
                ordenTrabajoId)) {
            throw new BusinessException("No se puede anular: la OT tiene vales de almacén vinculados",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_ANULAR_VALE);
        }
    }

    private void validarSinOrdenesCompraVinculadas(Long ordenTrabajoId) {
        if (existeSqlNativo(
                "SELECT COUNT(*)::bigint FROM compras.orden_compra_det ocd "
                        + "INNER JOIN produccion.operaciones_det od ON od.id = ocd.operaciones_det_id "
                        + "INNER JOIN produccion.operacion op ON op.id = od.operacion_id "
                        + "WHERE op.orden_trabajo_id = :otId AND ocd.flag_estado = '1'",
                ordenTrabajoId)
                || existeSqlNativo(
                "SELECT COUNT(*)::bigint FROM compras.orden_servicio os "
                        + "WHERE os.orden_trabajo_id = :otId AND os.flag_estado <> '0'",
                ordenTrabajoId)
                || existeSqlNativo(
                "SELECT COUNT(*)::bigint FROM compras.orden_servicio_det osd "
                        + "INNER JOIN produccion.operaciones_det od ON od.id = osd.operaciones_det_id "
                        + "INNER JOIN produccion.operacion op ON op.id = od.operacion_id "
                        + "WHERE op.orden_trabajo_id = :otId AND osd.flag_estado = '1'",
                ordenTrabajoId)) {
            throw new BusinessException("No se puede anular: la OT tiene órdenes de compra o servicio vinculadas",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_ANULAR_OC);
        }
    }

    private boolean existeSqlNativo(String sql, Long ordenTrabajoId) {
        Number count = (Number) entityManager.createNativeQuery(sql)
                .setParameter("otId", ordenTrabajoId)
                .getSingleResult();
        return count != null && count.longValue() > 0;
    }

    private String generarCodigo() {
        String anio = String.valueOf(Year.now().getValue());
        int secuencia = repository.maxSecuenciaByAnio(anio) + 1;
        return String.format("OT-%s-%04d", anio, secuencia);
    }

    private Specification<OrdenTrabajo> buildSpecification(String codigo, Long sucursalId, Long otTipoId,
                                                            Long otAdministracionId,
                                                            LocalDate fechaInicio, LocalDate fechaFin,
                                                            String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (codigo != null && !codigo.isBlank()) {
                predicates.add(cb.like(cb.upper(root.get("codigo")), "%" + codigo.toUpperCase() + "%"));
            }
            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (otTipoId != null) {
                predicates.add(cb.equal(root.get("otTipoId"), otTipoId));
            }
            if (otAdministracionId != null) {
                predicates.add(cb.equal(root.get("otAdministracionId"), otAdministracionId));
            }
            if (fechaInicio != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaInicio"), fechaInicio));
            }
            if (fechaFin != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaInicio"), fechaFin));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
