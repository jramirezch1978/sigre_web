package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.mapper.SolicitudCompraMapper;
import pe.restaurant.compras.repository.*;
import pe.restaurant.compras.service.SolicitudCompraService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SolicitudCompraServiceImpl implements SolicitudCompraService {

    private static final String NOMBRE_TABLA_DOCUMENTO = "compras.solicitud_compra";

    private final SolicitudCompraRepository solicitudCompraRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final CotizacionRepository cotizacionRepository;
    private final OrdenCompraRepository ordenCompraRepository;
    private final UsuarioRefRepository usuarioRefRepository;
    private final SolicitudCompraMapper mapper;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Override
    @Timed(value = "solicitud_compra.listar")
    public Page<SolicitudCompraResponse> listar(Long sucursalId, String flagEstado,
                                                 String prioridad, LocalDate fechaDesde,
                                                 LocalDate fechaHasta, Pageable pageable) {
        Specification<SolicitudCompra> spec = Specification.allOf();

        if (sucursalId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("sucursalId"), sucursalId));
        }
        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }
        if (prioridad != null && !prioridad.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("prioridad"), prioridad));
        }
        if (fechaDesde != null) {
            spec = spec.and((root, q, cb) -> cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
        }
        if (fechaHasta != null) {
            spec = spec.and((root, q, cb) -> cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
        }

        return solicitudCompraRepository.findAll(spec, pageable)
                .map(mapper::toResponse);
    }

    @Override
    @Timed(value = "solicitud_compra.obtener")
    public SolicitudCompraDetalleResponse obtener(Long id) {
        return toDetalle(buscar(id));
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.crear")
    public SolicitudCompraDetalleResponse crear(SolicitudCompraRequest request) {
        validarLineas(request.getLineas());

        Long sucursalId = request.getSucursalId() != null
                ? request.getSucursalId()
                : TenantContext.getSucursalId();

        if (request.getSolicitanteId() != null) {
            validarUsuarioExiste(request.getSolicitanteId());
        }

        SolicitudCompra sc = new SolicitudCompra();
        sc.setSucursalId(sucursalId);
        sc.setFecha(request.getFecha());
        sc.setSolicitanteId(request.getSolicitanteId() != null
                ? request.getSolicitanteId()
                : TenantContext.getUsuarioId());
        sc.setPrioridad(request.getPrioridad() != null ? request.getPrioridad() : "MEDIA");
        sc.setFlagEstado("1");
        sc.setJustificacion(request.getJustificacion());
        sc.setCreatedBy(TenantContext.getUsuarioId());

        sc.setNroSolicitud(numeradorDocumentoService.siguienteNroDocumento(
                NOMBRE_TABLA_DOCUMENTO, sucursalId, request.getFecha().getYear()));

        Long usuarioId = TenantContext.getUsuarioId();
        for (SolicitudCompraDetRequest lr : request.getLineas()) {
            SolicitudCompraDet det = new SolicitudCompraDet();
            det.setArticuloId(lr.getArticuloId());
            det.setAlmacenId(lr.getAlmacenId());
            det.setCantidad(lr.getCantidad());
            det.setEspecificaciones(lr.getEspecificaciones());
            det.setCreatedBy(usuarioId);
            sc.addLinea(det);
        }

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra creada: {} (id={})", saved.getNroSolicitud(), saved.getId());
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.actualizar")
    public SolicitudCompraDetalleResponse actualizar(Long id, SolicitudCompraRequest request) {
        SolicitudCompra sc = buscar(id);

        if (!"1".equals(sc.getFlagEstado()) && !"0".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede editar una solicitud activa o rechazada",
                    HttpStatus.CONFLICT, "SOL-002");
        }

        validarLineas(request.getLineas());

        if (request.getSolicitanteId() != null) {
            validarUsuarioExiste(request.getSolicitanteId());
        }

        sc.setSucursalId(request.getSucursalId() != null
                ? request.getSucursalId()
                : sc.getSucursalId());
        sc.setFecha(request.getFecha());
        sc.setSolicitanteId(request.getSolicitanteId() != null
                ? request.getSolicitanteId()
                : sc.getSolicitanteId());
        sc.setPrioridad(request.getPrioridad() != null ? request.getPrioridad() : sc.getPrioridad());
        sc.setJustificacion(request.getJustificacion());
        sc.setUpdatedBy(TenantContext.getUsuarioId());

        if ("0".equals(sc.getFlagEstado())) {
            sc.setFlagEstado("1");
        }

        sc.getLineas().clear();

        Long usuarioId = TenantContext.getUsuarioId();
        for (SolicitudCompraDetRequest lr : request.getLineas()) {
            SolicitudCompraDet det = new SolicitudCompraDet();
            det.setArticuloId(lr.getArticuloId());
            det.setAlmacenId(lr.getAlmacenId());
            det.setCantidad(lr.getCantidad());
            det.setEspecificaciones(lr.getEspecificaciones());
            det.setCreatedBy(usuarioId);
            sc.addLinea(det);
        }

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra actualizada: {} (id={})", saved.getNroSolicitud(), saved.getId());
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.enviar")
    public SolicitudCompraDetalleResponse enviar(Long id) {
        SolicitudCompra sc = buscar(id);

        if (!"1".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede enviar una solicitud activa",
                    HttpStatus.CONFLICT, "SOL-003");
        }

        if (sc.getLineas().isEmpty()) {
            throw new BusinessException(
                    "La solicitud debe tener al menos una línea de detalle",
                    HttpStatus.UNPROCESSABLE_ENTITY, "SOL-004");
        }

        sc.setFlagEstado("1");
        sc.setUpdatedBy(TenantContext.getUsuarioId());

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra enviada: {} (id={})", saved.getNroSolicitud(), saved.getId());
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.aprobar")
    public SolicitudCompraDetalleResponse aprobar(Long id, String observacion) {
        SolicitudCompra sc = buscar(id);

        if (!"1".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede aprobar una solicitud activa",
                    HttpStatus.CONFLICT, "SOL-005");
        }

        sc.setFlagEstado("1");
        sc.setUpdatedBy(TenantContext.getUsuarioId());

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra aprobada: {} (id={})", saved.getNroSolicitud(), saved.getId());
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.rechazar")
    public SolicitudCompraDetalleResponse rechazar(Long id, String motivo) {
        SolicitudCompra sc = buscar(id);

        if (!"1".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede rechazar una solicitud activa",
                    HttpStatus.CONFLICT, "SOL-006");
        }

        if (motivo == null || motivo.isBlank()) {
            throw new BusinessException(
                    "El motivo de rechazo es obligatorio",
                    HttpStatus.BAD_REQUEST, "SOL-007");
        }

        sc.setFlagEstado("0");
        sc.setUpdatedBy(TenantContext.getUsuarioId());

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra rechazada: {} (id={}), motivo: {}", saved.getNroSolicitud(), saved.getId(), motivo);
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.anular")
    public SolicitudCompraDetalleResponse anular(Long id, String motivo) {
        SolicitudCompra sc = buscar(id);

        if ("0".equals(sc.getFlagEstado()) || "2".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede anular una solicitud anulada o cerrada",
                    HttpStatus.CONFLICT, "SOL-008");
        }

        if (motivo == null || motivo.isBlank()) {
            throw new BusinessException(
                    "El motivo de anulación es obligatorio",
                    HttpStatus.BAD_REQUEST, "SOL-009");
        }

        sc.setFlagEstado("0");
        sc.setUpdatedBy(TenantContext.getUsuarioId());

        SolicitudCompra saved = solicitudCompraRepository.save(sc);
        log.info("Solicitud de compra anulada: {} (id={}), motivo: {}", saved.getNroSolicitud(), saved.getId(), motivo);
        return toDetalle(saved);
    }

    @Override
    @Transactional
    @Timed(value = "solicitud_compra.convertir")
    public ConvertirSolicitudResponse convertir(Long id, ConvertirSolicitudRequest request) {
        SolicitudCompra sc = buscar(id);

        if (!"1".equals(sc.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede convertir una solicitud activa",
                    HttpStatus.CONFLICT, "SOL-020");
        }

        List<Long> generados = new ArrayList<>();

        if ("COTIZACION".equalsIgnoreCase(request.getDestino())) {
            for (Long proveedorId : request.getProveedorIds()) {
                Long cotId = crearCotizacionDesdeSolicitud(sc, proveedorId, request.getMonedaId());
                generados.add(cotId);
            }
        } else if ("ORDEN_COMPRA".equalsIgnoreCase(request.getDestino())) {
            for (Long proveedorId : request.getProveedorIds()) {
                Long ocId = crearOrdenCompraDesdeSolicitud(sc, proveedorId, request.getMonedaId());
                generados.add(ocId);
            }
        } else {
            throw new BusinessException(
                    "Destino no válido. Use COTIZACION u ORDEN_COMPRA",
                    HttpStatus.BAD_REQUEST, "SOL-021");
        }

        sc.setFlagEstado("2");
        sc.setUpdatedBy(TenantContext.getUsuarioId());
        solicitudCompraRepository.save(sc);

        log.info("Solicitud {} convertida a {} → ids {}", sc.getNroSolicitud(), request.getDestino(), generados);

        return ConvertirSolicitudResponse.builder()
                .solicitudId(sc.getId())
                .destino(request.getDestino())
                .documentosGenerados(generados)
                .build();
    }

    @Override
    public List<TrazabilidadDocumentoResponse> trazabilidad(Long id) {
        buscar(id);
        List<TrazabilidadDocumentoResponse> resultado = new ArrayList<>();

        ordenCompraRepository.findBySolicitudCompraIdViaDetalle(id).forEach(oc ->
                resultado.add(TrazabilidadDocumentoResponse.builder()
                        .tipoDocumento("ORDEN_COMPRA")
                        .documentoId(oc.getId())
                        .numero(oc.getNroOrdenCompra())
                        .fecha(oc.getFechaEmision())
                        .flagEstado(oc.getFlagEstado())
                        .build()));

        return resultado;
    }

    private Long crearCotizacionDesdeSolicitud(SolicitudCompra sc, Long proveedorId, Long monedaId) {
        Cotizacion cot = new Cotizacion();
        cot.setSucursalId(sc.getSucursalId());
        cot.setProveedorId(proveedorId);
        cot.setFecha(LocalDate.now());
        cot.setMonedaId(monedaId);
        cot.setTotal(BigDecimal.ZERO);
        cot.setFlagEstado("1");
        cot.setCreatedBy(TenantContext.getUsuarioId());

        for (SolicitudCompraDet det : sc.getLineas()) {
            CotizacionDet cd = new CotizacionDet();
            cd.setArticuloId(det.getArticuloId());
            cd.setCantidad(det.getCantidad());
            cd.setPrecioUnitario(BigDecimal.ZERO);
            cd.setCreatedBy(TenantContext.getUsuarioId());
            cot.addLinea(cd);
        }

        return cotizacionRepository.save(cot).getId();
    }

    private Long crearOrdenCompraDesdeSolicitud(SolicitudCompra sc, Long proveedorId, Long monedaId) {
        OrdenCompra oc = new OrdenCompra();
        oc.setSucursalId(sc.getSucursalId());
        oc.setProveedorId(proveedorId);
        oc.setFechaEmision(LocalDate.now());
        oc.setMonedaId(monedaId);
        oc.setTotal(BigDecimal.ZERO);
        oc.setFlagEstado("1");
        oc.setCreatedBy(TenantContext.getUsuarioId());
        oc.setNroOrdenCompra(numeradorDocumentoService.siguienteNroDocumentoIndependiente(
                "compras.orden_compra", sc.getSucursalId(), LocalDate.now().getYear()));

        return ordenCompraRepository.save(oc).getId();
    }

    // ══════════════════════════════════════════════════════════════════════════

    private SolicitudCompra buscar(Long id) {
        SolicitudCompra sc = solicitudCompraRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudCompra", id));
        sc.getLineas().size();
        return sc;
    }

    private void validarLineas(List<SolicitudCompraDetRequest> lineas) {
        if (lineas == null || lineas.isEmpty()) {
            throw new BusinessException(
                    "La solicitud debe tener al menos una línea de detalle",
                    HttpStatus.BAD_REQUEST, "SOL-010");
        }
        for (SolicitudCompraDetRequest l : lineas) {
            validarArticuloExiste(l.getArticuloId());
        }
    }

    private void validarArticuloExiste(Long id) {
        if (id == null) return;
        if (!articuloRefRepository.existsById(id)) {
            throw new BusinessException(
                    "No existe registro en core.articulo con id " + id,
                    HttpStatus.UNPROCESSABLE_ENTITY, "SOL-011");
        }
    }

    private void validarUsuarioExiste(Long id) {
        if (id == null) return;
        if (!usuarioRefRepository.existsById(id)) {
            throw new BusinessException(
                    "No existe registro de usuario con id " + id,
                    HttpStatus.UNPROCESSABLE_ENTITY, "SOL-011");
        }
    }

    private SolicitudCompraDetalleResponse toDetalle(SolicitudCompra sc) {
        List<SolicitudCompraDetResponse> lineas = sc.getLineas().stream()
                .map(this::toLineaResponse)
                .collect(Collectors.toList());

        return SolicitudCompraDetalleResponse.builder()
                .id(sc.getId())
                .sucursalId(sc.getSucursalId())
                .numero(sc.getNroSolicitud())
                .fecha(sc.getFecha())
                .solicitanteId(sc.getSolicitanteId())
                .prioridad(sc.getPrioridad())
                .flagEstado(sc.getFlagEstado())
                .justificacion(sc.getJustificacion())
                .createdBy(sc.getCreatedBy())
                .fecCreacion(sc.getFecCreacion())
                .updatedBy(sc.getUpdatedBy())
                .fecModificacion(sc.getFecModificacion())
                .lineas(lineas)
                .build();
    }

    private SolicitudCompraDetResponse toLineaResponse(SolicitudCompraDet det) {
        ArticuloRef articulo = articuloRefRepository.findById(det.getArticuloId()).orElse(null);
        return SolicitudCompraDetResponse.builder()
                .id(det.getId())
                .articuloId(det.getArticuloId())
                .almacenId(det.getAlmacenId())
                .articuloCodigo(articulo != null ? articulo.getCodigo() : null)
                .articuloDescripcion(articulo != null ? articulo.getNombre() : null)
                .cantidad(det.getCantidad())
                .especificaciones(det.getEspecificaciones())
                .createdBy(det.getCreatedBy())
                .fecCreacion(det.getFecCreacion())
                .updatedBy(det.getUpdatedBy())
                .fecModificacion(det.getFecModificacion())
                .build();
    }
}
