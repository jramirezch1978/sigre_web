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
import pe.restaurant.finanzas.constants.SolicitudGiroConstants;
import pe.restaurant.finanzas.dto.request.AprobarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.GenerarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.request.OperacionMasivaGiroRequest;
import pe.restaurant.finanzas.dto.request.RechazarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.request.RechazarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.SolicitudGiroRequest;
import pe.restaurant.finanzas.dto.response.OperacionMasivaGiroResultadoResponse;
import pe.restaurant.finanzas.dto.response.OrdenGiroGeneradaResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroDetalleResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.entity.BancoCnta;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.mapper.SolicitudGiroMapper;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Lógica de <b>Generación de Órdenes de Giro</b> (HU-FIN-ADL-001), implementada
 * <b>sin modificar la base de datos</b> y sin tocar los endpoints/servicios existentes.
 *
 * <p>Reutiliza {@link SolicitudGiroService} (creación, aprobación, rechazo, anulación) y
 * la tabla {@code solicitud_giro} tal cual, agregando: forzado del tipo "O", validación de
 * monto contra el saldo del documento base, validación de cuenta bancaria activa/de la
 * sucursal, sellado del Usuario Responsable, filtros de listado, rechazo con observación
 * obligatoria y operaciones masivas.</p>
 *
 * <p><b>Transaccionalidad:</b> esta clase NO se anota {@code @Transactional} a nivel de clase
 * a propósito. Así, los métodos masivos NO abren una transacción envolvente y cada llamada a
 * {@code solicitudGiroService} (propagación REQUIRED) corre en su propia transacción y se
 * confirma/revierte de forma independiente.</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenGiroService {

    private static final String TIPO_PROVEEDOR = "P";
    private static final String TIPO_COLABORADOR = "C";

    private final SolicitudGiroService solicitudGiroService;
    private final SolicitudGiroRepository repository;
    private final SolicitudGiroMapper mapper;
    private final CuentaBancariaService cuentaBancariaService;

    // ------------------------------------------------------------------
    // 1) Generación dedicada (tipo "O" forzado + validaciones de la HU)
    // ------------------------------------------------------------------
    @Transactional
    public OrdenGiroGeneradaResponse generar(GenerarOrdenGiroRequest req) {
        String tipoBenef = (req.getTipoBeneficiario() == null || req.getTipoBeneficiario().isBlank())
                ? TIPO_PROVEEDOR
                : req.getTipoBeneficiario().toUpperCase();

        validarDocumentoBase(tipoBenef, req);
        validarMontoContraDisponible(req.getMonto(), req.getMontoDisponible());
        if (req.getCuentaBancariaId() != null) {
            validarCuentaBancaria(req.getCuentaBancariaId(), req.getSucursalId());
        }

        Long usuarioResponsableId = TenantContext.getUsuarioId();

        // Crear reutilizando el servicio existente, forzando SIEMPRE tipo "O" (no Fondo Fijo).
        SolicitudGiroRequest base = new SolicitudGiroRequest();
        base.setSucursalId(req.getSucursalId());
        base.setSolicitanteId(req.getSolicitanteId());
        base.setFecha(req.getFecha());
        base.setMonto(req.getMonto());
        base.setMotivo(req.getGlosaContable());
        base.setTipoSolicitud(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        base.setCentrosCostoId(req.getCentrosCostoId());

        SolicitudGiroDetalleResponse creada = solicitudGiroService.crearSolicitud(base);

        // Sellar el Usuario Responsable = usuario logueado (no el beneficiario). El beneficiario
        // queda en solicitanteId; createdBy debe reflejar a quien generó la orden.
        if (usuarioResponsableId != null) {
            Long creadaId = creada.getId();
            SolicitudGiro persisted = repository.findById(creadaId)
                    .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", creadaId));
            if (!usuarioResponsableId.equals(persisted.getCreatedBy())) {
                persisted.setCreatedBy(usuarioResponsableId);
                persisted = repository.save(persisted);
                creada = mapper.toDetalleResponse(persisted);
            }
        }

        OrdenGiroGeneradaResponse resp = new OrdenGiroGeneradaResponse();
        resp.setOrdenGiro(creada);
        resp.setUsuarioResponsableId(usuarioResponsableId);
        resp.setTipoBeneficiario(tipoBenef);
        resp.setOrdenCompraId(req.getOrdenCompraId());
        resp.setSolicitudAdelantoRrhhId(req.getSolicitudAdelantoRrhhId());
        resp.setNumeroDocumentoBase(req.getNumeroDocumentoBase());
        resp.setCuentaBancariaId(req.getCuentaBancariaId());
        resp.setMontoDisponible(req.getMontoDisponible());
        resp.setAdvertencia("Beneficiario detallado, OC/Solicitud origen, banco/cuenta, moneda, "
                + "tipo de cambio, forma de pago, fecha programada y asiento contable NO se "
                + "persisten: requieren ampliación de BD (ver brechas ADL-001).");
        return resp;
    }

    // ------------------------------------------------------------------
    // 2) Listado de Órdenes de Giro con filtros (solo tipo "O")
    // ------------------------------------------------------------------
    @Transactional(readOnly = true)
    public Page<SolicitudGiroResponse> listar(
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            String estado,
            Long beneficiarioId,
            Long centrosCostoId,
            Pageable pageable) {

        Specification<SolicitudGiro> spec = (root, query, cb) -> {
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
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    // ------------------------------------------------------------------
    // 3) Rechazo con observación OBLIGATORIA (no toca /rechazar existente)
    // ------------------------------------------------------------------
    public Map<String, Object> rechazarConObservacion(Long id, RechazarOrdenGiroRequest req) {
        RechazarSolicitudRequest delegate = new RechazarSolicitudRequest(req.getObservacion());
        return solicitudGiroService.rechazarSolicitud(id, delegate);
    }

    // ------------------------------------------------------------------
    // 4) Aprobación masiva (cada orden en su propia transacción)
    // ------------------------------------------------------------------
    public OperacionMasivaGiroResultadoResponse aprobarMasivo(OperacionMasivaGiroRequest req) {
        OperacionMasivaGiroResultadoResponse resultado = new OperacionMasivaGiroResultadoResponse();
        List<OperacionMasivaGiroResultadoResponse.Item> items = new ArrayList<>();
        int exitosas = 0;
        int fallidas = 0;

        for (Long id : req.getOrdenGiroIds()) {
            try {
                solicitudGiroService.aprobarSolicitud(id, new AprobarSolicitudRequest());
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, true, "Aprobada"));
                exitosas++;
            } catch (Exception e) {
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, false, e.getMessage()));
                fallidas++;
            }
        }

        resultado.setTotalProcesadas(req.getOrdenGiroIds().size());
        resultado.setExitosas(exitosas);
        resultado.setFallidas(fallidas);
        resultado.setResultados(items);
        return resultado;
    }

    // ------------------------------------------------------------------
    // 5) Anulación masiva (cada orden en su propia transacción)
    // ------------------------------------------------------------------
    public OperacionMasivaGiroResultadoResponse anularMasivo(OperacionMasivaGiroRequest req) {
        OperacionMasivaGiroResultadoResponse resultado = new OperacionMasivaGiroResultadoResponse();
        List<OperacionMasivaGiroResultadoResponse.Item> items = new ArrayList<>();
        int exitosas = 0;
        int fallidas = 0;

        for (Long id : req.getOrdenGiroIds()) {
            try {
                solicitudGiroService.anularSolicitud(id);
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, true, "Anulada"));
                exitosas++;
            } catch (Exception e) {
                items.add(new OperacionMasivaGiroResultadoResponse.Item(id, false, e.getMessage()));
                fallidas++;
            }
        }

        resultado.setTotalProcesadas(req.getOrdenGiroIds().size());
        resultado.setExitosas(exitosas);
        resultado.setFallidas(fallidas);
        resultado.setResultados(items);
        return resultado;
    }

    // ------------------------------------------------------------------
    // Validaciones privadas
    // ------------------------------------------------------------------
    private void validarDocumentoBase(String tipoBenef, GenerarOrdenGiroRequest req) {
        if (TIPO_PROVEEDOR.equals(tipoBenef)) {
            if (req.getOrdenCompraId() == null) {
                throw new BusinessException(
                        "Para beneficiario Proveedor debe indicar la Orden de Compra de origen",
                        FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
            }
        } else if (TIPO_COLABORADOR.equals(tipoBenef)) {
            if (req.getSolicitudAdelantoRrhhId() == null) {
                throw new BusinessException(
                        "Para beneficiario Colaborador debe indicar la Solicitud de Adelanto de RR.HH. de origen",
                        FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
            }
        } else {
            throw new BusinessException(
                    "tipoBeneficiario debe ser P (Proveedor) o C (Colaborador)",
                    FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
        }
    }

    private void validarMontoContraDisponible(BigDecimal monto, BigDecimal disponible) {
        if (disponible != null && monto != null && monto.compareTo(disponible) > 0) {
            throw new BusinessException(
                    "El monto del giro (" + monto.toPlainString()
                            + ") supera el saldo disponible del documento base (" + disponible.toPlainString() + ")",
                    FinanzasErrorCodes.SOLICITUD_MONTO_INVALIDO);
        }
    }

    private void validarCuentaBancaria(Long cuentaBancariaId, Long sucursalId) {
        BancoCnta cuenta = cuentaBancariaService.findById(cuentaBancariaId);
        if (!"1".equals(cuenta.getFlagEstado())) {
            throw new BusinessException(
                    "La cuenta bancaria seleccionada está inactiva",
                    FinanzasErrorCodes.CUENTA_BANCARIA_NO_ACTIVA);
        }
        if (cuenta.getSucursalId() != null && sucursalId != null
                && !cuenta.getSucursalId().equals(sucursalId)) {
            throw new BusinessException(
                    "La cuenta bancaria no pertenece a la sucursal/razón social activa",
                    FinanzasErrorCodes.CUENTA_BANCARIA_NO_ACTIVA);
        }
    }
}
