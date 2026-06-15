package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.ComandaCabeceraRequest;
import com.sigre.comercializacion.dto.request.ComandaEstadoRequest;
import com.sigre.comercializacion.dto.request.ComandaItemRequest;
import com.sigre.comercializacion.dto.request.ComandaItemsAppendRequest;
import com.sigre.comercializacion.dto.response.ComandaDetResponse;
import com.sigre.comercializacion.dto.response.ComandaResponse;
import com.sigre.comercializacion.entity.Comanda;
import com.sigre.comercializacion.entity.ComandaDet;
import com.sigre.comercializacion.repository.ArticuloRepository;
import com.sigre.comercializacion.repository.ComandaRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;
import com.sigre.comercializacion.specification.ComandaSpecifications;
import com.sigre.comercializacion.service.ComandaService;
import com.sigre.comercializacion.service.VentasErrorCodes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ComandaServiceImpl implements ComandaService {

    private static final Set<String> FLAG_ESTADOS_VALIDOS = Set.of("0", "1", "2", "3");

    private final ComandaRepository comandaRepository;
    private final ArticuloRepository articuloRepository;
    private final VentasFkValidator fkValidator;

    @Override
    public Page<Comanda> findAll(Long sucursalId, Long puntoVentaId, String mesa, String flagEstado,
                                 Instant fechaDesde, Instant fechaHasta, Pageable pageable) {
        Long sid = sucursalId != null ? sucursalId : TenantContext.getSucursalId();
        return comandaRepository.findAll(
                ComandaSpecifications.filtered(sid, puntoVentaId, mesa, flagEstado, fechaDesde, fechaHasta),
                pageable);
    }

    @Override
    public ComandaResponse getById(Long id) {
        return toResponse(loadWithDetalles(id));
    }

    @Override
    @Transactional
    public ComandaResponse create(ComandaCabeceraRequest request) {
        Long usuarioId = requireUsuario();
        Long sucursalId = resolveSucursalId(request.getSucursalId());
        validateCabeceraFk(sucursalId, request.getPuntoVentaId(), request.getClienteId());

        Comanda c = new Comanda();
        c.setSucursalId(sucursalId);
        c.setPuntoVentaId(request.getPuntoVentaId());
        c.setTurnoId(request.getTurnoId());
        c.setClienteId(request.getClienteId());
        c.setMesa(request.getMesa());
        c.setFechaHora(request.getFechaHora() != null ? request.getFechaHora() : Instant.now());
        c.setCreatedBy(usuarioId);
        c.setFlagEstado("1");

        List<ComandaDet> dets = buildDetalles(c, request.getItems());
        c.setDetalles(dets);
        recalcTotal(c);

        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public ComandaResponse update(Long id, ComandaCabeceraRequest request) {
        Long usuarioId = requireUsuario();
        Comanda c = loadWithDetalles(id);
        requireFlagActivo(c);
        requireEstadoItemsEditable(c);

        Long sucursalId = resolveSucursalId(request.getSucursalId());
        if (!Objects.equals(c.getSucursalId(), sucursalId)) {
            throw new BusinessException("La comanda no pertenece a la sucursal indicada", HttpStatus.CONFLICT, VentasErrorCodes.COMANDA_FK);
        }
        validateCabeceraFk(sucursalId, request.getPuntoVentaId(), request.getClienteId());

        c.setPuntoVentaId(request.getPuntoVentaId());
        c.setTurnoId(request.getTurnoId());
        c.setClienteId(request.getClienteId());
        c.setMesa(request.getMesa());
        if (request.getFechaHora() != null) {
            c.setFechaHora(request.getFechaHora());
        }
        c.getDetalles().clear();
        c.getDetalles().addAll(buildDetalles(c, request.getItems()));
        recalcTotal(c);
        c.setUpdatedBy(usuarioId);

        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public ComandaResponse addItems(Long id, ComandaItemsAppendRequest request) {
        Long usuarioId = requireUsuario();
        Comanda c = loadWithDetalles(id);
        requireFlagActivo(c);
        requireEstadoItemsEditable(c);

        c.getDetalles().addAll(buildDetalles(c, request.getItems()));
        recalcTotal(c);
        c.setUpdatedBy(usuarioId);

        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public ComandaResponse patchEstado(Long id, ComandaEstadoRequest request) {
        Long usuarioId = requireUsuario();
        Comanda c = loadWithDetalles(id);
        requireFlagActivo(c);

        String nuevo = request.getFlagEstado() != null ? request.getFlagEstado().trim() : "";
        if (!FLAG_ESTADOS_VALIDOS.contains(nuevo)) {
            throw new BusinessException("flagEstado no válido", HttpStatus.BAD_REQUEST, VentasErrorCodes.COMANDA_STATE);
        }
        String actual = c.getFlagEstado();
        if (!isTransicionValida(actual, nuevo)) {
            throw new BusinessException("Transición de estado no permitida", HttpStatus.CONFLICT, VentasErrorCodes.COMANDA_STATE);
        }
        c.setFlagEstado(nuevo);
        c.setUpdatedBy(usuarioId);
        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public ComandaResponse anular(Long id) {
        ComandaEstadoRequest r = new ComandaEstadoRequest();
        r.setFlagEstado("0");
        return patchEstado(id, r);
    }

    @Override
    @Transactional
    public ComandaResponse activate(Long id) {
        Long usuarioId = requireUsuario();
        Comanda c = loadWithDetalles(id);
        c.setFlagEstado("1");
        c.setUpdatedBy(usuarioId);
        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public ComandaResponse deactivate(Long id) {
        Long usuarioId = requireUsuario();
        Comanda c = loadWithDetalles(id);
        c.setFlagEstado("0");
        c.setUpdatedBy(usuarioId);
        return toResponse(comandaRepository.save(c));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        deactivate(id);
    }

    private Comanda loadWithDetalles(Long id) {
        return comandaRepository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Comanda", id));
    }

    private void requireFlagActivo(Comanda c) {
        if (!"1".equals(c.getFlagEstado())) {
            throw new BusinessException("La comanda está inactiva", HttpStatus.CONFLICT, VentasErrorCodes.COMANDA_STATE);
        }
    }

    private void requireEstadoItemsEditable(Comanda c) {
        if (!"1".equals(c.getFlagEstado())) {
            throw new BusinessException("Solo se pueden modificar ítems en comanda activa", HttpStatus.CONFLICT, VentasErrorCodes.COMANDA_STATE);
        }
    }

    private boolean isTransicionValida(String actual, String nuevo) {
        if (Objects.equals(actual, nuevo)) {
            return true;
        }
        if ("0".equals(actual) || "2".equals(actual)) {
            return false;
        }
        return switch (actual) {
            case "1" -> "3".equals(nuevo) || "2".equals(nuevo) || "0".equals(nuevo);
            case "3" -> "2".equals(nuevo) || "0".equals(nuevo);
            default -> false;
        };
    }

    private Long resolveSucursalId(Long requested) {
        Long ctx = TenantContext.getSucursalId();
        if (requested == null) {
            if (ctx == null) {
                throw new BusinessException("sucursalId requerido", HttpStatus.BAD_REQUEST, VentasErrorCodes.COMANDA_FK);
            }
            return ctx;
        }
        if (ctx != null && !ctx.equals(requested)) {
            throw new BusinessException("sucursalId no coincide con el token", HttpStatus.FORBIDDEN, VentasErrorCodes.COMANDA_FK);
        }
        if (!fkValidator.existsSucursalActiva(requested)) {
            throw new BusinessException("Sucursal no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.COMANDA_FK);
        }
        return requested;
    }

    private Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no resoluble desde el token", HttpStatus.UNAUTHORIZED, VentasErrorCodes.COMANDA_FK);
        }
        return uid;
    }

    private void validateCabeceraFk(Long sucursalId, Long puntoVentaId, Long clienteId) {
        if (puntoVentaId != null && !fkValidator.existsPuntoVentaActivo(puntoVentaId, sucursalId)) {
            throw new BusinessException("Punto de venta no válido para la sucursal", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.COMANDA_FK);
        }
        if (clienteId != null && !fkValidator.existsEntidadContribuyenteActiva(clienteId)) {
            throw new BusinessException("Cliente no válido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.COMANDA_FK);
        }
    }

    private void validateArticulo(Long articuloId) {
        if (!articuloRepository.existsByIdAndFlagEstado(articuloId, "1")) {
            throw new BusinessException("Artículo no válido o inactivo", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.COMANDA_FK);
        }
    }

    private List<ComandaDet> buildDetalles(Comanda comanda, List<ComandaItemRequest> items) {
        List<ComandaDet> list = new ArrayList<>();
        for (ComandaItemRequest it : items) {
            validateArticulo(it.getArticuloId());
            ComandaDet d = new ComandaDet();
            d.setComanda(comanda);
            d.setArticuloId(it.getArticuloId());
            d.setCantidad(it.getCantidad());
            d.setPrecioUnitario(it.getPrecioUnitario());
            d.setSubtotal(lineSubtotal(it.getCantidad(), it.getPrecioUnitario()));
            d.setObservacion(it.getObservacion());
            d.setCreatedBy(TenantContext.getUsuarioId());
            d.setFlagEstado("1");
            list.add(d);
        }
        return list;
    }

    private static BigDecimal lineSubtotal(BigDecimal cantidad, BigDecimal precioUnitario) {
        return cantidad.multiply(precioUnitario).setScale(4, RoundingMode.HALF_UP);
    }

    private static void recalcTotal(Comanda c) {
        BigDecimal t = c.getDetalles().stream()
                .map(ComandaDet::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .setScale(4, RoundingMode.HALF_UP);
        c.setTotal(t);
    }

    private ComandaResponse toResponse(Comanda c) {
        List<ComandaDetResponse> items = c.getDetalles() == null ? List.of() : c.getDetalles().stream()
                .map(d -> ComandaDetResponse.builder()
                        .id(d.getId())
                        .articuloId(d.getArticuloId())
                        .cantidad(d.getCantidad())
                        .precioUnitario(d.getPrecioUnitario())
                        .subtotal(d.getSubtotal())
                        .observacion(d.getObservacion())
                        .flagEstado(d.getFlagEstado())
                        .build())
                .toList();
        return ComandaResponse.builder()
                .id(c.getId())
                .sucursalId(c.getSucursalId())
                .puntoVentaId(c.getPuntoVentaId())
                .turnoId(c.getTurnoId())
                .clienteId(c.getClienteId())
                .mesa(c.getMesa())
                .fechaHora(c.getFechaHora())
                .total(c.getTotal())
                .flagEstado(c.getFlagEstado())
                .createdBy(c.getCreatedBy())
                .fecCreacion(c.getFecCreacion())
                .updatedBy(c.getUpdatedBy())
                .fecModificacion(c.getFecModificacion())
                .items(items)
                .build();
    }
}
