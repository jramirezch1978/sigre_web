package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.dto.*;
import pe.restaurant.almacen.entity.Guia;
import pe.restaurant.almacen.entity.GuiaDet;
import pe.restaurant.almacen.repository.GuiaDetRepository;
import pe.restaurant.almacen.repository.GuiaRepository;
import pe.restaurant.almacen.repository.ValeMovRepository;
import pe.restaurant.almacen.service.GuiaRemisionService;
import pe.restaurant.almacen.spec.GuiaSpecifications;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GuiaRemisionServiceImpl implements GuiaRemisionService {

    private final GuiaRepository guiaRepository;
    private final GuiaDetRepository guiaDetRepository;
    private final ValeMovRepository valeMovRepository;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public Page<GuiaResponse> buscar(Long sucursalId,
                                     String estado,
                                     String serie,
                                     String numero,
                                     LocalDate fechaDesde,
                                     LocalDate fechaHasta,
                                     Long destinatarioId,
                                     Pageable pageable) {
        return guiaRepository.findAll(
                        GuiaSpecifications.conFiltros(
                                sucursalId, estado, serie, numero, fechaDesde, fechaHasta, destinatarioId),
                        pageable)
                .map(this::toResponseSinLineas);
    }

    @Override
    public GuiaResponse obtener(Long id) {
        Guia g = guiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Guia", id));
        return toResponseCompleto(g);
    }

    @Override
    @Transactional
    public GuiaResponse crear(GuiaRequest request) {
        validarCabecera(request);
        if (guiaRepository.existsBySucursalIdAndSerieAndNumero(
                request.getSucursalId(), request.getSerie().trim(), request.getNumero().trim())) {
            throw new BusinessException("Ya existe una guía con la misma sucursal, serie y número.",
                    HttpStatus.CONFLICT, "ALM-GUIA-001");
        }
        for (GuiaLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            assertUnidadMedidaExiste(lr.getUnidadMedidaId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-GUIA-002");
            }
        }
        Guia g = mapCabecera(request, new Guia());
        Guia guardada = guiaRepository.save(g);
        for (GuiaLineaRequest lr : request.getLineas()) {
            GuiaDet det = new GuiaDet();
            det.setGuiaId(guardada.getId());
            det.setValeMovId(lr.getValeMovId());
            det.setArticuloId(lr.getArticuloId());
            det.setUnidadMedidaId(lr.getUnidadMedidaId());
            det.setCantidad(lr.getCantidad());
            guiaDetRepository.save(det);
        }
        return toResponseCompleto(guardada);
    }

    @Override
    @Transactional
    public GuiaResponse actualizar(Long id, GuiaRequest request) {
        Guia g = guiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Guia", id));
        if (!"1".equals(g.getFlagEstado())) {
            throw new BusinessException("Solo se puede editar una guía activa.",
                    HttpStatus.CONFLICT, "ALM-GUIA-003");
        }
        validarCabecera(request);
        if (guiaRepository.existsBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndIdNot(
                request.getSucursalId(), request.getSerie().trim(), request.getNumero().trim(), id)) {
            throw new BusinessException("Ya existe otra guía con la misma sucursal, serie y número.",
                    HttpStatus.CONFLICT, "ALM-GUIA-001");
        }
        for (GuiaLineaRequest lr : request.getLineas()) {
            assertArticuloExiste(lr.getArticuloId());
            assertUnidadMedidaExiste(lr.getUnidadMedidaId());
            if (lr.getCantidad() == null || lr.getCantidad().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Cada línea debe tener cantidad mayor a cero.",
                        HttpStatus.UNPROCESSABLE_ENTITY, "ALM-GUIA-002");
            }
        }
        mapCabecera(request, g);
        guiaRepository.save(g);
        guiaDetRepository.deleteByGuiaId(id);
        for (GuiaLineaRequest lr : request.getLineas()) {
            GuiaDet det = new GuiaDet();
            det.setGuiaId(id);
            det.setValeMovId(lr.getValeMovId());
            det.setArticuloId(lr.getArticuloId());
            det.setUnidadMedidaId(lr.getUnidadMedidaId());
            det.setCantidad(lr.getCantidad());
            guiaDetRepository.save(det);
        }
        return toResponseCompleto(g);
    }

    @Override
    @Transactional
    public GuiaResponse anular(Long id) {
        Guia g = guiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Guia", id));
        if ("0".equals(g.getFlagEstado())) {
            throw new BusinessException(
                    "La guía ya está anulada.",
                    HttpStatus.CONFLICT,
                    "ALM-GUIA-004");
        }
        g.setFlagEstado("0");
        return toResponseCompleto(guiaRepository.save(g));
    }

    @Override
    @Transactional
    public GuiaResponse ponerEnTransito(Long id) {
        Guia g = guiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Guia", id));
        if (!"1".equals(g.getFlagEstado())) {
            throw new BusinessException(
                    "Solo las guías activas pueden pasar a tránsito.",
                    HttpStatus.CONFLICT,
                    "ALM-GUIA-006");
        }
        return toResponseCompleto(guiaRepository.save(g));
    }

    @Override
    @Transactional
    public GuiaResponse marcarEntregada(Long id) {
        Guia g = guiaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Guia", id));
        if (!"1".equals(g.getFlagEstado())) {
            throw new BusinessException(
                    "Solo las guías activas pueden marcarse como entregadas.",
                    HttpStatus.CONFLICT,
                    "ALM-GUIA-008");
        }
        g.setFlagEstado("2");
        return toResponseCompleto(guiaRepository.save(g));
    }

    private void validarCabecera(GuiaRequest request) {
        assertSucursalExiste(request.getSucursalId());
        assertEntidadExiste(request.getDestinatarioId());
        if (request.getMotivoTrasladoId() != null) {
            Integer m = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*)::int FROM almacen.motivo_traslado WHERE id = ?",
                    Integer.class, request.getMotivoTrasladoId());
            if (m == null || m == 0) {
                throw new ResourceNotFoundException("MotivoTraslado", request.getMotivoTrasladoId());
            }
        }
        if (request.getTransportistaId() != null) {
            assertEntidadExiste(request.getTransportistaId());
        }
        if (request.getValeMovId() != null && !valeMovRepository.existsById(request.getValeMovId())) {
            throw new ResourceNotFoundException("ValeMov", request.getValeMovId());
        }
    }

    private Guia mapCabecera(GuiaRequest r, Guia g) {
        g.setSucursalId(r.getSucursalId());
        g.setSerie(r.getSerie().trim());
        g.setNumero(r.getNumero().trim());
        g.setFechaEmision(r.getFechaEmision());
        g.setFechaTraslado(r.getFechaTraslado());
        g.setMotivoTrasladoId(r.getMotivoTrasladoId());
        g.setDestinatarioId(r.getDestinatarioId());
        g.setDireccionPartida(r.getDireccionPartida());
        g.setDireccionLlegada(r.getDireccionLlegada());
        g.setTransportistaId(r.getTransportistaId());
        g.setValeMovId(r.getValeMovId());
        return g;
    }

    private void assertSucursalExiste(Long id) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM auth.sucursal WHERE id = ?", Integer.class, id);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Sucursal", id);
        }
    }

    private void assertEntidadExiste(Long id) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.entidad_contribuyente WHERE id = ?", Integer.class, id);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("EntidadContribuyente", id);
        }
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?", Integer.class, articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private void assertUnidadMedidaExiste(Long umId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.unidad_medida WHERE id = ?", Integer.class, umId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("UnidadMedida", umId);
        }
    }

    private GuiaResponse toResponseSinLineas(Guia g) {
        return GuiaResponse.builder()
                .id(g.getId())
                .sucursalId(g.getSucursalId())
                .serie(g.getSerie())
                .numero(g.getNumero())
                .fechaEmision(g.getFechaEmision())
                .fechaTraslado(g.getFechaTraslado())
                .motivoTrasladoId(g.getMotivoTrasladoId())
                .destinatarioId(g.getDestinatarioId())
                .direccionPartida(g.getDireccionPartida())
                .direccionLlegada(g.getDireccionLlegada())
                .transportistaId(g.getTransportistaId())
                .valeMovId(g.getValeMovId())
                .flagEstado(g.getFlagEstado())
                .lineas(List.of())
                .build();
    }

    private GuiaResponse toResponseCompleto(Guia g) {
        List<GuiaDet> dets = guiaDetRepository.findByGuiaIdOrderById(g.getId());
        List<GuiaLineaResponse> lineas = new ArrayList<>();
        for (GuiaDet d : dets) {
            lineas.add(GuiaLineaResponse.builder()
                    .id(d.getId())
                    .valeMovId(d.getValeMovId())
                    .articuloId(d.getArticuloId())
                    .unidadMedidaId(d.getUnidadMedidaId())
                    .cantidad(d.getCantidad())
                    .flagEstado(d.getFlagEstado())
                    .build());
        }
        return GuiaResponse.builder()
                .id(g.getId())
                .sucursalId(g.getSucursalId())
                .serie(g.getSerie())
                .numero(g.getNumero())
                .fechaEmision(g.getFechaEmision())
                .fechaTraslado(g.getFechaTraslado())
                .motivoTrasladoId(g.getMotivoTrasladoId())
                .destinatarioId(g.getDestinatarioId())
                .direccionPartida(g.getDireccionPartida())
                .direccionLlegada(g.getDireccionLlegada())
                .transportistaId(g.getTransportistaId())
                .valeMovId(g.getValeMovId())
                .flagEstado(g.getFlagEstado())
                .lineas(lineas)
                .build();
    }
}
