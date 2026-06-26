package pe.restaurant.finanzas.service;

import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.LiquidacionAdelantoRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionRequest;
import pe.restaurant.finanzas.dto.response.LiquidacionAdelantoResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionAdelantoResumenResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.PaisResponse;
import pe.restaurant.finanzas.dto.response.SucursalResponse;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.entity.Liquidacion;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.enums.TipoAdelanto;
import pe.restaurant.finanzas.mapper.LiquidacionMapper;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.finanzas.repository.LiquidacionRepository;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Liquidación de adelantos por Tipo de Adelanto (Proveedor / Colaborador), HU-FIN-ADL-003.
 *
 * <p>Se aísla en un servicio propio para NO impactar {@link LiquidacionService} (alta/edición
 * genérica), {@link LiquidacionAprobacionService} (aprobar/rechazar/observar) ni
 * {@link LiquidacionCierreService} (cierre contable), siguiendo el patrón no invasivo ya usado
 * en el módulo.
 *
 * <p>Todo se resuelve SIN tocar la base de datos:
 * <ul>
 *   <li>El Tipo de Adelanto (P/C) se persiste en la columna existente {@code tipo_liquidacion}.</li>
 *   <li>El beneficiario es {@code proveedor_id} (Proveedor) o el {@code solicitante_id} de la
 *       solicitud de giro (Colaborador, derivado: no hay columna propia).</li>
 *   <li>El estado Borrador se modela sobre {@code flag_estado} con el valor {@code 6}, que no
 *       colisiona con los ya usados (0=Anulada, 1=Pendiente, 2=Cerrada, 3=Observada,
 *       4=Aprobada, 5=Rechazada).</li>
 *   <li>El Saldo a Devolver/Regularizar se calcula en tiempo real y se guarda en {@code saldo}.</li>
 * </ul>
 *
 * <p>El alta delega en {@link LiquidacionService#crearLiquidacion} para reutilizar la
 * numeración, el cuadre de detalles, la auditoría y la validación de la solicitud de giro.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LiquidacionAdelantoService {

    public static final String ESTADO_PENDIENTE = "1";
    public static final String ESTADO_BORRADOR = "6";

    private final LiquidacionService liquidacionService;
    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper mapper;
    private final CoreMaestrosClient coreMaestrosClient;

    // ------------------------------------------------------------------
    // Alta de liquidación de adelanto (Proveedor / Colaborador)
    // ------------------------------------------------------------------
    @Transactional
    public LiquidacionAdelantoResponse crearAdelanto(LiquidacionAdelantoRequest request) {
        TipoAdelanto tipo = TipoAdelanto.fromCodigo(request.getTipoAdelanto());
        if (tipo == null) {
            throw new BusinessException(
                    "El tipo de adelanto debe ser 'P' (Proveedor) o 'C' (Colaborador)",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }

        if (tipo == TipoAdelanto.PROVEEDOR && request.getProveedorId() == null) {
            throw new BusinessException(
                    "El proveedor es obligatorio para un adelanto de tipo Proveedor",
                    FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO);
        }

        // Reutiliza el alta vigente (numeración, cuadre de detalles, validación de solicitud, auditoría).
        LiquidacionRequest base = construirLiquidacionRequest(request, tipo);
        LiquidacionDetalleResponse creada = liquidacionService.crearLiquidacion(base);

        Liquidacion entity = repository.findById(creada.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", creada.getId()));

        // Saldo a devolver/regularizar en tiempo real desde la creación.
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(entity.getSolicitudGiroId()).orElse(null);
        if (solicitudGiro != null && solicitudGiro.getMonto() != null) {
            entity.setSaldo(solicitudGiro.getMonto().subtract(totalGastado(entity.getId())));
        }

        // Borrador (6) o Enviada para Revisión / Pendiente (1).
        entity.setFlagEstado(request.isBorrador() ? ESTADO_BORRADOR : ESTADO_PENDIENTE);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        log.info("Liquidación de adelanto {} creada (tipo={}, estado={})",
                entity.getId(), tipo.getCodigo(), entity.getFlagEstado());
        return construirRespuesta(entity, solicitudGiro);
    }

    // ------------------------------------------------------------------
    // Enviar para Revisión (Borrador -> Pendiente)
    // ------------------------------------------------------------------
    @Transactional
    public LiquidacionAdelantoResponse enviarARevision(Long id) {
        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));

        if (!ESTADO_BORRADOR.equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden enviar a revisión liquidaciones en estado Borrador",
                    FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO);
        }

        entity.setFlagEstado(ESTADO_PENDIENTE);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(entity);

        log.info("Liquidación de adelanto {} enviada para revisión", id);
        return construirRespuesta(entity, null);
    }

    // ------------------------------------------------------------------
    // Detalle enriquecido
    // ------------------------------------------------------------------
    @Transactional(readOnly = true)
    public LiquidacionAdelantoResponse obtenerAdelanto(Long id) {
        Liquidacion entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        return construirRespuesta(entity, null);
    }

    // ------------------------------------------------------------------
    // Listado con filtro por Tipo de Adelanto (+ estado, beneficiario, fechas, etc.)
    // ------------------------------------------------------------------
    @Transactional(readOnly = true)
    public Page<LiquidacionAdelantoResumenResponse> listarAdelantos(
            String tipoAdelanto,
            String estado,
            Long solicitudGiroId,
            Long proveedorId,
            Long monedaId,
            Long sucursalId,
            LocalDate fechaRegistroDesde,
            LocalDate fechaRegistroHasta,
            Pageable pageable) {

        final String tipoCod = (tipoAdelanto != null && !tipoAdelanto.isBlank())
                ? tipoAdelanto.trim().toUpperCase() : null;

        Specification<Liquidacion> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (tipoCod != null) {
                predicates.add(cb.equal(cb.upper(root.get("tipoLiquidacion")), tipoCod));
            }
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
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return repository.findAll(spec, pageable).map(this::toResumen);
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------
    private LiquidacionRequest construirLiquidacionRequest(LiquidacionAdelantoRequest r, TipoAdelanto tipo) {
        LiquidacionRequest lr = new LiquidacionRequest();
        lr.setSolicitudGiroId(r.getSolicitudGiroId());
        lr.setNroLiquidacion(r.getNroLiquidacion());
        lr.setSucursalId(r.getSucursalId());
        lr.setDocTipoId(r.getDocTipoId());
        // El proveedor solo aplica al adelanto de Proveedor; en Colaborador queda null.
        lr.setProveedorId(tipo == TipoAdelanto.PROVEEDOR ? r.getProveedorId() : null);
        lr.setFechaLiquidacion(r.getFechaLiquidacion());
        lr.setTipoLiquidacion(tipo.getCodigo());
        lr.setMonedaId(r.getMonedaId());
        lr.setConceptoFinancieroId(r.getConceptoFinancieroId());
        lr.setCntblLibroId(r.getCntblLibroId());
        lr.setImporteNeto(r.getImporteNeto());
        lr.setTasaCambio(r.getTasaCambio());
        lr.setAnio(r.getAnio());
        lr.setMes(r.getMes());
        lr.setUsuarioId(r.getUsuarioId());
        lr.setObservacion(r.getObservacion());
        lr.setDetalles(r.getDetalles());
        return lr;
    }

    /**
     * @param solicitudGiroCache solicitud ya cargada para evitar una segunda consulta; puede ser null.
     */
    private LiquidacionAdelantoResponse construirRespuesta(Liquidacion entity, SolicitudGiro solicitudGiroCache) {
        LiquidacionAdelantoResponse response = new LiquidacionAdelantoResponse();

        String tipoCodigo = entity.getTipoLiquidacion();
        TipoAdelanto tipo = TipoAdelanto.fromCodigo(tipoCodigo);
        response.setTipoAdelanto(tipoCodigo);
        response.setTipoAdelantoLabel(TipoAdelanto.etiquetaDe(tipoCodigo));
        response.setEstadoLabel(estadoLabel(entity.getFlagEstado()));

        SolicitudGiro solicitudGiro = solicitudGiroCache != null
                ? solicitudGiroCache
                : solicitudGiroRepository.findById(entity.getSolicitudGiroId()).orElse(null);

        BigDecimal montoAdelanto = solicitudGiro != null ? solicitudGiro.getMonto() : null;
        response.setMontoAdelanto(montoAdelanto);

        BigDecimal totalGastado = totalGastado(entity.getId());
        response.setTotalGastado(totalGastado);

        if (montoAdelanto != null) {
            BigDecimal saldo = montoAdelanto.subtract(totalGastado);
            if (saldo.signum() >= 0) {
                response.setSaldoDevolver(saldo);
                response.setSaldoRegularizar(BigDecimal.ZERO);
            } else {
                response.setSaldoDevolver(BigDecimal.ZERO);
                response.setSaldoRegularizar(saldo.abs());
            }
        }

        if (tipo == TipoAdelanto.COLABORADOR) {
            response.setBeneficiarioTipo(TipoAdelanto.COLABORADOR.name());
            response.setBeneficiarioId(solicitudGiro != null ? solicitudGiro.getSolicitanteId() : null);
        } else if (tipo == TipoAdelanto.PROVEEDOR) {
            response.setBeneficiarioTipo(TipoAdelanto.PROVEEDOR.name());
            response.setBeneficiarioId(entity.getProveedorId());
        }

        // Razón Social / País: solo lectura, desde maestros existentes (no rompe la operación si fallan).
        enriquecerMaestros(response, entity, tipo);

        response.setLiquidacion(mapper.toDetalleResponse(entity));
        return response;
    }

    /**
     * Completa los campos de solo lectura Razón Social y País consultando ms-core-maestros.
     * Es best-effort: cualquier fallo de comunicación deja los campos en null y solo se loguea,
     * para no impedir crear ni consultar la liquidación.
     */
    private void enriquecerMaestros(LiquidacionAdelantoResponse response, Liquidacion entity, TipoAdelanto tipo) {
        // País = país de la sucursal de la liquidación.
        if (entity.getSucursalId() != null) {
            try {
                SucursalResponse sucursal = datos(coreMaestrosClient.obtenerSucursalPorId(entity.getSucursalId()));
                if (sucursal != null && sucursal.getPaisId() != null) {
                    response.setPaisId(sucursal.getPaisId());
                    PaisResponse pais = datos(coreMaestrosClient.obtenerPaisPorId(sucursal.getPaisId()));
                    if (pais != null) {
                        response.setPais(pais.getNombre());
                    }
                }
            } catch (RuntimeException e) {
                log.warn("No se pudo resolver el País de la sucursal {} para la liquidación {}: {}",
                        entity.getSucursalId(), entity.getId(), e.getMessage());
            }
        }

        // Razón Social = razón social del proveedor beneficiario (solo aplica a adelanto de Proveedor).
        if (tipo == TipoAdelanto.PROVEEDOR && entity.getProveedorId() != null) {
            try {
                EntidadContribuyenteResponse entidad =
                        datos(coreMaestrosClient.obtenerEntidadPorId(entity.getProveedorId()));
                if (entidad != null) {
                    response.setRazonSocial(entidad.getRazonSocial());
                }
            } catch (RuntimeException e) {
                log.warn("No se pudo resolver la Razón Social del proveedor {} para la liquidación {}: {}",
                        entity.getProveedorId(), entity.getId(), e.getMessage());
            }
        }
    }

    private <T> T datos(pe.restaurant.common.dto.ApiResponse<T> respuesta) {
        return respuesta != null ? respuesta.getData() : null;
    }

    private LiquidacionAdelantoResumenResponse toResumen(Liquidacion entity) {
        LiquidacionAdelantoResumenResponse r = new LiquidacionAdelantoResumenResponse();
        r.setId(entity.getId());
        r.setSolicitudGiroId(entity.getSolicitudGiroId());
        r.setNroLiquidacion(entity.getNroLiquidacion());
        r.setTipoAdelanto(entity.getTipoLiquidacion());
        r.setTipoAdelantoLabel(TipoAdelanto.etiquetaDe(entity.getTipoLiquidacion()));
        r.setProveedorId(entity.getProveedorId());
        r.setMonedaId(entity.getMonedaId());
        r.setSucursalId(entity.getSucursalId());
        r.setImporteNeto(entity.getImporteNeto());
        r.setSaldo(entity.getSaldo());
        r.setFlagEstado(entity.getFlagEstado());
        r.setEstadoLabel(estadoLabel(entity.getFlagEstado()));
        r.setFechaRegistro(entity.getFechaRegistro());
        r.setFechaLiquidacion(entity.getFechaLiquidacion());
        return r;
    }

    private BigDecimal totalGastado(Long liquidacionId) {
        BigDecimal suma = detRepository.calcularSumaImportes(liquidacionId);
        return suma != null ? suma : BigDecimal.ZERO;
    }

    private String estadoLabel(String flagEstado) {
        if (flagEstado == null) {
            return null;
        }
        return switch (flagEstado) {
            case "0" -> "Anulada";
            case "1" -> "Pendiente";
            case "2" -> "Cerrada";
            case "3" -> "Observada";
            case "4" -> "Aprobada";
            case "5" -> "Rechazada";
            case "6" -> "Borrador";
            default -> flagEstado;
        };
    }
}
