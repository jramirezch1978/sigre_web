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
import com.sigre.produccion.dto.response.OperacionDetResponse;
import com.sigre.produccion.dto.response.OperacionResponse;
import com.sigre.produccion.entity.Operacion;
import com.sigre.produccion.entity.OrdenTrabajo;
import com.sigre.produccion.entity.OperacionesDet;
import com.sigre.produccion.repository.OperacionRepository;
import com.sigre.produccion.repository.OperacionesDetRepository;
import com.sigre.produccion.repository.OrdenTrabajoRepository;
import com.sigre.produccion.service.OperacionService;
import com.sigre.produccion.service.ProduccionErrorCodes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OperacionServiceImpl implements OperacionService {

    private final OperacionRepository repository;
    private final OperacionesDetRepository detRepository;
    private final OrdenTrabajoRepository otRepository;
    private final CoreArticuloClient coreArticuloClient;
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "findAll"})
    public Page<Operacion> findAll(Long ordenTrabajoId, LocalDate fechaDesde, LocalDate fechaHasta,
                                   String flagEstado, Pageable pageable) {
        Specification<Operacion> spec = buildSpecification(ordenTrabajoId, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "findById"})
    public Operacion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Operacion", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "create"})
    public Operacion create(Operacion entity, List<OperacionesDet> detalles) {
        OrdenTrabajo ot = validarOrdenTrabajo(entity.getOrdenTrabajoId());
        validarNroOperacionUnico(entity.getOrdenTrabajoId(), entity.getNroOperacion(), null);
        validarFechas(entity);
        validarCostosNoNegativos(entity);
        validarCamposReferencia(entity);
        validarDetalles(detalles);

        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        Operacion saved = repository.save(entity);
        guardarDetalles(saved.getId(), detalles);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "update"})
    public Operacion update(Long id, Operacion entity, List<OperacionesDet> detalles) {
        Operacion existing = findById(id);
        OrdenTrabajo ot = validarOrdenTrabajo(entity.getOrdenTrabajoId());
        validarNroOperacionUnico(entity.getOrdenTrabajoId(), entity.getNroOperacion(), id);
        validarFechas(entity);
        validarCostosNoNegativos(entity);
        validarCamposReferencia(entity);
        validarDetalles(detalles);

        existing.setOrdenTrabajoId(entity.getOrdenTrabajoId());
        existing.setNroOperacion(entity.getNroOperacion());
        existing.setLaborId(entity.getLaborId());
        existing.setEjecutorId(entity.getEjecutorId());
        existing.setEntidadContribuyenteId(entity.getEntidadContribuyenteId());
        existing.setCentrosCostoId(entity.getCentrosCostoId());
        existing.setUnidadMedidaId(entity.getUnidadMedidaId());
        existing.setDescripcion(entity.getDescripcion());
        existing.setNroPersonas(entity.getNroPersonas());
        existing.setFecInicioEstimado(entity.getFecInicioEstimado());
        existing.setFecInicio(entity.getFecInicio());
        existing.setFecFin(entity.getFecFin());
        existing.setDiasParaInicio(entity.getDiasParaInicio());
        existing.setDiasDuracionProy(entity.getDiasDuracionProy());
        existing.setDiasHolgura(entity.getDiasHolgura());
        existing.setCantidadProyectada(entity.getCantidadProyectada());
        existing.setCantidadReal(entity.getCantidadReal());
        existing.setCostoUnitario(entity.getCostoUnitario());
        existing.setCostoProyectado(entity.getCostoProyectado());
        existing.setObservacion(entity.getObservacion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        Operacion saved = repository.save(existing);
        sincronizarDetalles(saved.getId(), detalles);
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "activate"})
    public Operacion activate(Long id) {
        Operacion existing = findById(id);
        if ("1".equals(existing.getFlagEstado())) {
            throw new BusinessException("La operación ya se encuentra activa",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_CONFLICTO_ESTADO);
        }
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "deactivate"})
    public Operacion deactivate(Long id) {
        Operacion existing = findById(id);
        if ("0".equals(existing.getFlagEstado())) {
            throw new BusinessException("La operación ya se encuentra inactiva",
                    HttpStatus.CONFLICT, ProduccionErrorCodes.OT_CONFLICTO_ESTADO);
        }
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operacion", "operation", "delete"})
    public void delete(Long id) {
        Operacion existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(existing);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "operaciones_det", "operation", "findByOperacion"})
    public List<OperacionesDet> findDetalles(Long operacionId) {
        return detRepository.findByOperacionIdOrderByIdAsc(operacionId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "operaciones_det", "operation", "addDetalles"})
    public List<OperacionesDet> addDetalles(Long operacionId, List<OperacionesDet> detalles) {
        findById(operacionId);
        validarDetalles(detalles);
        guardarDetalles(operacionId, detalles);
        return detRepository.findByOperacionIdOrderByIdAsc(operacionId);
    }

    // ───────────────────────── helpers ─────────────────────────

    private void guardarDetalles(Long operacionId, List<OperacionesDet> detalles) {
        if (detalles == null) return;
        for (OperacionesDet det : detalles) {
            det.setOperacionId(operacionId);
            det.setCreatedBy(TenantContext.getUsuarioId());
            detRepository.save(det);
        }
    }

    private void sincronizarDetalles(Long operacionId, List<OperacionesDet> detalles) {
        detRepository.deleteByOperacionId(operacionId);
        guardarDetalles(operacionId, detalles);
    }

    private OrdenTrabajo validarOrdenTrabajo(Long ordenTrabajoId) {
        OrdenTrabajo ot = otRepository.findById(ordenTrabajoId).orElse(null);
        if (ot == null || !"1".equals(ot.getFlagEstado())) {
            throw new BusinessException("La orden de trabajo no existe o está inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OPERACION_LABOR_INEXISTENTE);
        }
        return ot;
    }

    private void validarNroOperacionUnico(Long ordenTrabajoId, Integer nroOperacion, Long excludeId) {
        if (nroOperacion == null) return;
        String sql = "SELECT COUNT(*)::int FROM produccion.operacion WHERE orden_trabajo_id = :otId AND nro_operacion = :nro";
        if (excludeId != null) {
            sql += " AND id <> :excludeId";
        }
        var query = entityManager.createNativeQuery(sql)
                .setParameter("otId", ordenTrabajoId)
                .setParameter("nro", nroOperacion);
        if (excludeId != null) {
            query.setParameter("excludeId", excludeId);
        }
        Integer count = (Integer) query.getSingleResult();
        if (count != null && count > 0) {
            throw new BusinessException("El nro de operación " + nroOperacion + " está duplicado dentro de la orden de trabajo",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_NRO_OPERACION_DUPLICADO);
        }
    }

    private void validarFechas(Operacion entity) {
        if (entity.getFecInicio() != null && entity.getFecFin() != null
                && entity.getFecFin().isBefore(entity.getFecInicio())) {
            throw new BusinessException("La fecha de fin no puede ser anterior a la fecha de inicio",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_FECHA_FIN_INVALIDA);
        }
    }

    private void validarCostosNoNegativos(Operacion entity) {
        if (entity.getCostoUnitario() != null && entity.getCostoUnitario().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("Costo unitario no puede ser negativo",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_COSTO_NEGATIVO);
        }
        if (entity.getCostoProyectado() != null && entity.getCostoProyectado().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("Costo proyectado no puede ser negativo",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_COSTO_NEGATIVO);
        }
        if (entity.getCantidadProyectada() != null && entity.getCantidadProyectada().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("Cantidad proyectada no puede ser negativa",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_CANTIDAD_NEGATIVA);
        }
        if (entity.getCantidadReal() != null && entity.getCantidadReal().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("Cantidad real no puede ser negativa",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_CANTIDAD_NEGATIVA);
        }
    }

    private void validarCamposReferencia(Operacion entity) {
        validarLaborExiste(entity.getLaborId());
        validarEjecutorExiste(entity.getEjecutorId());
        validarEntidadContribuyente(entity.getEntidadContribuyenteId());
        validarCentrosCosto(entity.getCentrosCostoId());
        validarUnidadMedida(entity.getUnidadMedidaId());
    }

    private void validarLaborExiste(Long laborId) {
        if (laborId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.labor WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", laborId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La labor no existe o está inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_LABOR_INEXISTENTE);
        }
    }

    private void validarEjecutorExiste(Long ejecutorId) {
        if (ejecutorId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM produccion.ejecutor WHERE id = :id AND flag_estado = '1'")
                .setParameter("id", ejecutorId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("El ejecutor no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_EJECUTOR_INEXISTENTE);
        }
    }

    private void validarEntidadContribuyente(Long entidadId) {
        if (entidadId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM core.entidad_contribuyente WHERE id = :id")
                .setParameter("id", entidadId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La entidad contribuyente no existe o está inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_ENTIDAD_INEXISTENTE);
        }
    }

    private void validarCentrosCosto(Long centrosCostoId) {
        if (centrosCostoId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM contabilidad.centros_costo WHERE id = :id")
                .setParameter("id", centrosCostoId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("El centro de costo no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_CENTROS_COSTO_INEXISTENTE);
        }
    }

    private void validarUnidadMedida(Long unidadMedidaId) {
        if (unidadMedidaId == null) return;
        Integer count = (Integer) entityManager.createNativeQuery(
                "SELECT COUNT(*)::int FROM core.unidad_medida WHERE id = :id")
                .setParameter("id", unidadMedidaId)
                .getSingleResult();
        if (count == null || count == 0) {
            throw new BusinessException("La unidad de medida no existe o está inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_UNIDAD_MEDIDA_INEXISTENTE);
        }
    }

    private void validarDetalles(List<OperacionesDet> detalles) {
        if (detalles == null) return;
        for (OperacionesDet det : detalles) {
            validarArticuloExiste(det.getArticuloId());
            validarCantidadPositiva(det.getCantidadRequerida());
        }
    }

    private void validarArticuloExiste(Long articuloId) {
        if (articuloId == null) return;
        try {
            var response = coreArticuloClient.obtenerPorId(articuloId);
            if (!response.isSuccess() || response.getData() == null) {
                throw new BusinessException("El artículo no existe",
                        HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_ARTICULO_INEXISTENTE);
            }
        } catch (FeignException e) {
            throw new BusinessException("El artículo no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, ProduccionErrorCodes.OT_ARTICULO_INEXISTENTE);
        }
    }

    private void validarCantidadPositiva(BigDecimal cantidad) {
        if (cantidad != null && cantidad.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("La cantidad requerida debe ser mayor a 0",
                    HttpStatus.BAD_REQUEST, ProduccionErrorCodes.OT_CANTIDAD_INVALIDA);
        }
    }

    private Specification<Operacion> buildSpecification(Long ordenTrabajoId, LocalDate fechaDesde,
                                                        LocalDate fechaHasta, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (ordenTrabajoId != null) {
                predicates.add(cb.equal(root.get("ordenTrabajoId"), ordenTrabajoId));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecInicio"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecInicio"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    // ───────────────────────── enrichment ─────────────────────────

    @Override
    public void enrich(OperacionResponse response) {
        if (response == null) return;
        enrichCodigoOT(response);
        if (response.getDetalles() != null) {
            enrichDetalles(response.getDetalles());
        }
    }

    @Override
    public void enrich(List<OperacionResponse> responses) {
        if (responses == null) return;
        responses.forEach(this::enrich);
    }

    @Override
    public void enrichDetalles(List<OperacionDetResponse> detalles) {
        if (detalles == null) return;
        doEnrichDetalles(detalles);
    }

    private void enrichCodigoOT(OperacionResponse response) {
        if (response.getOrdenTrabajoId() == null) return;
        otRepository.findById(response.getOrdenTrabajoId())
                .ifPresent(ot -> response.setOrdenTrabajoCodigo(ot.getCodigo()));
    }

    private void doEnrichDetalles(List<OperacionDetResponse> detalles) {
        for (var det : detalles) {
            enrichArticulo(det);
        }
    }

    private void enrichArticulo(OperacionDetResponse det) {
        if (det.getArticuloId() == null) return;
        try {
            var resp = coreArticuloClient.obtenerPorId(det.getArticuloId());
            if (resp.isSuccess() && resp.getData() != null) {
                det.setArticuloCodigo(resp.getData().getCodigo());
                det.setArticuloDescripcion(resp.getData().getNombre());
            }
        } catch (FeignException e) {
            log.warn("No se pudo enriquecer articulo {}: {}", det.getArticuloId(), e.getMessage());
        }
    }
}
