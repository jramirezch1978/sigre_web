package com.sigre.compras.service.impl;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.compras.dto.*;
import com.sigre.compras.dto.CuentaPagarVinculadaResponse;
import com.sigre.compras.entity.*;
import com.sigre.compras.repository.*;
import com.sigre.compras.service.OrdenServicioCalculator;
import com.sigre.compras.service.OrdenServicioService;
import com.sigre.compras.service.OrdenServicioValidator;
import com.sigre.compras.spec.OrdenServicioSpecifications;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.ConfiguracionParametroService;

import org.springframework.data.domain.PageImpl;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OrdenServicioServiceImpl implements OrdenServicioService {

    private static final String DOC_TIPO_CODIGO_OS = "OS";

    private final OrdenServicioRepository ordenServicioRepository;
    private final NumOrdSrvRepository numOrdSrvRepository;
    private final AprobacionRepository aprobacionRepository;
    private final OsAjusteValorRepository osAjusteValorRepository;
    private final OsConformidadLogRepository osConformidadLogRepository;
    private final AsignacionOsOcRepository asignacionOsOcRepository;
    private final OrdenCompraRepository ordenCompraRepository;
    private final EntidadBancoCntaRepository entidadBancoCntaRepository;
    private final ConfiguracionParametroService configParam;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final CompradorRepository compradorRepository;
    private final ServicioCatalogoRepository servicioCatalogoRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final UsuarioRefRepository usuarioRefRepository;
    private final CntasPagarRefRepository cntasPagarRefRepository;
    private final OrdenServicioCalculator calculator;
    private final OrdenServicioValidator validator;
    private final JdbcTemplate jdbcTemplate;

    @Autowired(required = false)
    private DocTipoRefRepository docTipoRefRepository;

    @Autowired(required = false)
    private JavaMailSender mailSender;

    // ── Listar ──────────────────────────────────────────────────────────────

    @Override
    public Page<OrdenServicioResumenResponse> listar(Long sucursalId, Long proveedorId,
                                                      String flagEstado,
                                                      String codOrigen, String numero,
                                                      LocalDate fechaDesde, LocalDate fechaHasta,
                                                      Long monedaId, Long compradorId,
                                                      String flagReqServ, Long ordenTrabajoId,
                                                      String jobCodigo, Pageable pageable) {
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                sucursalId, proveedorId, flagEstado, codOrigen, numero,
                fechaDesde, fechaHasta, monedaId, compradorId, flagReqServ,
                ordenTrabajoId, jobCodigo);
        return ordenServicioRepository.findAll(spec, pageable).map(this::toResumen);
    }

    @Override
    public Page<OrdenServicioResumenResponse> pendientesAprobacion(Pageable pageable) {
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, "3",
                null, null, null, null, null, null, null, null, null);
        return ordenServicioRepository.findAll(spec, pageable).map(this::toResumen);
    }

    @Override
    public OrdenServicioDetalleResponse obtener(Long id) {
        return toDetalle(buscar(id));
    }

    // ── Crear ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse crear(OrdenServicioCabeceraRequest request) {
        Long compradorId = validator.verificarCompradorActivo();
        validator.validarCabecera(request);
        validator.validarDetalle(request.getLineas());

        OrdenServicio os = new OrdenServicio();
        aplicarCabecera(os, request);
        os.setCompradorId(compradorId);

        os.setFlagEstado("1");
        os.setCreatedBy(TenantContext.getUsuarioId());

        buscarBancoProveedor(os, request.getProveedorId(), request.getMonedaId());

        int nroItem = 1;
        for (OrdenServicioLineaRequest lr : request.getLineas()) {
            OrdenServicioDet det = mapearLinea(lr);
            det.setNroItem(nroItem++);
            os.addLinea(det);
        }

        calculator.calcularTotales(os);

        String nroOs = generarNroOs(os.getSucursalId(), os.getCodOrigen());
        os.setNroOs(nroOs);

        OrdenServicio saved = ordenServicioRepository.save(os);
        return toDetalle(saved);
    }

    // ── Actualizar ──────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse actualizar(Long id, OrdenServicioCabeceraRequest request) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado()) && !"0".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "La orden solo puede editarse en estado activo o rechazada",
                    HttpStatus.CONFLICT, "COM-125");
        }

        validator.validarCabecera(request);
        validator.validarDetalle(request.getLineas());

        Map<Long, OrdenServicioDet> lineasExistentes = os.getLineas().stream()
                .filter(l -> l.getId() != null)
                .collect(Collectors.toMap(OrdenServicioDet::getId, Function.identity()));

        aplicarCabecera(os, request);
        os.setUpdatedBy(TenantContext.getUsuarioId());
        buscarBancoProveedor(os, request.getProveedorId(), request.getMonedaId());

        os.getLineas().clear();
        int nroItem = 1;
        for (OrdenServicioLineaRequest lr : request.getLineas()) {
            OrdenServicioDet nueva = mapearLinea(lr);
            nueva.setNroItem(nroItem++);

            if (lr.getId() != null) {
                OrdenServicioDet existente = lineasExistentes.get(lr.getId());
                if (existente != null) {
                    nueva.setImpProvisionado(safe(existente.getImpProvisionado()));
                    nueva.setConformidadFecha(existente.getConformidadFecha());
                    nueva.setConformidadUsr(existente.getConformidadUsr());

                    if (existente.getConformidadFecha() != null) {
                        nueva.setImporte(existente.getImporte());
                        nueva.setServicioId(existente.getServicioId());
                    }
                }
            }

            os.addLinea(nueva);
        }

        calculator.calcularTotales(os);
        OrdenServicio saved = ordenServicioRepository.save(os);
        return toDetalle(saved);
    }

    // ── Flujo de aprobación ─────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse enviarAprobacion(Long id) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado()) && !"0".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede enviar a aprobación una OS activa o rechazada",
                    HttpStatus.CONFLICT, "COM-120");
        }

        validator.verificarPrecios(os);

        os.setFlagEstado("3");
        os.setUpdatedBy(TenantContext.getUsuarioId());

        registrarAprobacion(os.getId(), "ENVIADA", null, null);
        return toDetalle(ordenServicioRepository.save(os));
    }

    @Override
    @Transactional
    public OrdenServicioDetalleResponse aprobar(Long id, String observacion) {
        OrdenServicio os = buscar(id);

        if (!"3".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "La OS no está en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-121");
        }

        Long usuarioId = TenantContext.getUsuarioId();
        validator.validarAprobadorConfigurado(usuarioId, safe(os.getMontoTotal()));

        os.setFlagEstado("1");
        os.setAprobadorId(usuarioId);
        os.setFechaAprob(LocalDateTime.now());
        os.setUpdatedBy(usuarioId);

        registrarAprobacion(os.getId(), "APROBADA", usuarioId, observacion);
        return toDetalle(ordenServicioRepository.save(os));
    }

    @Override
    @Transactional
    public OrdenServicioDetalleResponse rechazar(Long id, String motivo) {
        OrdenServicio os = buscar(id);

        if (!"3".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "La OS no está en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-121");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        os.setFlagEstado("0");
        os.setUpdatedBy(usuarioId);

        registrarAprobacion(os.getId(), "RECHAZADA", usuarioId, motivo);
        return toDetalle(ordenServicioRepository.save(os));
    }

    @Override
    @Transactional
    public OrdenServicioDetalleResponse devolver(Long id, String motivo) {
        OrdenServicio os = buscar(id);

        if (!"3".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "La OS no está en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-121");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        os.setFlagEstado("1");
        os.setUpdatedBy(usuarioId);

        registrarAprobacion(os.getId(), "DEVUELTA", usuarioId, motivo);
        return toDetalle(ordenServicioRepository.save(os));
    }

    // ── Anular ──────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse anular(Long id, String motivo) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if ("0".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "La OS ya se encuentra anulada",
                    HttpStatus.CONFLICT, "COM-140");
        }

        boolean tieneConformidad = os.getLineas().stream()
                .anyMatch(l -> l.getConformidadFecha() != null);
        if (tieneConformidad) {
            throw new BusinessException(
                    "No se puede anular: la OS tiene líneas con conformidad registrada",
                    HttpStatus.CONFLICT, "COM-141");
        }

        boolean tieneProvisiones = os.getLineas().stream()
                .anyMatch(l -> l.getImpProvisionado() != null
                        && l.getImpProvisionado().signum() > 0);
        if (tieneProvisiones) {
            throw new BusinessException(
                    "No se puede anular: la OS tiene importes provisionados",
                    HttpStatus.CONFLICT, "COM-142");
        }

        validator.verificarSinProvisionesAprovisionamiento(id);
        validator.verificarSinGastosFlota(id);

        Long usuarioId = TenantContext.getUsuarioId();

        os.setFlagEstado("0");
        os.setMotivoAnulacion(motivo);
        os.setUpdatedBy(usuarioId);

        for (OrdenServicioDet linea : os.getLineas()) {
            linea.setFlagEstado("0");
            linea.setUpdatedBy(usuarioId);
        }

        calculator.calcularTotales(os);
        return toDetalle(ordenServicioRepository.save(os));
    }

    // ── Cerrar ──────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse cerrar(Long id) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if ("0".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede cerrar una OS anulada",
                    HttpStatus.CONFLICT, "COM-150");
        }

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede cerrar una OS activa",
                    HttpStatus.CONFLICT, "COM-151");
        }

        if ("1".equals(os.getFlagSolicitaActa())) {
            boolean todasConConformidad = os.getLineas().stream()
                    .filter(l -> !"0".equals(l.getFlagEstado()))
                    .allMatch(l -> l.getConformidadFecha() != null);
            if (!todasConConformidad) {
                throw new BusinessException(
                        "Todas las líneas activas deben tener conformidad antes de cerrar",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-152");
            }
        }

        Long usuarioId = TenantContext.getUsuarioId();

        os.setFlagEstado("2");
        os.setUpdatedBy(usuarioId);

        for (OrdenServicioDet linea : os.getLineas()) {
            if (!"0".equals(linea.getFlagEstado())) {
                linea.setFlagEstado("2");
                linea.setUpdatedBy(usuarioId);
            }
        }

        return toDetalle(ordenServicioRepository.save(os));
    }

    // ── Conformidad por línea ───────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse registrarConformidad(Long id, Long lineaId,
                                                              ConformidadOsRequest request) {
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede registrar conformidad en OS activa",
                    HttpStatus.CONFLICT, "COM-160");
        }

        OrdenServicioDet linea = os.getLineas().stream()
                .filter(l -> l.getId().equals(lineaId))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "Línea id " + lineaId + " no pertenece a esta OS",
                        HttpStatus.BAD_REQUEST, "COM-161"));

        if ("0".equals(linea.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede dar conformidad a una línea inactiva",
                    HttpStatus.CONFLICT, "COM-162");
        }

        if (linea.getConformidadFecha() != null) {
            throw new BusinessException(
                    "La línea ya tiene conformidad registrada",
                    HttpStatus.CONFLICT, "COM-163");
        }

        Long usuarioId = TenantContext.getUsuarioId();
        linea.setConformidadFecha(OffsetDateTime.now());
        linea.setConformidadUsr(usuarioId);
        linea.setUpdatedBy(usuarioId);

        validator.actualizarOperacionesConformidad(linea.getOperacionesDetId(), safe(linea.getSubtotal()));

        OsConformidadLog logEntry = new OsConformidadLog();
        logEntry.setOrdenServicioDetId(lineaId);
        logEntry.setAccion("CONFORMIDAD");
        logEntry.setUsuarioId(usuarioId);
        logEntry.setObservacion(request != null ? request.getObservacion() : null);
        osConformidadLogRepository.save(logEntry);

        return toDetalle(ordenServicioRepository.save(os));
    }

    @Override
    @Transactional
    public OrdenServicioDetalleResponse revertirConformidad(Long id, Long lineaId,
                                                             ConformidadOsRequest request) {
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede revertir conformidad en OS activa",
                    HttpStatus.CONFLICT, "COM-160");
        }

        OrdenServicioDet linea = os.getLineas().stream()
                .filter(l -> l.getId().equals(lineaId))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "Línea id " + lineaId + " no pertenece a esta OS",
                        HttpStatus.BAD_REQUEST, "COM-161"));

        if (linea.getConformidadFecha() == null) {
            throw new BusinessException(
                    "La línea no tiene conformidad registrada para revertir",
                    HttpStatus.CONFLICT, "COM-164");
        }

        if (linea.getImpProvisionado() != null && linea.getImpProvisionado().signum() > 0) {
            throw new BusinessException(
                    "No se puede revertir: la línea tiene importes provisionados",
                    HttpStatus.CONFLICT, "COM-165");
        }

        Long usuarioId = TenantContext.getUsuarioId();
        linea.setConformidadFecha(null);
        linea.setConformidadUsr(null);
        linea.setUpdatedBy(usuarioId);

        validator.revertirOperacionesConformidad(linea.getOperacionesDetId(), safe(linea.getSubtotal()));
        validator.insertarLogDiario(id, lineaId, "DESAPROBAR_CONFORMIDAD", usuarioId,
                request != null ? request.getObservacion() : null);

        OsConformidadLog logEntry = new OsConformidadLog();
        logEntry.setOrdenServicioDetId(lineaId);
        logEntry.setAccion("REVERSION");
        logEntry.setUsuarioId(usuarioId);
        logEntry.setObservacion(request != null ? request.getObservacion() : null);
        osConformidadLogRepository.save(logEntry);

        return toDetalle(ordenServicioRepository.save(os));
    }

    // ── Ajuste de valor ─────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse ajustarValor(Long id, AjusteValorOsRequest request) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede ajustar valor en OS activa",
                    HttpStatus.CONFLICT, "COM-170");
        }

        OrdenServicioDet linea = os.getLineas().stream()
                .filter(l -> l.getId().equals(request.getLineaId()))
                .findFirst()
                .orElseThrow(() -> new BusinessException(
                        "Línea id " + request.getLineaId() + " no pertenece a esta OS",
                        HttpStatus.BAD_REQUEST, "COM-171"));

        if ("0".equals(linea.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede ajustar valor de una línea inactiva",
                    HttpStatus.CONFLICT, "COM-172");
        }

        OsAjusteValor ajuste = new OsAjusteValor();
        ajuste.setOrdenServicioDetId(linea.getId());
        ajuste.setImporteAnterior(linea.getImporte());
        ajuste.setImporteNuevo(request.getNuevoImporte());
        ajuste.setMotivo(request.getMotivo());
        ajuste.setCreatedBy(TenantContext.getUsuarioId());
        osAjusteValorRepository.save(ajuste);

        linea.setImporte(request.getNuevoImporte());
        linea.setUpdatedBy(TenantContext.getUsuarioId());

        calculator.calcularTotales(os);
        os.setUpdatedBy(TenantContext.getUsuarioId());

        return toDetalle(ordenServicioRepository.save(os));
    }

    // ── Historial de aprobaciones ───────────────────────────────────────────

    @Override
    public List<HistorialAprobacionResponse> historial(Long id) {
        buscar(id);
        return aprobacionRepository
                .findByDocTipoIdAndDocumentoIdOrderByFechaAsc(resolveDocTipoId(DOC_TIPO_CODIGO_OS), id)
                .stream()
                .map(a -> HistorialAprobacionResponse.builder()
                        .id(a.getId())
                        .nivel(a.getNivel())
                        .accion(a.getAccion())
                        .aprobadorId(a.getAprobadorId())
                        .comentario(a.getComentario())
                        .fecha(a.getFecha())
                        .build())
                .collect(Collectors.toList());
    }

    // ── Saldo pendiente ─────────────────────────────────────────────────────

    @Override
    public OrdenServicioSaldoPendienteResponse saldoPendiente(Long id) {
        OrdenServicio os = buscar(id);

        BigDecimal totalImporte = BigDecimal.ZERO;
        BigDecimal totalProvisionado = BigDecimal.ZERO;
        List<OrdenServicioSaldoPendienteResponse.LineaSaldo> lineasSaldo = new ArrayList<>();

        for (OrdenServicioDet l : os.getLineas()) {
            if ("0".equals(l.getFlagEstado())) continue;

            BigDecimal imp = safe(l.getSubtotal());
            BigDecimal prov = safe(l.getImpProvisionado());
            BigDecimal pend = imp.subtract(prov).max(BigDecimal.ZERO);

            totalImporte = totalImporte.add(imp);
            totalProvisionado = totalProvisionado.add(prov);

            String servCodigo = servicioCatalogoRepository.findById(l.getServicioId())
                    .map(ServicioCatalogo::getServicio)
                    .orElse(null);

            lineasSaldo.add(OrdenServicioSaldoPendienteResponse.LineaSaldo.builder()
                    .lineaId(l.getId())
                    .nroItem(l.getNroItem())
                    .servicioCodigo(servCodigo)
                    .importe(imp)
                    .impProvisionado(prov)
                    .saldoPendiente(pend)
                    .tieneConformidad(l.getConformidadFecha() != null)
                    .build());
        }

        BigDecimal porcentaje = BigDecimal.ZERO;
        if (totalImporte.signum() > 0) {
            porcentaje = totalProvisionado.multiply(new BigDecimal("100"))
                    .divide(totalImporte, 2, RoundingMode.HALF_UP);
        }

        return OrdenServicioSaldoPendienteResponse.builder()
                .ordenServicioId(os.getId())
                .nroOs(os.getNroOs())
                .montoTotal(os.getMontoTotal())
                .impProvisionadoTotal(totalProvisionado)
                .saldoPendiente(totalImporte.subtract(totalProvisionado).max(BigDecimal.ZERO))
                .porcentajeProvisionado(porcentaje)
                .lineas(lineasSaldo)
                .build();
    }

    // ── Datos servicio auxiliar ──────────────────────────────────────────────

    @Override
    public DatosServicioResponse datosServicio(Long servicioId, Long proveedorId,
                                                Long monedaId, Long sucursalId) {
        validator.verificarCompradorActivo();

        ServicioCatalogo serv = servicioCatalogoRepository.findById(servicioId)
                .orElseThrow(() -> new ResourceNotFoundException("Servicio", servicioId));

        BigDecimal tasaIgv = configParam.getDecimal("CORE", "TASA_IGV", null);

        return DatosServicioResponse.builder()
                .servicioId(serv.getId())
                .servicioCodigo(serv.getServicio())
                .descripcion(serv.getDescripcion())
                .precioPactado(serv.getTarifaEstd())
                .tasaIgv(tasaIgv)
                .build();
    }

    // ── Enviar al proveedor ─────────────────────────────────────────────────

    @Override
    @Transactional
    public boolean enviarProveedor(Long id, EnviarProveedorOsRequest request) {
        validator.verificarCompradorActivo();
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede enviar al proveedor una OS activa",
                    HttpStatus.CONFLICT, "COM-180");
        }

        if (mailSender == null) {
            throw new BusinessException(
                    "El servicio de correo no está configurado",
                    HttpStatus.SERVICE_UNAVAILABLE, "COM-181");
        }

        String emailDestino = resolverEmailDestino(request, os.getProveedorId());
        if (emailDestino == null || emailDestino.isBlank()) {
            throw new BusinessException(
                    "No se encontró email del proveedor ni se proporcionó uno",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-182");
        }

        String asunto = request != null && request.getAsunto() != null
                ? request.getAsunto()
                : "Orden de Servicio " + os.getNroOs();
        String cuerpo = request != null && request.getMensaje() != null
                ? request.getMensaje()
                : "Adjunto encontrará la Orden de Servicio " + os.getNroOs() + ".";

        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setTo(emailDestino);
            helper.setSubject(asunto);
            helper.setText(cuerpo, false);
            mailSender.send(msg);
            log.info("OS {} enviada al proveedor {}", os.getNroOs(), emailDestino);
            return true;
        } catch (Exception e) {
            log.error("Error enviando OS {} al proveedor: {}", id, e.getMessage(), e);
            throw new BusinessException(
                    "Error al enviar el correo: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "COM-183");
        }
    }

    // ── Pendientes de conformidad ──────────────────────────────────────────

    @Override
    public Page<LineaConformidadResponse> pendientesConformidad(String modo, Long proveedorId,
                                                                 LocalDate fechaDesde, LocalDate fechaHasta,
                                                                 Pageable pageable) {
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, proveedorId, "1",
                null, null, fechaDesde, fechaHasta, null, null, null, null, null);
        List<OrdenServicio> ordenes = ordenServicioRepository.findAll(spec);

        boolean esAprobacion = !"DESAPROBACION".equalsIgnoreCase(modo);

        List<LineaConformidadResponse> resultado = new ArrayList<>();
        for (OrdenServicio os : ordenes) {
            os.getLineas().size();

            String provNombre = entidadContribuyenteRefRepository.findById(os.getProveedorId())
                    .map(EntidadContribuyenteRef::getNombreCompleto)
                    .orElse(null);

            for (OrdenServicioDet l : os.getLineas()) {
                if ("0".equals(l.getFlagEstado())) continue;
                boolean tieneConformidad = l.getConformidadFecha() != null;
                if (esAprobacion && tieneConformidad) continue;
                if (!esAprobacion && !tieneConformidad) continue;

                ServicioCatalogo serv = servicioCatalogoRepository.findById(l.getServicioId()).orElse(null);

                String conformidadUsrNombre = l.getConformidadUsr() != null
                        ? usuarioRefRepository.findById(l.getConformidadUsr())
                                .map(UsuarioRef::getUsername).orElse(null)
                        : null;

                resultado.add(LineaConformidadResponse.builder()
                        .ordenServicioId(os.getId())
                        .nroOs(os.getNroOs())
                        .lineaId(l.getId())
                        .nroItem(l.getNroItem())
                        .servicioId(l.getServicioId())
                        .servicioCodigo(serv != null ? serv.getServicio() : null)
                        .descripcion(l.getDescripcion())
                        .importe(l.getImporte())
                        .subtotal(l.getSubtotal())
                        .fecProyect(l.getFecProyect())
                        .conformidadFecha(l.getConformidadFecha())
                        .conformidadUsr(l.getConformidadUsr())
                        .conformidadUsrNombre(conformidadUsrNombre)
                        .proveedorNombre(provNombre)
                        .flagEstado(l.getFlagEstado())
                        .build());
            }
        }

        int start = (int) pageable.getOffset();
        int end = Math.min(start + pageable.getPageSize(), resultado.size());
        List<LineaConformidadResponse> pageContent = start >= resultado.size()
                ? List.of()
                : resultado.subList(start, end);
        return new PageImpl<>(pageContent, pageable, resultado.size());
    }

    // ── Asignar OC a OS ─────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenServicioDetalleResponse asignarOc(Long id, AsignacionOsOcRequest request) {
        OrdenServicio os = buscar(id);

        if (!"1".equals(os.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede asignar OC a una OS en estado Aprobada y activa",
                    HttpStatus.CONFLICT, "COM-190");
        }

        OrdenCompra oc = ordenCompraRepository.findById(request.getOrdenCompraId())
                .orElseThrow(() -> new ResourceNotFoundException("OrdenCompra", request.getOrdenCompraId()));

        if (!"1".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "La orden de compra debe estar en estado Aprobada",
                    HttpStatus.CONFLICT, "COM-191");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        AsignacionOsOc asignacion = new AsignacionOsOc();
        asignacion.setOrdenServicioId(os.getId());
        asignacion.setOrdenCompraId(oc.getId());
        asignacion.setCreatedBy(usuarioId);

        for (AsignacionOsOcRequest.LineaAsignacion linea : request.getLineas()) {
            AsignacionOsOcDet det = new AsignacionOsOcDet();
            det.setAsignacionOsOc(asignacion);
            det.setOrdenServicioDetId(linea.getLineaOsId());
            det.setOrdenCompraDetId(linea.getLineaOcId());
            det.setMontoAplicado(linea.getMonto());
            det.setCreatedBy(usuarioId);
            asignacion.getDetalles().add(det);
        }

        asignacionOsOcRepository.save(asignacion);
        return toDetalle(os);
    }

    // ── Obtener asignaciones ────────────────────────────────────────────────

    @Override
    public List<AsignacionOsOcRequest.LineaAsignacion> obtenerAsignaciones(Long id) {
        buscar(id);
        List<AsignacionOsOc> asignaciones = asignacionOsOcRepository.findByOrdenServicioId(id);

        List<AsignacionOsOcRequest.LineaAsignacion> resultado = new ArrayList<>();
        for (AsignacionOsOc asig : asignaciones) {
            for (AsignacionOsOcDet det : asig.getDetalles()) {
                AsignacionOsOcRequest.LineaAsignacion la = new AsignacionOsOcRequest.LineaAsignacion();
                la.setLineaOsId(det.getOrdenServicioDetId());
                la.setLineaOcId(det.getOrdenCompraDetId());
                la.setMonto(det.getMontoAplicado());
                resultado.add(la);
            }
        }
        return resultado;
    }

    @Override
    public List<CuentaPagarVinculadaResponse> cuentasPagar(Long id) {
        buscar(id);
        return cntasPagarRefRepository.findByOrdenServicioIdAndFlagEstadoOrderByFechaDesc(id, "1")
                .stream()
                .map(cp -> CuentaPagarVinculadaResponse.builder()
                        .id(cp.getId())
                        .codRelacion(cp.getCodRelacion())
                        .tipoDoc(cp.getTipoDoc())
                        .nroDoc(cp.getNroDoc())
                        .fecha(cp.getFecha())
                        .montoTotal(cp.getMontoTotal())
                        .flagEstado(cp.getFlagEstado())
                        .build())
                .collect(Collectors.toList());
    }

    // ══════════════════════════════════════════════════════════════════════════
    // Métodos privados
    // ══════════════════════════════════════════════════════════════════════════

    private OrdenServicio buscar(Long id) {
        OrdenServicio os = ordenServicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenServicio", id));
        os.getLineas().size();
        return os;
    }

    private boolean isAprobacionRequerida() {
        return configParam.getBooleano("COMPRAS", "COMPRA_APROBACION_OS", true);
    }

    private String generarNroOs(Long sucursalId, String codOrigen) {
        NumOrdSrv num = numOrdSrvRepository.findForUpdate(sucursalId, codOrigen)
                .orElseGet(() -> {
                    NumOrdSrv nuevo = new NumOrdSrv();
                    nuevo.setSucursalId(sucursalId);
                    nuevo.setCodOrigen(codOrigen);
                    nuevo.setUltNro(0L);
                    return numOrdSrvRepository.save(nuevo);
                });

        long siguiente = num.getUltNro() + 1;
        num.setUltNro(siguiente);
        numOrdSrvRepository.save(num);

        return codOrigen + "-" + String.format("%08d", siguiente);
    }

    private String resolverEmailDestino(EnviarProveedorOsRequest request, Long proveedorId) {
        if (request != null && request.getEmailDestino() != null
                && !request.getEmailDestino().isBlank()) {
            return request.getEmailDestino();
        }
        return entidadContribuyenteRefRepository.findById(proveedorId)
                .map(EntidadContribuyenteRef::getEmail)
                .orElse(null);
    }

    private void aplicarCabecera(OrdenServicio os, OrdenServicioCabeceraRequest r) {
        os.setSucursalId(r.getSucursalId());
        os.setCodOrigen(r.getCodOrigen());
        os.setProveedorId(r.getProveedorId());
        os.setNomVendedor(r.getNomVendedor());
        os.setDocTipoId(r.getDocTipoId());
        os.setFecRegistro(r.getFecRegistro());
        os.setMonedaId(r.getMonedaId());
        os.setTipoCambio(r.getTipoCambio());
        os.setFormaPagoId(r.getFormaPagoId());
        os.setFlagReqServ(r.getFlagReqServ() != null ? r.getFlagReqServ() : "0");
        os.setFlagSolicitaActa(Boolean.TRUE.equals(r.getFlagSolicitaActa()) ? "1" : "0");
        os.setOrdenTrabajoId(r.getOrdenTrabajoId());
        os.setDescripcion(r.getDescripcion());
    }

    private OrdenServicioDet mapearLinea(OrdenServicioLineaRequest lr) {
        OrdenServicioDet d = new OrdenServicioDet();
        d.setServicioId(lr.getServicioId());
        d.setDescripcion(lr.getDescripcion());
        d.setFecProyect(lr.getFecProyect());
        d.setImporte(lr.getImporte());
        d.setDsctoPorcentaje(lr.getDsctoPorcentaje() != null ? lr.getDsctoPorcentaje() : BigDecimal.ZERO);
        d.setTiposImpuestoId(lr.getTiposImpuestoId());
        d.setTiposImpuesto2Id(lr.getTiposImpuesto2Id());
        d.setCentrosCostoId(lr.getCentrosCostoId());
        d.setConceptoFinancieroId(lr.getConceptoFinancieroId());
        d.setOperacionesDetId(lr.getOperacionesDetId());
        d.setCreatedBy(TenantContext.getUsuarioId());
        return d;
    }

    private void buscarBancoProveedor(OrdenServicio os, Long proveedorId, Long monedaId) {
        if (proveedorId == null || monedaId == null) return;
        entidadBancoCntaRepository
                .findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(proveedorId, monedaId, "1")
                .ifPresent(banco -> {
                    os.setBancoId(banco.getBancoId());
                    os.setNroCuenta(banco.getNroCuenta());
                });
    }

    private void registrarAprobacion(Long osId, String accion, Long aprobadorId, String comentario) {
        Aprobacion a = new Aprobacion();
        a.setDocTipoId(resolveDocTipoId(DOC_TIPO_CODIGO_OS));
        a.setDocumentoId(osId);
        a.setNivel(1);
        a.setAccion(accion);
        a.setAprobadorId(aprobadorId);
        a.setComentario(comentario);
        a.setCreatedBy(TenantContext.getUsuarioId());
        aprobacionRepository.save(a);
    }

    private Long resolveDocTipoId(String codigo) {
        if (docTipoRefRepository != null) {
            return docTipoRefRepository.findFirstByCodigoAndFlagEstado(codigo, "1")
                    .map(DocTipoRef::getId)
                    .orElseThrow(() -> new BusinessException(
                            "No existe tipo de documento activo para codigo " + codigo,
                            HttpStatus.UNPROCESSABLE_ENTITY, "COM-132"));
        }
        return jdbcTemplate.queryForObject(
                "SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'",
                Long.class, codigo);
    }

    // ── Mapeo a DTOs ────────────────────────────────────────────────────────

    private OrdenServicioResumenResponse toResumen(OrdenServicio os) {
        String proveedorNombre = entidadContribuyenteRefRepository.findById(os.getProveedorId())
                .map(EntidadContribuyenteRef::getNombreCompleto)
                .orElse(null);

        String monedaCodigo = monedaRefRepository.findById(os.getMonedaId() != null ? os.getMonedaId() : 0L)
                .map(MonedaRef::getCodigo)
                .orElse(null);

        String compradorNombre = os.getCompradorId() != null
                ? compradorRepository.findById(os.getCompradorId())
                        .map(Comprador::getNombre).orElse(null)
                : null;

        return OrdenServicioResumenResponse.builder()
                .id(os.getId())
                .sucursalId(os.getSucursalId())
                .codOrigen(os.getCodOrigen())
                .nroOs(os.getNroOs())
                .proveedorId(os.getProveedorId())
                .proveedorRazonSocial(proveedorNombre)
                .fecRegistro(os.getFecRegistro())
                .monedaId(os.getMonedaId())
                .monedaCodigo(monedaCodigo)
                .montoTotal(os.getMontoTotal())
                .flagEstado(os.getFlagEstado())
                .formaPagoId(os.getFormaPagoId())
                .compradorNombre(compradorNombre)
                .build();
    }

    private OrdenServicioDetalleResponse toDetalle(OrdenServicio os) {
        List<OrdenServicioLineaResponse> lineas = os.getLineas().stream()
                .map(this::toLineaResponse)
                .collect(Collectors.toList());

        EntidadContribuyenteRef prov = os.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(os.getProveedorId()).orElse(null)
                : null;

        String monedaCodigo = monedaRefRepository.findById(os.getMonedaId() != null ? os.getMonedaId() : 0L)
                .map(MonedaRef::getCodigo)
                .orElse(null);

        String compradorNombre = os.getCompradorId() != null
                ? compradorRepository.findById(os.getCompradorId())
                        .map(Comprador::getNombre).orElse(null)
                : null;

        String aprobadorNombre = os.getAprobadorId() != null
                ? usuarioRefRepository.findById(os.getAprobadorId())
                        .map(UsuarioRef::getUsername).orElse(null)
                : null;

        return OrdenServicioDetalleResponse.builder()
                .id(os.getId())
                .sucursalId(os.getSucursalId())
                .codOrigen(os.getCodOrigen())
                .nroOs(os.getNroOs())
                .proveedorId(os.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .nomVendedor(os.getNomVendedor())
                .docTipoId(os.getDocTipoId())
                .fecRegistro(os.getFecRegistro())
                .monedaId(os.getMonedaId())
                .monedaCodigo(monedaCodigo)
                .tipoCambio(os.getTipoCambio())
                .formaPagoId(os.getFormaPagoId())
                .flagReqServ(os.getFlagReqServ())
                .flagSolicitaActa(os.getFlagSolicitaActa())
                .ordenTrabajoId(os.getOrdenTrabajoId())
                .bancoId(os.getBancoId())
                .nroCuenta(os.getNroCuenta())
                .montoTotal(os.getMontoTotal())
                .descripcion(os.getDescripcion())
                .flagEstado(os.getFlagEstado())
                .compradorId(os.getCompradorId())
                .compradorNombre(compradorNombre)
                .aprobadorId(os.getAprobadorId())
                .aprobadorNombre(aprobadorNombre)
                .fechaAprob(os.getFechaAprob())
                .motivoAnulacion(os.getMotivoAnulacion())
                .lineas(lineas)
                .createdBy(os.getCreatedBy())
                .fecCreacion(os.getFecCreacion())
                .updatedBy(os.getUpdatedBy())
                .fecModificacion(os.getFecModificacion())
                .build();
    }

    private OrdenServicioLineaResponse toLineaResponse(OrdenServicioDet l) {
        ServicioCatalogo serv = servicioCatalogoRepository.findById(l.getServicioId()).orElse(null);

        String conformidadUsrNombre = l.getConformidadUsr() != null
                ? usuarioRefRepository.findById(l.getConformidadUsr())
                        .map(UsuarioRef::getUsername).orElse(null)
                : null;

        return OrdenServicioLineaResponse.builder()
                .id(l.getId())
                .nroItem(l.getNroItem())
                .servicioId(l.getServicioId())
                .servicioCodigo(serv != null ? serv.getServicio() : null)
                .servicioDescripcion(serv != null ? serv.getDescripcion() : null)
                .descripcion(l.getDescripcion())
                .fecProyect(l.getFecProyect())
                .importe(l.getImporte())
                .dsctoPorcentaje(l.getDsctoPorcentaje())
                .decuento(l.getDecuento())
                .tiposImpuestoId(l.getTiposImpuestoId())
                .impuesto(l.getImpuesto())
                .tiposImpuesto2Id(l.getTiposImpuesto2Id())
                .impuesto2(l.getImpuesto2())
                .subtotal(l.getSubtotal())
                .impProvisionado(l.getImpProvisionado())
                .centrosCostoId(l.getCentrosCostoId())
                .conceptoFinancieroId(l.getConceptoFinancieroId())
                .operacionesDetId(l.getOperacionesDetId())
                .conformidadFecha(l.getConformidadFecha())
                .conformidadUsr(l.getConformidadUsr())
                .conformidadUsrNombre(conformidadUsrNombre)
                .flagEstado(l.getFlagEstado())
                .build();
    }

    @Override
    public List<ServicioDisponibleResponse> serviciosDisponibles(Long proveedorId, Long monedaId,
                                                                  LocalDate fechaRegistro, String codSubCat) {
        List<ServicioCatalogo> servicios = servicioCatalogoRepository.findAll();
        return servicios.stream()
                .filter(s -> "1".equals(s.getFlagEstado()))
                .filter(s -> codSubCat == null || codSubCat.isBlank() ||
                        (s.getArticuloSubCategId() != null && codSubCat.equals(String.valueOf(s.getArticuloSubCategId()))))
                .map(s -> ServicioDisponibleResponse.builder()
                        .id(s.getId())
                        .servicio(s.getServicio())
                        .descripcion(s.getDescripcion())
                        .unidadMedidaId(s.getUnidadMedidaId())
                        .articuloSubCategId(s.getArticuloSubCategId())
                        .tarifaEstd(s.getTarifaEstd())
                        .build())
                .collect(Collectors.toList());
    }

    private BigDecimal safe(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }
}
