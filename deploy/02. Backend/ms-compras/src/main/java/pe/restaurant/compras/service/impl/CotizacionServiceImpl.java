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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.ArticuloRef;
import pe.restaurant.compras.entity.Cotizacion;
import pe.restaurant.compras.entity.CotizacionDet;
import pe.restaurant.compras.entity.EntidadContribuyenteRef;
import pe.restaurant.compras.entity.MonedaRef;
import pe.restaurant.compras.mapper.CotizacionMapper;
import pe.restaurant.compras.service.CotizacionService;
import pe.restaurant.compras.service.OrdenCompraService;
import pe.restaurant.compras.repository.ArticuloRefRepository;
import pe.restaurant.compras.repository.CotizacionRepository;
import pe.restaurant.compras.repository.EntidadContribuyenteRefRepository;
import pe.restaurant.compras.repository.MonedaRefRepository;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CotizacionServiceImpl implements CotizacionService {

    private final CotizacionRepository cotizacionRepository;
    private final CotizacionMapper cotizacionMapper;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final ArticuloRefRepository articuloRefRepository;
    private final OrdenCompraService ordenCompraService;

    @Override
    @Timed(value = "cotizacion.listar")
    public Page<CotizacionResponse> listar(Long proveedorId, String flagEstado,
                                              LocalDate fechaDesde, LocalDate fechaHasta,
                                              Pageable pageable) {
        Specification<Cotizacion> spec = Specification.allOf();

        if (proveedorId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("proveedorId"), proveedorId));
        }
        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }
        if (fechaDesde != null) {
            spec = spec.and((root, q, cb) -> cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
        }
        if (fechaHasta != null) {
            spec = spec.and((root, q, cb) -> cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
        }

        Long sucursalId = TenantContext.getSucursalId();
        if (sucursalId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("sucursalId"), sucursalId));
        }

        return cotizacionRepository.findAll(spec, pageable).map(this::toResponse);
    }

    @Override
    @Timed(value = "cotizacion.obtener")
    public CotizacionDetalleResponse obtener(Long id) {
        return toDetalleResponse(buscar(id));
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.crear")
    public CotizacionDetalleResponse crear(CotizacionRequest request) {
        validarProveedorExiste(request.getProveedorId());
        if (request.getMonedaId() != null) {
            validarMonedaExiste(request.getMonedaId());
        }

        Cotizacion cotizacion = cotizacionMapper.toEntity(request);
        cotizacion.setSucursalId(TenantContext.getSucursalId());
        cotizacion.setFlagEstado("1");
        cotizacion.setCreatedBy(TenantContext.getUsuarioId());

        for (CotizacionDetRequest lr : request.getLineas()) {
            validarArticuloExiste(lr.getArticuloId());
            CotizacionDet det = cotizacionMapper.toDetEntity(lr);
            if (det.getDescuento() == null) {
                det.setDescuento(BigDecimal.ZERO);
            }
            det.setCreatedBy(TenantContext.getUsuarioId());
            cotizacion.addLinea(det);
        }

        calcularTotal(cotizacion);

        Cotizacion saved = cotizacionRepository.save(cotizacion);
        log.info("Cotización {} creada por usuario {}", saved.getId(), TenantContext.getUsuarioId());
        return toDetalleResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.actualizar")
    public CotizacionDetalleResponse actualizar(Long id, CotizacionRequest request) {
        Cotizacion cotizacion = buscar(id);

        if (!"1".equals(cotizacion.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede editar una cotización activa",
                    HttpStatus.CONFLICT, "COT-002");
        }

        validarProveedorExiste(request.getProveedorId());
        if (request.getMonedaId() != null) {
            validarMonedaExiste(request.getMonedaId());
        }

        cotizacionMapper.updateEntity(request, cotizacion);
        cotizacion.setUpdatedBy(TenantContext.getUsuarioId());

        cotizacion.getLineas().clear();
        for (CotizacionDetRequest lr : request.getLineas()) {
            validarArticuloExiste(lr.getArticuloId());
            CotizacionDet det = cotizacionMapper.toDetEntity(lr);
            if (det.getDescuento() == null) {
                det.setDescuento(BigDecimal.ZERO);
            }
            det.setCreatedBy(TenantContext.getUsuarioId());
            cotizacion.addLinea(det);
        }

        calcularTotal(cotizacion);

        Cotizacion saved = cotizacionRepository.save(cotizacion);
        log.info("Cotización {} actualizada por usuario {}", saved.getId(), TenantContext.getUsuarioId());
        return toDetalleResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.seleccionar")
    public CotizacionDetalleResponse seleccionar(Long id) {
        Cotizacion cotizacion = buscar(id);

        if (!"1".equals(cotizacion.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede seleccionar una cotización activa",
                    HttpStatus.CONFLICT, "COT-003");
        }

        cotizacion.setFlagEstado("1");
        cotizacion.setUpdatedBy(TenantContext.getUsuarioId());

        Cotizacion saved = cotizacionRepository.save(cotizacion);
        log.info("Cotización {} seleccionada por usuario {}", saved.getId(), TenantContext.getUsuarioId());
        return toDetalleResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.descartar")
    public CotizacionDetalleResponse descartar(Long id) {
        Cotizacion cotizacion = buscar(id);

        if (!"1".equals(cotizacion.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede descartar una cotización activa",
                    HttpStatus.CONFLICT, "COT-004");
        }

        cotizacion.setFlagEstado("0");
        cotizacion.setUpdatedBy(TenantContext.getUsuarioId());

        Cotizacion saved = cotizacionRepository.save(cotizacion);
        log.info("Cotización {} descartada por usuario {}", saved.getId(), TenantContext.getUsuarioId());
        return toDetalleResponse(saved);
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.anular")
    public CotizacionDetalleResponse anular(Long id, String motivo) {
        Cotizacion cotizacion = buscar(id);

        if ("2".equals(cotizacion.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede anular una cotización cerrada",
                    HttpStatus.CONFLICT, "COT-005");
        }

        cotizacion.setFlagEstado("0");
        cotizacion.setUpdatedBy(TenantContext.getUsuarioId());

        Cotizacion saved = cotizacionRepository.save(cotizacion);
        log.info("Cotización {} anulada por usuario {}. Motivo: {}", saved.getId(), TenantContext.getUsuarioId(), motivo);
        return toDetalleResponse(saved);
    }

    @Override
    @Timed(value = "cotizacion.comparativo")
    public ComparativoCotizacionesResponse comparativo(List<Long> proveedorIds,
                                                         LocalDate fechaDesde,
                                                         LocalDate fechaHasta) {
        Specification<Cotizacion> spec = (root, q, cb) -> {
            var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
            if (proveedorIds != null && !proveedorIds.isEmpty()) {
                predicates.add(root.get("proveedorId").in(proveedorIds));
            }
            predicates.add(cb.equal(root.get("flagEstado"), "1"));
            Long sid = TenantContext.getSucursalId();
            if (sid != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sid));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };

        List<Cotizacion> cotizaciones = cotizacionRepository.findAll(spec);

        java.util.Map<Long, ComparativoCotizacionesResponse.ArticuloComparativo.ArticuloComparativoBuilder> articulosMap = new java.util.LinkedHashMap<>();

        for (Cotizacion cot : cotizaciones) {
            cot.getLineas().size();
            EntidadContribuyenteRef prov = entidadContribuyenteRefRepository.findById(cot.getProveedorId()).orElse(null);
            for (CotizacionDet det : cot.getLineas()) {
                articulosMap.computeIfAbsent(det.getArticuloId(), artId -> {
                    ArticuloRef art = articuloRefRepository.findById(artId).orElse(null);
                    return ComparativoCotizacionesResponse.ArticuloComparativo.builder()
                            .articuloId(artId)
                            .articuloCodigo(art != null ? art.getCodigo() : null)
                            .articuloNombre(art != null ? art.getNombre() : null)
                            .ofertas(new java.util.ArrayList<>());
                });
                articulosMap.get(det.getArticuloId()).build().getOfertas().add(
                        ComparativoCotizacionesResponse.OfertaProveedor.builder()
                                .cotizacionId(cot.getId())
                                .proveedorId(cot.getProveedorId())
                                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                                .precioUnitario(det.getPrecioUnitario())
                                .descuento(det.getDescuento())
                                .plazoEntregaDias(det.getPlazoEntregaDias())
                                .cantidad(det.getCantidad())
                                .build());
            }
        }

        List<ComparativoCotizacionesResponse.ArticuloComparativo> articulos = articulosMap.values().stream()
                .map(ComparativoCotizacionesResponse.ArticuloComparativo.ArticuloComparativoBuilder::build)
                .collect(Collectors.toList());

        return ComparativoCotizacionesResponse.builder()
                .articulos(articulos)
                .build();
    }

    @Override
    @Transactional
    @Timed(value = "cotizacion.convertir_oc")
    public OrdenCompraDetalleResponse convertirOc(Long id, ConvertirOcRequest request) {
        Cotizacion cot = buscar(id);

        if (!"1".equals(cot.getFlagEstado())) {
            throw new BusinessException(
                    "Solo se puede convertir a OC una cotización activa",
                    HttpStatus.CONFLICT, "COT-020");
        }

        cot.setFlagEstado("2");
        cot.setUpdatedBy(TenantContext.getUsuarioId());
        cotizacionRepository.save(cot);

        OrdenCompraCabeceraRequest ocRequest = new OrdenCompraCabeceraRequest();
        ocRequest.setSucursalId(cot.getSucursalId());
        ocRequest.setProveedorId(cot.getProveedorId());
        ocRequest.setFechaEmision(request.getFechaEmision());
        ocRequest.setFechaEntrega(request.getFechaEntrega());
        ocRequest.setMonedaId(cot.getMonedaId());
        ocRequest.setFormaPagoId(request.getFormaPagoId());
        ocRequest.setObservaciones(request.getObservaciones());

        List<OrdenCompraLineaRequest> lineas = cot.getLineas().stream()
                .map(det -> {
                    OrdenCompraLineaRequest lr = new OrdenCompraLineaRequest();
                    lr.setArticuloId(det.getArticuloId());
                    lr.setCantProyectada(det.getCantidad());
                    lr.setValorUnitario(det.getPrecioUnitario());
                    lr.setFechaEntrega(request.getFechaEntrega());
                    return lr;
                })
                .collect(Collectors.toList());
        ocRequest.setLineas(lineas);

        log.info("Cotización {} convertida a OC por usuario {}", cot.getId(), TenantContext.getUsuarioId());
        return ordenCompraService.crear(ocRequest);
    }

    private Cotizacion buscar(Long id) {
        Cotizacion c = cotizacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion", id));
        c.getLineas().size();
        return c;
    }

    private void calcularTotal(Cotizacion cotizacion) {
        BigDecimal total = BigDecimal.ZERO;
        for (CotizacionDet det : cotizacion.getLineas()) {
            BigDecimal lineTotal = det.getCantidad()
                    .multiply(det.getPrecioUnitario())
                    .subtract(safe(det.getDescuento()))
                    .setScale(4, RoundingMode.HALF_UP);
            total = total.add(lineTotal);
        }
        cotizacion.setTotal(total);
    }

    private void validarProveedorExiste(Long proveedorId) {
        EntidadContribuyenteRef proveedor = entidadContribuyenteRefRepository.findById(proveedorId)
                .orElseThrow(() -> new BusinessException(
                        "Proveedor con id " + proveedorId + " no existe o está inactivo",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COT-010"));
        if (!"1".equals(proveedor.getFlagEstado())) {
            throw new BusinessException(
                    "Proveedor con id " + proveedorId + " no existe o está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COT-010");
        }
    }

    private void validarMonedaExiste(Long monedaId) {
        if (!monedaRefRepository.existsById(monedaId)) {
            throw new BusinessException(
                    "Moneda con id " + monedaId + " no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COT-011");
        }
    }

    private void validarArticuloExiste(Long articuloId) {
        if (!articuloRefRepository.existsById(articuloId)) {
            throw new BusinessException(
                    "Artículo con id " + articuloId + " no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COT-012");
        }
    }

    private CotizacionResponse toResponse(Cotizacion c) {
        EntidadContribuyenteRef prov = c.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(c.getProveedorId()).orElse(null)
                : null;
        MonedaRef moneda = c.getMonedaId() != null
                ? monedaRefRepository.findById(c.getMonedaId()).orElse(null)
                : null;

        return CotizacionResponse.builder()
                .id(c.getId())
                .sucursalId(c.getSucursalId())
                .proveedorId(c.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .fecha(c.getFecha())
                .monedaId(c.getMonedaId())
                .monedaCodigo(moneda != null ? moneda.getCodigo() : null)
                .total(c.getTotal())
                .flagEstado(c.getFlagEstado())
                .build();
    }

    private CotizacionDetalleResponse toDetalleResponse(Cotizacion c) {
        EntidadContribuyenteRef prov = c.getProveedorId() != null
                ? entidadContribuyenteRefRepository.findById(c.getProveedorId()).orElse(null)
                : null;
        MonedaRef moneda = c.getMonedaId() != null
                ? monedaRefRepository.findById(c.getMonedaId()).orElse(null)
                : null;

        List<CotizacionDetResponse> lineas = c.getLineas().stream()
                .map(this::toDetResponse)
                .collect(Collectors.toList());

        return CotizacionDetalleResponse.builder()
                .id(c.getId())
                .sucursalId(c.getSucursalId())
                .proveedorId(c.getProveedorId())
                .proveedorRazonSocial(prov != null ? prov.getNombreCompleto() : null)
                .proveedorRuc(prov != null ? prov.getNroDocumento() : null)
                .fecha(c.getFecha())
                .monedaId(c.getMonedaId())
                .monedaCodigo(moneda != null ? moneda.getCodigo() : null)
                .total(c.getTotal())
                .flagEstado(c.getFlagEstado())
                .createdBy(c.getCreatedBy())
                .fecCreacion(c.getFecCreacion())
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(c.getFecModificacion())
                .lineas(lineas)
                .build();
    }

    private CotizacionDetResponse toDetResponse(CotizacionDet d) {
        ArticuloRef articulo = articuloRefRepository.findById(d.getArticuloId()).orElse(null);

        return CotizacionDetResponse.builder()
                .id(d.getId())
                .articuloId(d.getArticuloId())
                .articuloCodigo(articulo != null ? articulo.getCodigo() : null)
                .articuloDescripcion(articulo != null ? articulo.getNombre() : null)
                .cantidad(d.getCantidad())
                .precioUnitario(d.getPrecioUnitario())
                .descuento(d.getDescuento())
                .plazoEntregaDias(d.getPlazoEntregaDias())
                .build();
    }

    private BigDecimal safe(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }
}
