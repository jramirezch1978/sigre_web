package pe.restaurant.finanzas.service;

import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.CierreContableRequest;
import pe.restaurant.finanzas.dto.request.CierreMasivoRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionAsientoRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionDetAsientoRequest;
import pe.restaurant.finanzas.dto.request.RevertirCierreRequest;
import pe.restaurant.finanzas.dto.response.CierreMasivoResultadoResponse;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionResponse;
import pe.restaurant.finanzas.entity.Liquidacion;
import pe.restaurant.finanzas.entity.LiquidacionDet;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.mapper.LiquidacionMapper;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.finanzas.repository.LiquidacionRepository;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import pe.restaurant.finanzas.dto.response.DocTipoResponse;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.dto.response.MonedaResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Lógica de cierre contable de liquidaciones (HU-FIN-ADL-004).
 * Se aísla en un servicio dedicado para no impactar el {@link LiquidacionService}
 * vigente (cierre/anulación simples), evitando conflictos con otros desarrollos.
 *
 * Cubre, sin modificar la base de datos:
 *  - Listado con filtros del servidor.
 *  - Cierre contable: cálculo de saldo a devolver/regularizar + asiento de cierre + fecha de cierre.
 *  - Reversión de cierre (reapertura controlada con motivo) anulando el asiento.
 *  - Cierre masivo con resultado individual por liquidación.
 *
 * Quedan fuera por requerir infraestructura inexistente (no por la BD):
 *  - Validación de rol (no hay roles en TenantContext ni @PreAuthorize en el módulo).
 *  - Validación de período contable abierto (no existe contrato en ContabilidadClient).
 *  - Auditoría con IP/Acción (no hay almacenamiento ni IP en el contexto).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LiquidacionCierreService {

    private static final String ESTADO_ACTIVA = "1";
    private static final String ESTADO_CERRADA = "2";
    /** Aprobada (HU-FIN-OPE-004): también puede pasar al cierre contable, que genera el asiento. */
    private static final String ESTADO_APROBADA = "4";

    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper mapper;
    private final ContabilidadClient contabilidadClient;
    private final CoreMaestrosClient coreMaestrosClient;
    private final PermisoCierreValidator permisoValidator;

    /** Referencia a sí mismo para que el cierre masivo invoque cerrarContable a través del proxy
     *  transaccional (REQUIRES_NEW) y cada liquidación se confirme/revierta de forma independiente. */
    @Autowired
    @Lazy
    private LiquidacionCierreService self;

    // ------------------------------------------------------------------
    // 1) Listado con filtros (servidor)
    // ------------------------------------------------------------------
    @Transactional(readOnly = true)
    public Page<LiquidacionResponse> listarFiltrado(
            String estado,
            Long solicitudGiroId,
            Long proveedorId,
            Long monedaId,
            Long sucursalId,
            LocalDate fechaRegistroDesde,
            LocalDate fechaRegistroHasta,
            LocalDate fechaLiquidacionDesde,
            LocalDate fechaLiquidacionHasta,
            Pageable pageable) {

        Specification<Liquidacion> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (estado != null && !estado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), estado));
            }
            if (solicitudGiroId != null) {
                predicates.add(cb.equal(root.get("solicitudGiroId"), solicitudGiroId));
            }
            if (proveedorId != null) {
                predicates.add(cb.equal(root.get("proveedorId"), proveedorId));
            }
            if (monedaId != null) {
                predicates.add(cb.equal(root.get("monedaId"), monedaId));
            }
            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (fechaRegistroDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaRegistro"), fechaRegistroDesde));
            }
            if (fechaRegistroHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaRegistro"), fechaRegistroHasta));
            }
            if (fechaLiquidacionDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaLiquidacion"), fechaLiquidacionDesde));
            }
            if (fechaLiquidacionHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaLiquidacion"), fechaLiquidacionHasta));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<LiquidacionResponse> page = repository.findAll(spec, pageable).map(mapper::toResponse);
        enriquecerMaestros(page.getContent());
        return page;
    }

    /**
     * Completa los campos de solo lectura {@code monedaCodigo}, {@code proveedorRazonSocial} y
     * {@code docTipoCodigo} consultando ms-core-maestros. Usa una caché por id distinto para no
     * generar N+1 y es best-effort: si un maestro falla, el campo queda null y solo se loguea,
     * para no romper el listado.
     */
    private void enriquecerMaestros(List<LiquidacionResponse> items) {
        if (items == null || items.isEmpty()) {
            return;
        }
        Map<Long, String> monedaCache = new HashMap<>();
        Map<Long, EntidadContribuyenteResponse> proveedorCache = new HashMap<>();
        Map<Long, String> docTipoCache = new HashMap<>();

        for (LiquidacionResponse r : items) {
            if (r.getMonedaId() != null && r.getMonedaCodigo() == null) {
                r.setMonedaCodigo(monedaCache.computeIfAbsent(r.getMonedaId(), this::resolverMonedaCodigo));
            }
            if (r.getProveedorId() != null && r.getProveedorRazonSocial() == null) {
                EntidadContribuyenteResponse prov = proveedorCache.computeIfAbsent(r.getProveedorId(), this::resolverProveedor);
                if (prov != null) {
                    r.setProveedorRazonSocial(prov.getRazonSocial());
                    r.setProveedorNroDocumento(prov.getNumeroDocumento());
                }
            }
            if (r.getDocTipoId() != null && r.getDocTipoCodigo() == null) {
                r.setDocTipoCodigo(docTipoCache.computeIfAbsent(r.getDocTipoId(), this::resolverDocTipoCodigo));
            }
        }
    }

    private String resolverMonedaCodigo(Long id) {
        try {
            MonedaResponse m = datos(coreMaestrosClient.obtenerMonedaPorId(id));
            return m != null ? m.getCodigo() : null;
        } catch (RuntimeException e) {
            log.warn("No se pudo resolver la moneda {} para el listado de liquidaciones: {}", id, e.getMessage());
            return null;
        }
    }

    private EntidadContribuyenteResponse resolverProveedor(Long id) {
        try {
            return datos(coreMaestrosClient.obtenerEntidadPorId(id));
        } catch (RuntimeException ex) {
            log.warn("No se pudo resolver el proveedor {} para el listado de liquidaciones: {}", id, ex.getMessage());
            return null;
        }
    }

    private String resolverDocTipoCodigo(Long id) {
        try {
            DocTipoResponse d = datos(coreMaestrosClient.obtenerDocTipoPorId(id));
            return d != null ? d.getCodigo() : null;
        } catch (RuntimeException e) {
            log.warn("No se pudo resolver el tipo de documento {} para el listado de liquidaciones: {}", id, e.getMessage());
            return null;
        }
    }

    private <T> T datos(pe.restaurant.common.dto.ApiResponse<T> respuesta) {
        return respuesta != null ? respuesta.getData() : null;
    }

    // ------------------------------------------------------------------
    // 2) Cierre contable completo
    // ------------------------------------------------------------------
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public LiquidacionDetalleResponse cerrarContable(Long id, CierreContableRequest request) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_CERRAR);

        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        // Pueden cerrarse contablemente las liquidaciones Activas (1) o ya Aprobadas (4):
        // la aprobación de rendición (HU-FIN-OPE-004) "habilita" el asiento, que se genera aquí.
        if (!ESTADO_ACTIVA.equals(entity.getFlagEstado())
                && !ESTADO_APROBADA.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden cerrar liquidaciones activas o aprobadas",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }

        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }
        if (entity.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                    "Los detalles no cuadran con el importe neto",
                    FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN);
        }

        // Saldo a devolver (positivo) / por regularizar (negativo) = monto adelanto - total gastado
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(entity.getSolicitudGiroId()).orElse(null);
        if (solicitudGiro != null && solicitudGiro.getMonto() != null) {
            entity.setSaldo(solicitudGiro.getMonto().subtract(sumaDetalles));
        }

        // Fecha de cierre: se fija ANTES de validar período y generar el asiento
        if (request.getFechaLiquidacion() != null) {
            entity.setFechaLiquidacion(request.getFechaLiquidacion());
        } else if (entity.getFechaLiquidacion() == null) {
            entity.setFechaLiquidacion(LocalDate.now());
        }

        // Nota: la validación de período abierto la realiza el alta del asiento en
        // ms-contabilidad (rechaza períodos cerrados). No se pre-valida aquí para no
        // depender de un endpoint dedicado en ms-contabilidad.

        // Asiento contable de cierre (obligatorio según HU)
        Long asientoId = generarAsientoCierre(entity, request.getGlosa());
        entity.setCntblAsientoId(asientoId);

        entity.setFlagEstado(ESTADO_CERRADA);
        if (request.getObservacion() != null && !request.getObservacion().isEmpty()) {
            entity.setObservacion(request.getObservacion());
        }
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        try {
            repository.saveAndFlush(entity);
        } catch (RuntimeException e) {
            // Compensación: si el asiento se creó pero el cierre local falla, anular el asiento.
            if (asientoId != null) {
                anularAsientoSilencioso(asientoId);
            }
            throw e;
        }

        return mapper.toDetalleResponse(entity);
    }

    // ------------------------------------------------------------------
    // 3) Reversión de cierre (reapertura controlada)
    // ------------------------------------------------------------------
    @Transactional
    public LiquidacionDetalleResponse revertirCierre(Long id, RevertirCierreRequest request) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_ANULAR);

        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        if (!ESTADO_CERRADA.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden revertir liquidaciones cerradas",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }

        if (entity.getCntblAsientoId() != null) {
            try {
                contabilidadClient.anularAsiento(entity.getCntblAsientoId());
            } catch (feign.FeignException e) {
                throw new BusinessException(
                        mensajeError(e, "No se pudo anular el asiento de cierre en contabilidad"),
                        HttpStatus.SERVICE_UNAVAILABLE,
                        FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD);
            }
            entity.setCntblAsientoId(null);
        }

        entity.setFlagEstado(ESTADO_ACTIVA);
        entity.setObservacion(truncar("[REAPERTURA] " + request.getMotivo(), 200));
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        return mapper.toDetalleResponse(entity);
    }

    // ------------------------------------------------------------------
    // 4) Cierre masivo (cada liquidación en su propia transacción)
    // ------------------------------------------------------------------
    public CierreMasivoResultadoResponse cerrarMasivo(CierreMasivoRequest request) {
        permisoValidator.validar(PermisoCierreValidator.ACCION_PROCESAR);

        CierreMasivoResultadoResponse resultado = new CierreMasivoResultadoResponse();
        List<CierreMasivoResultadoResponse.Item> items = new ArrayList<>();
        int exitosas = 0;
        int fallidas = 0;

        for (Long id : request.getLiquidacionIds()) {
            CierreContableRequest individual = new CierreContableRequest(
                    request.getFechaLiquidacion(), request.getGlosa(), request.getObservacion());
            try {
                self.cerrarContable(id, individual);
                items.add(new CierreMasivoResultadoResponse.Item(id, true, "Cerrada"));
                exitosas++;
            } catch (RuntimeException e) {
                log.warn("Cierre masivo: falló la liquidación {}: {}", id, e.getMessage());
                items.add(new CierreMasivoResultadoResponse.Item(id, false, e.getMessage()));
                fallidas++;
            }
        }

        resultado.setTotalProcesadas(request.getLiquidacionIds().size());
        resultado.setExitosas(exitosas);
        resultado.setFallidas(fallidas);
        resultado.setResultados(items);
        return resultado;
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------
    private Long generarAsientoCierre(Liquidacion entity, String glosa) {
        List<LiquidacionDet> detalles = detRepository.findByLiquidacionIdAndFlagEstado(entity.getId(), ESTADO_ACTIVA);

        List<LiquidacionDetAsientoRequest> detallesAsiento = detalles.stream()
                .map(d -> LiquidacionDetAsientoRequest.builder()
                        .id(d.getId())
                        .item(d.getItem())
                        .conceptoFinancieroId(d.getConceptoFinancieroId())
                        .cntasPagarId(d.getCntasPagarId())
                        .cntasCobrarId(d.getCntasCobrarId())
                        .centrosCostoId(d.getCentrosCostoId())
                        .monedaId(d.getMonedaId())
                        .importe(d.getImporte())
                        .importeRetenido(d.getImporteRetenido())
                        .glosa(glosa)
                        .build())
                .collect(Collectors.toList());

        LiquidacionAsientoRequest asientoRequest = LiquidacionAsientoRequest.builder()
                .id(entity.getId())
                .solicitudGiroId(entity.getSolicitudGiroId())
                .sucursalId(entity.getSucursalId())
                .proveedorId(entity.getProveedorId())
                .fechaRegistro(fechaReferencia(entity))
                .monedaId(entity.getMonedaId())
                .conceptoFinancieroId(entity.getConceptoFinancieroId())
                .importeNeto(entity.getImporteNeto())
                .tasaCambio(entity.getTasaCambio())
                .ano(anioContable(entity))
                .mes(mesContable(entity))
                .cntblLibroId(entity.getCntblLibroId())
                .observacion(glosa != null ? glosa : entity.getObservacion())
                .detalles(detallesAsiento)
                .build();

        try {
            log.info("Generando asiento de cierre para liquidación {}", entity.getId());
            GenerarAsientoResponse asiento =
                    contabilidadClient.generarAsientoLiquidacionGiro(asientoRequest).getData();
            return asiento != null ? asiento.getAsientoId() : null;
        } catch (feign.FeignException.UnprocessableEntity e) {
            throw new BusinessException(
                    mensajeError(e, "Asiento de cierre rechazado por contabilidad"),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    FinanzasErrorCodes.CONTABILIDAD_INVALIDA);
        } catch (feign.FeignException e) {
            throw new BusinessException(
                    mensajeError(e, "Error al comunicarse con contabilidad para el asiento de cierre"),
                    HttpStatus.SERVICE_UNAVAILABLE,
                    FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD);
        }
    }

    private LocalDate fechaReferencia(Liquidacion entity) {
        if (entity.getFechaLiquidacion() != null) {
            return entity.getFechaLiquidacion();
        }
        return entity.getFechaRegistro() != null ? entity.getFechaRegistro() : LocalDate.now();
    }

    private Integer anioContable(Liquidacion entity) {
        return entity.getAnio() != null ? entity.getAnio() : fechaReferencia(entity).getYear();
    }

    private Integer mesContable(Liquidacion entity) {
        return entity.getMes() != null ? entity.getMes() : fechaReferencia(entity).getMonthValue();
    }

    private void anularAsientoSilencioso(Long asientoId) {
        try {
            contabilidadClient.anularAsiento(asientoId);
            log.info("Asiento {} anulado en compensación de cierre", asientoId);
        } catch (Exception ex) {
            log.error("Error crítico: no se pudo anular el asiento {} en compensación", asientoId, ex);
        }
    }

    private String mensajeError(feign.FeignException e, String fallback) {
        log.error("{}: {}", fallback, e.getMessage());
        return fallback;
    }

    private String truncar(String valor, int max) {
        if (valor == null) {
            return null;
        }
        return valor.length() > max ? valor.substring(0, max) : valor;
    }
}
