package pe.restaurant.compras.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import feign.FeignException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.client.AlmacenClient;
import pe.restaurant.compras.repository.*;
import pe.restaurant.compras.service.OrdenCompraCalculator;
import pe.restaurant.compras.service.OrdenCompraPdfService;
import pe.restaurant.compras.service.OrdenCompraService;
import pe.restaurant.compras.service.OrdenCompraValidator;
import pe.restaurant.compras.spec.OrdenCompraSpecifications;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;

import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OrdenCompraServiceImpl implements OrdenCompraService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "compras.orden_compra";
    private static final String DOC_TIPO_CODIGO_OC = "OC";

    private final OrdenCompraRepository ordenCompraRepository;
    private final AprobacionRepository aprobacionRepository;
    private final OcImportacionRepository ocImportacionRepository;
    private final ArticuloMovProyRepository articuloMovProyRepository;
    private final EntidadBancoCntaRepository entidadBancoCntaRepository;
    private final ArticuloPrecioPactadoRepository articuloPrecioPactadoRepository;
    private final NumeradorDocumentoService numeradorDocumentoService;
    private final OrdenCompraCalculator calculator;
    private final OrdenCompraValidator validator;
    private final OrdenCompraPdfService pdfService;
    private final ConfiguracionRefRepository configuracionRefRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final UnidadMedidaRefRepository unidadMedidaRefRepository;
    private final ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    private final ArticuloAlmacenRefRepository articuloAlmacenRefRepository;
    private final AlmacenTacitoRefRepository almacenTacitoRefRepository;
    private final ValeMovRefRepository valeMovRefRepository;
    private final AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final CompradorRepository compradorRepository;
    private final UsuarioRefRepository usuarioRefRepository;
    private final JdbcTemplate jdbcTemplate;
    private final AlmacenClient almacenClient;

    @Autowired(required = false)
    private DocTipoRefRepository docTipoRefRepository;

    @Autowired(required = false)
    private JavaMailSender mailSender;

    // ── Listar ──────────────────────────────────────────────────────────────

    @Override
    public Page<OrdenCompraResumenResponse> listar(Long sucursalId,
                                                   Long proveedorId,
                                                   String flagEstado,
                                                   LocalDate fechaDesde,
                                                   LocalDate fechaHasta,
                                                   String numero,
                                                   Long monedaId,
                                                   Pageable pageable) {
        Specification<OrdenCompra> spec = OrdenCompraSpecifications.conFiltros(
                sucursalId, proveedorId, flagEstado, fechaDesde, fechaHasta, numero, monedaId);
        return ordenCompraRepository.findAll(spec, pageable).map(this::toResumen);
    }

    @Override
    public Page<OrdenCompraResumenResponse> pendientesAprobacion(Pageable pageable) {
        Long usuarioId = TenantContext.getUsuarioId();
        List<AprobadorConfigurado> aprobadores = aprobadorConfiguradoRepository.findAll().stream()
                .filter(a -> resolveDocTipoId(DOC_TIPO_CODIGO_OC).equals(a.getDocTipoId())
                        && usuarioId.equals(a.getAprobadorId())
                        && "1".equals(a.getFlagEstado()))
                .toList();

        BigDecimal montoMin = aprobadores.stream()
                .map(AprobadorConfigurado::getMontoMinimo)
                .filter(Objects::nonNull)
                .min(BigDecimal::compareTo).orElse(null);
        BigDecimal montoMax = aprobadores.stream()
                .map(AprobadorConfigurado::getMontoMaximo)
                .filter(Objects::nonNull)
                .max(BigDecimal::compareTo).orElse(null);

        Specification<OrdenCompra> spec = OrdenCompraSpecifications.conFiltros(
                null, null, "3", null, null, null, null);

        if (montoMin != null) {
            final BigDecimal min = montoMin;
            spec = spec.and((root, q, cb) -> cb.greaterThanOrEqualTo(root.get("total"), min));
        }
        if (montoMax != null) {
            final BigDecimal max = montoMax;
            spec = spec.and((root, q, cb) -> cb.lessThanOrEqualTo(root.get("total"), max));
        }

        return ordenCompraRepository.findAll(spec, pageable).map(this::toResumen);
    }

    @Override
    public OrdenCompraDetalleResponse obtener(Long id) {
        return toDetalle(buscar(id));
    }

    // ── Crear ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse crear(OrdenCompraCabeceraRequest request) {
        Long compradorId = validator.verificarCompradorActivo();
        validator.validarCabecera(request);
        validator.validarDetalle(request.getLineas());
        validator.validarDetalleFino(request.getLineas(), request.getFechaEmision());

        OrdenCompra oc = new OrdenCompra();
        aplicarCabecera(oc, request);
        oc.setCompradorId(compradorId);

        oc.setFlagEstado("3");
        oc.setCreatedBy(TenantContext.getUsuarioId());

        buscarBancoProveedor(oc, request.getProveedorId(), request.getMonedaId());

        for (OrdenCompraLineaRequest lr : request.getLineas()) {
            oc.addLinea(mapearLinea(lr));
        }

        calculator.calcularTotales(oc);

        if (validator.isFondosControlActivo()) {
            validator.verificarFondosDisponibles(oc);
        }

        oc.setNroOrdenCompra(numeradorDocumentoService.siguienteNroDocumentoIndependiente(
                NOMBRE_TABLA_DOCUMENTO, oc.getSucursalId(), oc.getFechaEmision().getYear()));

        OrdenCompra saved = ordenCompraRepository.save(oc);

        if (validator.isFondosControlActivo()) {
            validator.consumirFondos(saved);
        }

        crearMovimientosProyectados(saved);
        guardarImportacion(saved.getId(), request);

        return toDetalle(saved);
    }

    // ── Actualizar ──────────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse actualizar(Long id, OrdenCompraCabeceraRequest request) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = buscar(id);

        if (!"1".equals(oc.getFlagEstado()) && !"0".equals(oc.getFlagEstado()) && !"3".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "La orden solo puede editarse en estado activo, rechazada o pendiente de aprobacion",
                    HttpStatus.CONFLICT, "COM-025");
        }

        validator.validarCabecera(request);
        validator.validarDetalle(request.getLineas());
        validator.validarDetalleFino(request.getLineas(), request.getFechaEmision());

        Map<Long, OrdenCompraDet> lineasExistentes = oc.getLineas().stream()
                .filter(l -> l.getId() != null)
                .collect(Collectors.toMap(OrdenCompraDet::getId, Function.identity()));

        aplicarCabecera(oc, request);
        oc.setUpdatedBy(TenantContext.getUsuarioId());

        buscarBancoProveedor(oc, request.getProveedorId(), request.getMonedaId());

        List<Long> detIdsAntes = oc.getLineas().stream()
                .map(OrdenCompraDet::getId).filter(i -> i != null).collect(Collectors.toList());

        if (!detIdsAntes.isEmpty()) {
            articuloMovProyRepository.deleteByOrdenCompraDetIdIn(detIdsAntes);
        }

        boolean fondosActivo = validator.isFondosControlActivo();
        if (fondosActivo && !detIdsAntes.isEmpty()) {
            validator.liberarFondos(oc);
        }

        oc.getLineas().clear();
        for (OrdenCompraLineaRequest lr : request.getLineas()) {
            OrdenCompraDet nueva = mapearLinea(lr);

            if (lr.getId() != null) {
                OrdenCompraDet existente = lineasExistentes.get(lr.getId());
                if (existente != null) {
                    BigDecimal procesada = safe(existente.getCantProcesada());
                    nueva.setCantProcesada(procesada);
                    nueva.setCantFacturada(safe(existente.getCantFacturada()));

                    if (procesada.signum() > 0) {
                        nueva.setCantProyectada(existente.getCantProyectada());
                        nueva.setArticuloId(existente.getArticuloId());
                        nueva.setAlmacenId(existente.getAlmacenId());
                        nueva.setFechaEntrega(existente.getFechaEntrega());
                    }
                }
            }

            oc.addLinea(nueva);
        }

        calculator.calcularTotales(oc);

        if (id != null) {
            validator.verificarAnticiposNoExcedenTotal(id, safe(oc.getTotal()));
        }

        if (fondosActivo) {
            validator.verificarFondosDisponibles(oc);
        }

        OrdenCompra saved = ordenCompraRepository.save(oc);

        if (fondosActivo) {
            validator.consumirFondos(saved);
        }

        crearMovimientosProyectados(saved);
        guardarImportacion(saved.getId(), request);

        return toDetalle(saved);
    }

    // ── Modificar solo IGV (PATCH) ──────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse modificarIgv(Long id, ModificarIgvRequest request) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = ordenCompraRepository.findByIdWithLineas(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenCompra", id));

        if (!"3".equals(oc.getFlagEstado()) && !"1".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede modificar IGV en estado pendiente de aprobación o activa",
                    HttpStatus.CONFLICT, "COM-030");
        }

        Map<Long, OrdenCompraDet> lineasMap = oc.getLineas().stream()
                .collect(Collectors.toMap(OrdenCompraDet::getId, Function.identity()));

        for (ModificarIgvRequest.LineaIgv cambio : request.getLineas()) {
            OrdenCompraDet linea = lineasMap.get(cambio.getLineaId());
            if (linea == null) {
                throw new BusinessException(
                        "Línea id " + cambio.getLineaId() + " no pertenece a esta OC",
                        HttpStatus.BAD_REQUEST, "COM-031");
            }
            linea.setTipoImpuestoId(cambio.getTipoImpuestoId());
            linea.setUpdatedBy(TenantContext.getUsuarioId());
        }

        calculator.calcularTotales(oc);
        oc.setUpdatedBy(TenantContext.getUsuarioId());

        return toDetalle(ordenCompraRepository.save(oc));
    }

    // ── Flujo de aprobación ─────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse enviarAprobacion(Long id) {
        validator.verificarCompradorActivo();

        if (!isAprobacionRequerida()) {
            throw new BusinessException(
                    "El flujo de aprobación no está activo (COMPRA_APROBACION_OC=0)",
                    HttpStatus.CONFLICT, "COM-035");
        }

        OrdenCompra oc = buscar(id);

        if (!"1".equals(oc.getFlagEstado()) && !"0".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede enviar a aprobación una OC activa o rechazada",
                    HttpStatus.CONFLICT, "COM-011");
        }

        validator.verificarPrecios(oc);

        oc.setFlagEstado("3");
        oc.setUpdatedBy(TenantContext.getUsuarioId());

        registrarAprobacion(oc.getId(), "ENVIADA", null, null);

        return toDetalle(ordenCompraRepository.save(oc));
    }

    @Override
    @Transactional
    public OrdenCompraDetalleResponse aprobar(Long id, String observacion) {
        OrdenCompra oc = buscar(id);

        if (!"3".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "La OC no está en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-021");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        validator.validarAprobadorConfigurado(usuarioId, safe(oc.getTotal()));

        oc.setFlagEstado("1");
        oc.setAprobadorId(usuarioId);
        oc.setFechaAprobacion(OffsetDateTime.now());
        oc.setUpdatedBy(usuarioId);

        registrarAprobacion(oc.getId(), "APROBADA", usuarioId, observacion);

        return toDetalle(ordenCompraRepository.save(oc));
    }

    @Override
    @Transactional
    public OrdenCompraDetalleResponse rechazar(Long id, String motivo) {
        OrdenCompra oc = buscar(id);

        if (!"3".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "La OC no está en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-021");
        }

        boolean tieneIngresos = !valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(oc.getId()).isEmpty();
        if (tieneIngresos) {
            throw new BusinessException(
                    "No se puede rechazar: existen ingresos de almacén asociados a esta OC",
                    HttpStatus.CONFLICT, "COM-035");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        oc.setFlagEstado("0");
        oc.setUpdatedBy(usuarioId);

        registrarAprobacion(oc.getId(), "RECHAZADA", usuarioId, motivo);

        return toDetalle(ordenCompraRepository.save(oc));
    }

    @Override
    @Transactional
    public OrdenCompraDetalleResponse devolver(Long id, String motivo) {
        OrdenCompra oc = buscar(id);

        if (!"3".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede devolver una OC en estado pendiente de aprobación",
                    HttpStatus.CONFLICT, "COM-036");
        }

        Long usuarioId = TenantContext.getUsuarioId();

        oc.setFlagEstado("1");
        oc.setUpdatedBy(usuarioId);

        registrarAprobacion(oc.getId(), "DEVUELTA", usuarioId, motivo);

        return toDetalle(ordenCompraRepository.save(oc));
    }

    // ── Anular (HU §14) ────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse anular(Long id, String motivo) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = buscar(id);

        if (!"1".equals(oc.getFlagEstado()) && !"3".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se pueden anular OC en estado Generada",
                    HttpStatus.CONFLICT, "COM-011");
        }

        boolean tieneIngresos = oc.getLineas().stream()
                .anyMatch(l -> l.getCantProcesada() != null && l.getCantProcesada().signum() > 0);
        if (tieneIngresos) {
            throw new BusinessException(
                    "No se puede anular: la OC tiene ingresos al almacén",
                    HttpStatus.CONFLICT, "COM-013");
        }

        validator.verificarNoVieneDeAprovisionamiento(id);
        validator.verificarSinAnticipos(id);

        Long usuarioId = TenantContext.getUsuarioId();

        if (validator.isFondosControlActivo()) {
            validator.liberarFondos(oc);
        }

        oc.setFlagEstado("0");
        oc.setMotivoAnulacion(motivo);
        oc.setUpdatedBy(usuarioId);

        for (OrdenCompraDet linea : oc.getLineas()) {
            linea.setFlagEstado("0");
            linea.setCantProyectada(BigDecimal.ZERO);
            linea.setReferenciaSolCompraId(null);
            linea.setUpdatedBy(usuarioId);
        }

        List<Long> detIds = oc.getLineas().stream()
                .map(OrdenCompraDet::getId).filter(i -> i != null).collect(Collectors.toList());
        if (!detIds.isEmpty()) {
            articuloMovProyRepository.deleteByOrdenCompraDetIdIn(detIds);
        }

        calculator.calcularTotales(oc);

        return toDetalle(ordenCompraRepository.save(oc));
    }

    // ── Cerrar (HU §15) ────────────────────────────────────────────────────

    @Override
    @Transactional
    public OrdenCompraDetalleResponse cerrar(Long id) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = buscar(id);

        if ("0".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede cerrar una OC anulada",
                    HttpStatus.CONFLICT, "COM-015");
        }

        if ("1".equals(oc.getFlagImportacion()) && "1".equals(oc.getFlagSolicitaDua())) {
            OcImportacion imp = ocImportacionRepository.findByOrdenCompraId(oc.getId()).orElse(null);
            if (imp == null || imp.getNroDua() == null || imp.getNroDua().isBlank()) {
                throw new BusinessException(
                        "El número de DUA es obligatorio para cerrar esta OC",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-016");
            }
        }

        Long usuarioId = TenantContext.getUsuarioId();

        oc.setFlagEstado("2");
        oc.setUpdatedBy(usuarioId);

        for (OrdenCompraDet linea : oc.getLineas()) {
            if (!"0".equals(linea.getFlagEstado())) {
                linea.setFlagEstado("2");
                linea.setUpdatedBy(usuarioId);
            }
        }

        return toDetalle(ordenCompraRepository.save(oc));
    }

    // ── Historial de aprobaciones ───────────────────────────────────────────

    @Override
    public List<HistorialAprobacionResponse> historial(Long id) {
        buscar(id);
        return aprobacionRepository
                .findByDocTipoIdAndDocumentoIdOrderByFechaAsc(resolveDocTipoId(DOC_TIPO_CODIGO_OC), id)
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

    // ── Recepciones vinculadas (almacen.vale_mov) ───────────────────────────

    @Override
    public List<RecepcionResumenResponse> recepciones(Long id) {
        buscar(id);
        return valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(id).stream()
                .map(vm -> RecepcionResumenResponse.builder()
                        .id(vm.getId())
                        .nroVale(vm.getNroVale())
                        .fecha(vm.getFecha())
                        .flagEstado(vm.getFlagEstado())
                        .almacenId(vm.getAlmacenId())
                        .build())
                .collect(Collectors.toList());
    }

    // ── Saldo pendiente (HU §23.11) ─────────────────────────────────────────

    @Override
    public OrdenCompraSaldoPendienteResponse saldoPendiente(Long id) {
        OrdenCompra oc = buscar(id);

        Map<Long, BigDecimal> recepcionesReales = obtenerRecepcionesRealesPorLinea(id);

        BigDecimal totalPedido = BigDecimal.ZERO;
        BigDecimal totalRecibido = BigDecimal.ZERO;
        List<OrdenCompraSaldoPendienteResponse.LineaSaldo> lineasSaldo = new ArrayList<>();

        for (OrdenCompraDet l : oc.getLineas()) {
            if ("0".equals(l.getFlagEstado())) continue;
            BigDecimal cant = safe(l.getCantProyectada());
            BigDecimal proc = recepcionesReales.getOrDefault(l.getId(), safe(l.getCantProcesada()));
            BigDecimal pend = cant.subtract(proc).max(BigDecimal.ZERO);

            totalPedido = totalPedido.add(cant);
            totalRecibido = totalRecibido.add(proc);

            ArticuloRef artSaldo = articuloRefRepository.findById(l.getArticuloId()).orElse(null);
            lineasSaldo.add(OrdenCompraSaldoPendienteResponse.LineaSaldo.builder()
                    .lineaId(l.getId())
                    .articuloId(l.getArticuloId())
                    .articuloCodigo(artSaldo != null ? artSaldo.getCodigo() : null)
                    .articuloDescripcion(artSaldo != null ? artSaldo.getNombre() : null)
                    .cantidadOc(cant)
                    .cantProcesada(proc)
                    .cantidadPendiente(pend)
                    .build());
        }

        BigDecimal porcentaje = BigDecimal.ZERO;
        if (totalPedido.signum() > 0) {
            porcentaje = totalRecibido.multiply(new BigDecimal("100"))
                    .divide(totalPedido, 2, RoundingMode.HALF_UP);
        }

        BigDecimal montoRecibido = BigDecimal.ZERO;
        for (OrdenCompraDet l : oc.getLineas()) {
            if ("0".equals(l.getFlagEstado())) continue;
            BigDecimal proc = recepcionesReales.getOrDefault(l.getId(), safe(l.getCantProcesada()));
            montoRecibido = montoRecibido.add(
                    proc.multiply(safe(l.getValorUnitario())).setScale(4, RoundingMode.HALF_UP));
        }
        BigDecimal montoPendiente = safe(oc.getTotal()).subtract(montoRecibido).max(BigDecimal.ZERO);

        return OrdenCompraSaldoPendienteResponse.builder()
                .ordenCompraId(oc.getId())
                .numero(oc.getNroOrdenCompra())
                .totalPedido(oc.getTotal())
                .totalRecibido(montoRecibido)
                .pendiente(montoPendiente)
                .porcentajeAtendido(porcentaje)
                .lineas(lineasSaldo)
                .build();
    }

    @Override
    @Transactional
    public OrdenCompraRecepcionResponse recepcionarEnAlmacen(Long id, OrdenCompraRecepcionRequest request) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = buscar(id);

        if (!"1".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede recepcionar en almacén una OC activa",
                    HttpStatus.CONFLICT, "COM-037");
        }

        IntegracionRecepcionOcRequest integracionRequest = new IntegracionRecepcionOcRequest();
        integracionRequest.setOrdenCompraId(id);
        integracionRequest.setArticuloMovTipoId(request.getArticuloMovTipoId());
        integracionRequest.setAlmacenId(request.getAlmacenId());
        integracionRequest.setFechaMov(request.getFechaMov());
        integracionRequest.setObservaciones(request.getObservaciones());

        MovimientoDetalleResponse recepcion;
        try {
            recepcion = almacenClient.recepcionOrdenCompra(integracionRequest).getData();
        } catch (FeignException.NotFound e) {
            throw new BusinessException(
                    extraerMensajeDeError(e, "Orden de compra o almacén no encontrado en ms-almacen"),
                    HttpStatus.NOT_FOUND, "COM-038");
        } catch (FeignException.UnprocessableEntity e) {
            throw new BusinessException(
                    extraerMensajeDeError(e, "No fue posible generar la recepción en almacén"),
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-039");
        } catch (FeignException.BadRequest e) {
            throw new BusinessException(
                    extraerMensajeDeError(e, "Solicitud inválida al intentar recepcionar en almacén"),
                    HttpStatus.BAD_REQUEST, "COM-040");
        } catch (FeignException e) {
            throw new BusinessException(
                    extraerMensajeDeError(e, "Error de comunicación con ms-almacen"),
                    HttpStatus.SERVICE_UNAVAILABLE, "COM-041");
        }

        return OrdenCompraRecepcionResponse.builder()
                .ordenCompraId(oc.getId())
                .numeroOrdenCompra(oc.getNroOrdenCompra())
                .recepcion(recepcion)
                .saldoPendiente(saldoPendiente(id))
                .build();
    }

    private Map<Long, BigDecimal> obtenerRecepcionesRealesPorLinea(Long ordenCompraId) {
        try {
            String sql = """
                SELECT vmd.oc_det_id, COALESCE(SUM(vmd.cantidad), 0) AS total_recibido
                FROM almacen.vale_mov_det vmd
                JOIN almacen.vale_mov vm ON vm.id = vmd.vale_mov_id
                WHERE vm.orden_compra_id = ? AND vm.flag_estado = '1'
                GROUP BY vmd.oc_det_id
                """;
            return jdbcTemplate.query(sql, (rs, rowNum) -> Map.entry(
                    rs.getLong("oc_det_id"),
                    rs.getBigDecimal("total_recibido")
            ), ordenCompraId).stream()
                    .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        } catch (Exception e) {
            log.warn("No se pudo consultar recepciones reales para OC {}: {}", ordenCompraId, e.getMessage());
            return Map.of();
        }
    }

    // ── Datos artículo auxiliar (HU §12) ────────────────────────────────────

    @Override
    public DatosArticuloResponse datosArticulo(Long articuloId, Long proveedorId,
                                                Long monedaId, Long sucursalId,
                                                LocalDate fechaEmision) {
        validator.verificarCompradorActivo();

        BigDecimal precioPactado = articuloPrecioPactadoRepository
                .findPrecioVigente(articuloId, proveedorId, monedaId, fechaEmision)
                .orElse(null);

        Long almacenTacitoId = resolverAlmacenTacito(articuloId, sucursalId);

        BigDecimal saldoActual = null;
        if (almacenTacitoId != null) {
            saldoActual = articuloAlmacenRefRepository
                    .findByArticuloIdAndAlmacenId(articuloId, almacenTacitoId)
                    .map(ArticuloAlmacenRef::getCantidadDisponible)
                    .orElse(null);
        }

        ArticuloRef articulo = articuloRefRepository.findById(articuloId).orElse(null);

        Boolean flagPercepcion = null;
        BigDecimal percepcionTasa = null;
        if (articulo != null) {
            percepcionTasa = configuracionRefRepository.findFirstByParametro("TASA_PERCEPCION")
                    .map(c -> {
                        try { return new BigDecimal(c.getValorTexto()); }
                        catch (Exception e) { return null; }
                    })
                    .orElse(null);
            flagPercepcion = percepcionTasa != null;
        }

        Long unidadMedidaId = articulo != null ? articulo.getUnidadMedidaId() : null;
        String unidadMedidaDesc = null;
        if (unidadMedidaId != null) {
            unidadMedidaDesc = unidadMedidaRefRepository.findById(unidadMedidaId)
                    .map(um -> um.getNombre() != null ? um.getNombre() : "")
                    .orElse(null);
        }

        return DatosArticuloResponse.builder()
                .precioPactado(precioPactado)
                .almacenTacitoId(almacenTacitoId)
                .saldoActual(saldoActual)
                .flagPercepcion(flagPercepcion)
                .percepcionTasa(percepcionTasa)
                .unidadMedidaId(unidadMedidaId)
                .unidadMedidaDescripcion(unidadMedidaDesc)
                .build();
    }

    // ── Enviar al proveedor (email + PDF) ────────────────────────────────────

    @Override
    @Transactional
    public boolean enviarProveedor(Long id, EnviarProveedorRequest request) {
        validator.verificarCompradorActivo();
        OrdenCompra oc = buscar(id);

        if (!"1".equals(oc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede enviar al proveedor una OC activa",
                    HttpStatus.CONFLICT, "COM-020");
        }

        if (mailSender == null) {
            throw new BusinessException(
                    "El servicio de correo no está configurado",
                    HttpStatus.SERVICE_UNAVAILABLE, "COM-032");
        }

        String emailDestino = resolverEmailDestino(request, oc.getProveedorId());
        if (emailDestino == null || emailDestino.isBlank()) {
            throw new BusinessException(
                    "No se encontró email del proveedor ni se proporcionó uno",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-033");
        }

        byte[] pdf = pdfService.generarPdf(id);
        String asunto = request != null && request.getAsunto() != null
                ? request.getAsunto()
                : "Orden de Compra " + oc.getNroOrdenCompra();
        String cuerpo = request != null && request.getMensaje() != null
                ? request.getMensaje()
                : "Adjunto encontrará la Orden de Compra " + oc.getNroOrdenCompra() + ".";

        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setTo(emailDestino);
            helper.setSubject(asunto);
            helper.setText(cuerpo, false);
            helper.addAttachment("OC-" + oc.getNroOrdenCompra() + ".pdf",
                    new ByteArrayResource(pdf), "application/pdf");
            mailSender.send(msg);
            log.info("OC {} enviada al proveedor {}", oc.getNroOrdenCompra(), emailDestino);
            return true;
        } catch (Exception e) {
            log.error("Error enviando OC {} al proveedor: {}", id, e.getMessage(), e);
            throw new BusinessException(
                    "Error al enviar el correo: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "COM-034");
        }
    }

    // ══════════════════════════════════════════════════════════════════════════
    // Métodos privados
    // ══════════════════════════════════════════════════════════════════════════

    private OrdenCompra buscar(Long id) {
        OrdenCompra oc = ordenCompraRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("OrdenCompra", id));
        oc.getLineas().size();
        return oc;
    }

    private boolean isAprobacionRequerida() {
        return configuracionRefRepository.findFirstByParametro("COMPRA_APROBACION_OC")
                .map(c -> "1".equals(c.getValorTexto()))
                .orElse(false);
    }

    private String resolverEmailDestino(EnviarProveedorRequest request, Long proveedorId) {
        if (request != null && request.getEmailDestino() != null && !request.getEmailDestino().isBlank()) {
            return request.getEmailDestino();
        }
        return entidadContribuyenteRefRepository.findById(proveedorId)
                .map(EntidadContribuyenteRef::getEmail)
                .orElse(null);
    }

    private String extraerMensajeDeError(FeignException e, String mensajeDefault) {
        try {
            String responseBody = e.contentUTF8();
            if (responseBody != null && !responseBody.isBlank()) {
                JsonNode jsonNode = new ObjectMapper().readTree(responseBody);
                if (jsonNode.has("message")) {
                    return jsonNode.get("message").asText();
                }
            }
        } catch (Exception ex) {
            log.warn("No se pudo extraer el mensaje de error remoto", ex);
        }
        return mensajeDefault;
    }

    private void aplicarCabecera(OrdenCompra oc, OrdenCompraCabeceraRequest r) {
        oc.setSucursalId(r.getSucursalId());
        oc.setProveedorId(r.getProveedorId());
        oc.setFechaEmision(r.getFechaEmision());
        oc.setFechaEntrega(r.getFechaEntrega());
        oc.setMonedaId(r.getMonedaId());
        oc.setFormaPagoId(r.getFormaPagoId());
        oc.setEntidadBancoCntaId(r.getEntidadBancoCntaId());
        oc.setLugarEntrega(r.getLugarEntrega());
        oc.setObservaciones(r.getObservaciones());
        oc.setTipoCambio(r.getTipoCambio());
        oc.setFlagImportacion(Boolean.TRUE.equals(r.getFlagImportacion()) ? "1" : "0");
        oc.setFlagSolicitaDua(Boolean.TRUE.equals(r.getFlagSolicitaDua()) ? "1" : "0");
        oc.setCentroBeneficio(r.getCentroBeneficio());
    }

    private OrdenCompraDet mapearLinea(OrdenCompraLineaRequest lr) {
        OrdenCompraDet d = new OrdenCompraDet();
        d.setArticuloId(lr.getArticuloId());
        d.setCantProyectada(lr.getCantProyectada());
        d.setFecProyectada(lr.getFecProyectada());
        d.setValorUnitario(lr.getValorUnitario());
        d.setTipoImpuestoId(lr.getTipoImpuestoId());
        d.setValorImpuesto(lr.getValorImpuesto() != null ? lr.getValorImpuesto() : BigDecimal.ZERO);
        d.setDescuentoPorcentaje(lr.getDescuentoPorcentaje() != null ? lr.getDescuentoPorcentaje() : BigDecimal.ZERO);
        d.setTipoPercepcionId(lr.getTipoPercepcionId());
        d.setCentrosCostoId(lr.getCentrosCostoId());
        d.setAlmacenId(lr.getAlmacenId());
        d.setReferenciaSolCompraId(lr.getReferenciaSolCompraId());
        d.setFechaEntrega(lr.getFechaEntrega());
        d.setOperacionesDetId(lr.getOperacionesDetId());
        d.setProgComprasDetId(lr.getProgComprasDetId());
        d.setCreatedBy(TenantContext.getUsuarioId());
        return d;
    }

    private void buscarBancoProveedor(OrdenCompra oc, Long proveedorId, Long monedaId) {
        if (proveedorId == null || monedaId == null) return;
        entidadBancoCntaRepository
                .findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(proveedorId, monedaId, "1")
                .ifPresent(banco -> {
                    oc.setBancoId(banco.getBancoId());
                    oc.setNroCuenta(banco.getNroCuenta());
                });
    }

    private void registrarAprobacion(Long ocId, String accion, Long aprobadorId, String comentario) {
        Aprobacion a = new Aprobacion();
        a.setDocTipoId(resolveDocTipoId(DOC_TIPO_CODIGO_OC));
        a.setDocumentoId(ocId);
        a.setNivel(1);
        a.setAccion(accion);
        a.setAprobadorId(aprobadorId);
        a.setComentario(comentario);
        a.setCreatedBy(TenantContext.getUsuarioId());
        aprobacionRepository.save(a);
    }

    private void crearMovimientosProyectados(OrdenCompra oc) {
        for (OrdenCompraDet l : oc.getLineas()) {
            if (l.getId() == null) continue;
            ArticuloMovProy mp = new ArticuloMovProy();
            mp.setArticuloId(l.getArticuloId());
            mp.setAlmacenId(l.getAlmacenId());
            mp.setOrdenCompraDetId(l.getId());
            mp.setCantidad(l.getCantProyectada());
            mp.setFechaProyectada(l.getFechaEntrega());
            mp.setTipoOrigen("OC");
            mp.setCreatedBy(TenantContext.getUsuarioId());
            articuloMovProyRepository.save(mp);
        }
    }

    private void guardarImportacion(Long ocId, OrdenCompraCabeceraRequest request) {
        if (!Boolean.TRUE.equals(request.getFlagImportacion()) || request.getImportacion() == null) return;

        OcImportacionRequest imp = request.getImportacion();
        OcImportacion entity = ocImportacionRepository.findByOrdenCompraId(ocId).orElse(new OcImportacion());
        entity.setOrdenCompraId(ocId);
        entity.setIncoterm(imp.getIncoterm());
        entity.setPuertoEmbarque(imp.getPuertoEmbarque());
        entity.setPuertoDestino(imp.getPuertoDestino());
        entity.setAgenteAduanas(imp.getAgenteAduanas());
        entity.setNroDua(imp.getNroDua());
        entity.setFechaEmbarque(imp.getFechaEmbarque());
        entity.setFechaLlegadaEst(imp.getFechaLlegadaEstimada());
        entity.setObservaciones(imp.getObservaciones());
        if (entity.getId() == null) {
            entity.setCreatedBy(TenantContext.getUsuarioId());
        } else {
            entity.setUpdatedBy(TenantContext.getUsuarioId());
        }
        ocImportacionRepository.save(entity);
    }

    // ── Mapeo a DTOs ────────────────────────────────────────────────────────

    private OrdenCompraResumenResponse toResumen(OrdenCompra oc) {
        EntidadContribuyenteRef prov = oc.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(oc.getProveedorId()).orElse(null)
                : null;
        MonedaRef moneda = oc.getMonedaId() != null
                ? monedaRefRepository.findById(oc.getMonedaId()).orElse(null)
                : null;

        return OrdenCompraResumenResponse.builder()
                .id(oc.getId())
                .sucursalId(oc.getSucursalId())
                .proveedorId(oc.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .nroOrdenCompra(oc.getNroOrdenCompra())
                .fechaEmision(oc.getFechaEmision())
                .fechaEntrega(oc.getFechaEntrega())
                .monedaId(oc.getMonedaId())
                .monedaCodigo(moneda != null ? moneda.getCodigo() : null)
                .total(oc.getTotal())
                .flagEstado(oc.getFlagEstado())
                .formaPagoId(oc.getFormaPagoId())
                .compradorNombre(resolverNombreComprador(oc.getCompradorId()))
                .build();
    }

    private OrdenCompraDetalleResponse toDetalle(OrdenCompra oc) {
        List<OrdenCompraLineaResponse> lineas = oc.getLineas().stream()
                .map(this::toLineaResponse)
                .collect(Collectors.toList());

        OcImportacionDto impDto = null;
        if ("1".equals(oc.getFlagImportacion())) {
            impDto = ocImportacionRepository.findByOrdenCompraId(oc.getId())
                    .map(i -> OcImportacionDto.builder()
                            .id(i.getId())
                            .incoterm(i.getIncoterm())
                            .puertoEmbarque(i.getPuertoEmbarque())
                            .puertoDestino(i.getPuertoDestino())
                            .agenteAduanas(i.getAgenteAduanas())
                            .nroDua(i.getNroDua())
                            .fechaEmbarque(i.getFechaEmbarque())
                            .fechaLlegadaEst(i.getFechaLlegadaEst())
                            .observaciones(i.getObservaciones())
                            .build())
                    .orElse(null);
        }

        EntidadContribuyenteRef prov = oc.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(oc.getProveedorId()).orElse(null)
                : null;
        MonedaRef moneda = oc.getMonedaId() != null
                ? monedaRefRepository.findById(oc.getMonedaId()).orElse(null)
                : null;

        return OrdenCompraDetalleResponse.builder()
                .id(oc.getId())
                .sucursalId(oc.getSucursalId())
                .proveedorId(oc.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .nroOrdenCompra(oc.getNroOrdenCompra())
                .fechaEmision(oc.getFechaEmision())
                .fechaEntrega(oc.getFechaEntrega())
                .monedaId(oc.getMonedaId())
                .monedaCodigo(moneda != null ? moneda.getCodigo() : null)
                .formaPagoId(oc.getFormaPagoId())
                .entidadBancoCntaId(oc.getEntidadBancoCntaId())
                .lugarEntrega(oc.getLugarEntrega())
                .observaciones(oc.getObservaciones())
                .tipoCambio(oc.getTipoCambio())
                .flagImportacion(oc.getFlagImportacion())
                .flagSolicitaDua(oc.getFlagSolicitaDua())
                .bancoId(oc.getBancoId())
                .nroCuenta(oc.getNroCuenta())
                .centroBeneficio(oc.getCentroBeneficio())
                .subtotal(oc.getSubtotal())
                .descuentoTotal(oc.getDescuentoTotal())
                .igvTotal(oc.getIgvTotal())
                .percepcionTotal(oc.getPercepcionTotal())
                .total(oc.getTotal())
                .flagEstado(oc.getFlagEstado())
                .compradorId(oc.getCompradorId())
                .compradorNombre(resolverNombreComprador(oc.getCompradorId()))
                .aprobadorId(oc.getAprobadorId())
                .aprobadorNombre(resolverNombreComprador(oc.getAprobadorId()))
                .fechaAprobacion(oc.getFechaAprobacion())
                .motivoAnulacion(oc.getMotivoAnulacion())
                .createdBy(oc.getCreatedBy())
                .fecCreacion(oc.getFecCreacion())
                .updatedBy(oc.getUpdatedBy())
                .fecModificacion(oc.getFecModificacion())
                .lineas(lineas)
                .importacion(impDto)
                .build();
    }

    private OrdenCompraLineaResponse toLineaResponse(OrdenCompraDet l) {
        BigDecimal cantPend = safe(l.getCantProyectada()).subtract(safe(l.getCantProcesada())).max(BigDecimal.ZERO);
        ArticuloRef articulo = articuloRefRepository.findById(l.getArticuloId()).orElse(null);
        Long unidadMedidaId = articulo != null ? articulo.getUnidadMedidaId() : null;
        UnidadMedidaRef unidad = unidadMedidaId != null
                ? unidadMedidaRefRepository.findById(unidadMedidaId).orElse(null)
                : null;
        return OrdenCompraLineaResponse.builder()
                .id(l.getId())
                .articuloId(l.getArticuloId())
                .articuloCodigo(articulo != null ? articulo.getCodigo() : null)
                .articuloDescripcion(articulo != null ? articulo.getNombre() : null)
                .unidadMedidaId(unidadMedidaId)
                .unidadMedidaCodigo(unidad != null ? unidad.getLabel() : null)
                .cantProyectada(l.getCantProyectada())
                .fecProyectada(l.getFecProyectada())
                .cantProcesada(l.getCantProcesada())
                .cantFacturada(l.getCantFacturada())
                .valorUnitario(l.getValorUnitario())
                .tipoImpuestoId(l.getTipoImpuestoId())
                .valorImpuesto(l.getValorImpuesto())
                .descuentoPorcentaje(l.getDescuentoPorcentaje())
                .descuentoMonto(l.getDescuentoMonto())
                .tipoPercepcionId(l.getTipoPercepcionId())
                .percepcionMonto(l.getPercepcionMonto())
                .subtotal(l.getSubtotal())
                .centrosCostoId(l.getCentrosCostoId())
                .almacenId(l.getAlmacenId())
                .referenciaSolCompraId(l.getReferenciaSolCompraId())
                .cantidadPendiente(cantPend)
                .fechaEntrega(l.getFechaEntrega())
                .flagEstado(l.getFlagEstado())
                .operacionesDetId(l.getOperacionesDetId())
                .progComprasDetId(l.getProgComprasDetId())
                .build();
    }

    private String resolverNombreComprador(Long compradorId) {
        if (compradorId == null) return null;
        return compradorRepository.findById(compradorId)
                .map(c -> {
                    if (c.getNombre() != null && !c.getNombre().isBlank()) return c.getNombre();
                    return usuarioRefRepository.findById(c.getUsuarioId())
                            .map(UsuarioRef::getUsername)
                            .orElse(null);
                })
                .orElseGet(() -> usuarioRefRepository.findById(compradorId)
                        .map(UsuarioRef::getUsername)
                        .orElse(null));
    }

    private Long resolverAlmacenTacito(Long articuloId, Long sucursalId) {
        if (articuloId == null || sucursalId == null) return null;
        try {
            ArticuloRef art = articuloRefRepository.findById(articuloId).orElse(null);
            if (art == null || art.getArticuloCategId() == null) return null;

            String codClase = articuloCategoriaRefRepository.findById(art.getArticuloCategId())
                    .map(ArticuloCategoriaRef::getCatArt)
                    .orElse(null);
            if (codClase == null) return null;

            return almacenTacitoRefRepository.findFirstByCodClaseAndSucursalId(codClase, sucursalId)
                    .map(AlmacenTacitoRef::getAlmacenId)
                    .orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal safe(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }

    private Long resolveDocTipoId(String codigo) {
        if (docTipoRefRepository != null) {
            return docTipoRefRepository.findFirstByCodigoAndFlagEstado(codigo, "1")
                    .map(DocTipoRef::getId)
                    .orElseThrow(() -> new BusinessException(
                            "No existe tipo de documento activo para codigo " + codigo,
                            HttpStatus.UNPROCESSABLE_ENTITY, "COM-030"));
        }
        return jdbcTemplate.queryForObject(
                "SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'",
                Long.class, codigo);
    }
}

