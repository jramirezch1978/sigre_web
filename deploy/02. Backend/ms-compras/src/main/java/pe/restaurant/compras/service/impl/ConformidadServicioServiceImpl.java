package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.dto.OrdenServicioPendienteConformidadResponse;
import pe.restaurant.compras.entity.ConformidadServicio;
import pe.restaurant.compras.entity.ConformidadServicioDet;
import pe.restaurant.compras.entity.EntidadContribuyenteRef;
import pe.restaurant.compras.entity.OrdenServicio;
import pe.restaurant.compras.mapper.ConformidadServicioMapper;
import pe.restaurant.compras.repository.ConformidadServicioRepository;
import pe.restaurant.compras.repository.EntidadContribuyenteRefRepository;
import pe.restaurant.compras.repository.OrdenServicioRepository;
import pe.restaurant.compras.service.ConformidadServicioService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ConformidadServicioServiceImpl implements ConformidadServicioService {

    private final ConformidadServicioRepository repository;
    private final ConformidadServicioMapper mapper;
    private final OrdenServicioRepository ordenServicioRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "listar"})
    @Override
    public Page<ConformidadServicioResponse> listar(Long ordenServicioId, Boolean aprobado,
                                                     String flagEstado,
                                                     LocalDate fechaDesde, LocalDate fechaHasta,
                                                     Pageable pageable) {
        Specification<ConformidadServicio> spec = Specification.allOf();

        if (ordenServicioId != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("ordenServicioId"), ordenServicioId));
        }
        if (aprobado != null) {
            spec = spec.and((root, q, cb) -> cb.equal(root.get("aprobado"), aprobado));
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

        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "obtener"})
    @Override
    public ConformidadServicioDetalleResponse obtener(Long id) {
        return mapper.toDetalleResponse(buscar(id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "crear"})
    @Override
    @Transactional
    public ConformidadServicioDetalleResponse crear(ConformidadServicioRequest request) {
        validarOrdenServicioExiste(request.getOrdenServicioId());

        ConformidadServicio entity = new ConformidadServicio();
        entity.setOrdenServicioId(request.getOrdenServicioId());
        entity.setFecha(request.getFecha());
        entity.setObservacion(request.getObservacion());
        entity.setAprobado(false);
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());

        for (ConformidadServicioDetRequest lr : request.getLineas()) {
            ConformidadServicioDet det = mapper.toDetEntity(lr);
            det.setSubtotal(calcularSubtotal(lr.getCantidad(), lr.getPrecioUnitario()));
            det.setCreatedBy(TenantContext.getUsuarioId());
            entity.addLinea(det);
        }

        ConformidadServicio saved = repository.save(entity);
        return mapper.toDetalleResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "actualizar"})
    @Override
    @Transactional
    public ConformidadServicioDetalleResponse actualizar(Long id, ConformidadServicioRequest request) {
        ConformidadServicio entity = buscar(id);

        if (Boolean.TRUE.equals(entity.getAprobado())) {
            throw new BusinessException(
                    "No se puede editar una conformidad ya aprobada",
                    HttpStatus.CONFLICT, "COM-400");
        }

        if ("0".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede editar una conformidad anulada",
                    HttpStatus.CONFLICT, "COM-401");
        }

        validarOrdenServicioExiste(request.getOrdenServicioId());

        entity.setOrdenServicioId(request.getOrdenServicioId());
        entity.setFecha(request.getFecha());
        entity.setObservacion(request.getObservacion());
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        entity.getLineas().clear();
        for (ConformidadServicioDetRequest lr : request.getLineas()) {
            ConformidadServicioDet det = mapper.toDetEntity(lr);
            det.setSubtotal(calcularSubtotal(lr.getCantidad(), lr.getPrecioUnitario()));
            det.setCreatedBy(TenantContext.getUsuarioId());
            entity.addLinea(det);
        }

        ConformidadServicio saved = repository.save(entity);
        return mapper.toDetalleResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "aprobar"})
    @Override
    @Transactional
    public ConformidadServicioDetalleResponse aprobar(Long id) {
        ConformidadServicio entity = buscar(id);

        if (Boolean.TRUE.equals(entity.getAprobado())) {
            throw new BusinessException(
                    "La conformidad ya se encuentra aprobada",
                    HttpStatus.CONFLICT, "COM-402");
        }

        if ("0".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede aprobar una conformidad anulada",
                    HttpStatus.CONFLICT, "COM-403");
        }

        entity.setAprobado(true);
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        return mapper.toDetalleResponse(repository.save(entity));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conformidad_servicio", "operation", "anular"})
    @Override
    @Transactional
    public ConformidadServicioDetalleResponse anular(Long id) {
        ConformidadServicio entity = buscar(id);

        if ("0".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                    "La conformidad ya se encuentra anulada",
                    HttpStatus.CONFLICT, "COM-404");
        }

        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());

        return mapper.toDetalleResponse(repository.save(entity));
    }

    @Override
    @Timed(value = "conformidad_servicio.pendientes")
    public Page<OrdenServicioPendienteConformidadResponse> pendientes(
            Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {

        List<Long> osIdsConConformidad = repository.findOrdenServicioIdsConConformidadAprobada();

        Specification<OrdenServicio> spec = (root, q, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("flagEstado"), "1"));
            predicates.add(cb.equal(root.get("flagSolicitaActa"), "1"));
            if (!osIdsConConformidad.isEmpty()) {
                predicates.add(cb.not(root.get("id").in(osIdsConConformidad)));
            }
            if (proveedorId != null) {
                predicates.add(cb.equal(root.get("proveedorId"), proveedorId));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecRegistro"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecRegistro"), fechaHasta));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return ordenServicioRepository.findAll(spec, pageable).map(os -> {
            String provRazonSocial = entidadContribuyenteRefRepository.findById(os.getProveedorId())
                    .map(EntidadContribuyenteRef::getNombreCompleto)
                    .orElse(null);

            return OrdenServicioPendienteConformidadResponse.builder()
                    .ordenServicioId(os.getId())
                    .nroOs(os.getNroOs())
                    .proveedorId(os.getProveedorId())
                    .proveedorRazonSocial(provRazonSocial)
                    .fecRegistro(os.getFecRegistro())
                    .montoTotal(os.getMontoTotal())
                    .flagEstado(os.getFlagEstado())
                    .build();
        });
    }

    @Override
    public byte[] generarPdf(Long id) {
        ConformidadServicio entity = buscar(id);
        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException("El acta está anulada", HttpStatus.CONFLICT, "COM-410");
        }

        StringBuilder sb = new StringBuilder();
        sb.append("ACTA DE CONFORMIDAD DE SERVICIO\n");
        sb.append("ID: ").append(entity.getId()).append("\n");
        sb.append("Orden de Servicio ID: ").append(entity.getOrdenServicioId()).append("\n");
        sb.append("Fecha: ").append(entity.getFecha()).append("\n");
        sb.append("Aprobado: ").append(entity.getAprobado()).append("\n");
        if (entity.getObservacion() != null) {
            sb.append("Observación: ").append(entity.getObservacion()).append("\n");
        }
        sb.append("\nDETALLE:\n");
        for (ConformidadServicioDet det : entity.getLineas()) {
            sb.append("  - ").append(det.getSecuencia()).append(": ")
                    .append(det.getDescripcion() != null ? det.getDescripcion() : "")
                    .append(" | Cant: ").append(det.getCantidad())
                    .append(" | PU: ").append(det.getPrecioUnitario())
                    .append(" | Sub: ").append(det.getSubtotal())
                    .append("\n");
        }
        return sb.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private ConformidadServicio buscar(Long id) {
        ConformidadServicio entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ConformidadServicio", id));
        entity.getLineas().size();
        return entity;
    }

    private void validarOrdenServicioExiste(Long ordenServicioId) {
        if (!ordenServicioRepository.existsById(ordenServicioId)) {
            throw new BusinessException(
                    "La orden de servicio con id " + ordenServicioId + " no existe",
                    HttpStatus.UNPROCESSABLE_ENTITY, "COM-405");
        }
    }

    private BigDecimal calcularSubtotal(BigDecimal cantidad, BigDecimal precioUnitario) {
        if (cantidad != null && precioUnitario != null) {
            return cantidad.multiply(precioUnitario);
        }
        return BigDecimal.ZERO;
    }
}
