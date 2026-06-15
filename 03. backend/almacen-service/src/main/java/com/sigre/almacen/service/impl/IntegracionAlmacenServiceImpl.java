package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.entity.OrdenTraslado;
import com.sigre.almacen.entity.OrdenTrasladoDet;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.ArticuloMovTipoRepository;
import com.sigre.almacen.repository.OrdenTrasladoDetRepository;
import com.sigre.almacen.repository.OrdenTrasladoRepository;
import com.sigre.almacen.config.AlmacenIntegracionProperties;
import com.sigre.almacen.repository.ValeMovRepository;
import com.sigre.almacen.service.IntegracionAlmacenService;
import com.sigre.almacen.service.RecepcionTresViasValidator;
import com.sigre.almacen.service.ValeMovService;
import com.sigre.common.exception.BusinessException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Bloque F: orquestación sobre {@link ValeMovService#crear} para recepción OC, despacho OV y traslado OT+espejo.
 */
@Service
@RequiredArgsConstructor
public class IntegracionAlmacenServiceImpl implements IntegracionAlmacenService {

    private final ValeMovService valeMovService;
    private final JdbcTemplate jdbcTemplate;
    private final ArticuloMovTipoRepository articuloMovTipoRepository;
    private final OrdenTrasladoRepository ordenTrasladoRepository;
    private final OrdenTrasladoDetRepository ordenTrasladoDetRepository;
    private final AlmacenRepository almacenRepository;
    private final ValeMovRepository valeMovRepository;
    private final RecepcionTresViasValidator recepcionTresViasValidator;
    private final AlmacenIntegracionProperties integracionProperties;

    @Override
    @Transactional
    public MovimientoDetalleResponse recepcionarOrdenCompra(IntegracionRecepcionOcRequest request) {
        cargarTipoIntegracion(request.getArticuloMovTipoId(), 'I', false);

        boolean validarTresVias = request.getValidarTresVias() != null
                ? request.getValidarTresVias()
                : integracionProperties.isValidarTresVias();
        if (validarTresVias) {
            BigDecimal tol = request.getToleranciaTresVias() != null
                    ? request.getToleranciaTresVias()
                    : integracionProperties.getToleranciaTresVias();
            recepcionTresViasValidator.validarRecepcionOc(
                    request.getOrdenCompraId(),
                    request.getAlmacenId(),
                    request.getInventarioConteoId(),
                    tol);
        }

        List<Map<String, Object>> cab = jdbcTemplate.queryForList(
                "SELECT sucursal_id, proveedor_id FROM compras.orden_compra WHERE id = ? AND flag_estado = '1'",
                request.getOrdenCompraId());
        if (cab.isEmpty()) {
            throw new BusinessException(
                    "Orden de compra no encontrada o anulada.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        Map<String, Object> head = cab.get(0);
        Long sucursalId = numberToLong(head.get("sucursal_id"));
        Long proveedorId = numberToLong(head.get("proveedor_id"));

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, articulo_id, cant_proyectada, cant_procesada, valor_unitario, almacen_id, centros_costo_id "
                        + "FROM compras.orden_compra_det WHERE orden_compra_id = ? AND flag_estado = '1' ORDER BY id",
                request.getOrdenCompraId());

        Long almacenFiltro = request.getAlmacenId();
        List<MovimientoLineaRequest> lineas = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            Long lineAlm = numberToLong(row.get("almacen_id"));
            if (lineAlm != null && !lineAlm.equals(almacenFiltro)) {
                continue;
            }
            BigDecimal proj = bd(row.get("cant_proyectada"));
            BigDecimal proc = bd(row.get("cant_procesada"));
            BigDecimal pend = proj.subtract(proc);
            if (pend.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            MovimientoLineaRequest lr = new MovimientoLineaRequest();
            lr.setArticuloId(numberToLong(row.get("articulo_id")));
            lr.setCantProcesada(pend);
            lr.setCostoUnitario(bd(row.get("valor_unitario")));
            lr.setOcDetId(numberToLong(row.get("id")));
            lr.setCentrosCostoId(numberToLong(row.get("centros_costo_id")));
            lineas.add(lr);
        }

        if (lineas.isEmpty()) {
            throw new BusinessException(
                    "No hay líneas pendientes de recepción para esta OC y el almacén indicado.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
        }
        assertArticulosUnicos(lineas);

        MovimientoCabeceraRequest cabReq = new MovimientoCabeceraRequest();
        cabReq.setSucursalId(sucursalId);
        cabReq.setAlmacenId(almacenFiltro);
        cabReq.setArticuloMovTipoId(request.getArticuloMovTipoId());
        cabReq.setFechaMov(request.getFechaMov() != null ? request.getFechaMov() : LocalDate.now());
        cabReq.setProveedorId(proveedorId);
        cabReq.setTipoReferenciaOrigen("I");
        cabReq.setOrdenCompraId(request.getOrdenCompraId());
        cabReq.setObservaciones(request.getObservaciones());
        cabReq.setLineas(lineas);

        return valeMovService.crear(cabReq);
    }

    @Override
    @Transactional
    public MovimientoDetalleResponse despacharOrdenVenta(IntegracionSalidaOvRequest request) {
        cargarTipoIntegracion(request.getArticuloMovTipoId(), 'V', false);

        List<Map<String, Object>> cab = jdbcTemplate.queryForList(
                "SELECT sucursal_id FROM ventas.orden_venta WHERE id = ? AND flag_estado = '1'",
                request.getOrdenVentaId());
        if (cab.isEmpty()) {
            throw new BusinessException(
                    "Orden de venta no encontrada o anulada.",
                    HttpStatus.NOT_FOUND, MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }
        Long sucursalId = numberToLong(cab.get(0).get("sucursal_id"));

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT id, articulo_id, cant_proyectada, cant_procesada, valor_unitario, almacen_id, centros_costo_id "
                        + "FROM ventas.orden_venta_det WHERE orden_venta_id = ? AND flag_estado = '1' ORDER BY id",
                request.getOrdenVentaId());

        Long almacenFiltro = request.getAlmacenId();
        List<MovimientoLineaRequest> lineas = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            Long lineAlm = numberToLong(row.get("almacen_id"));
            if (lineAlm != null && !lineAlm.equals(almacenFiltro)) {
                continue;
            }
            BigDecimal proj = bd(row.get("cant_proyectada"));
            BigDecimal proc = bd(row.get("cant_procesada"));
            BigDecimal pend = proj.subtract(proc);
            if (pend.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            MovimientoLineaRequest lr = new MovimientoLineaRequest();
            lr.setArticuloId(numberToLong(row.get("articulo_id")));
            lr.setCantProcesada(pend);
            lr.setCostoUnitario(bd(row.get("valor_unitario")));
            lr.setOrdenVentaDetId(numberToLong(row.get("id")));
            lr.setCentrosCostoId(numberToLong(row.get("centros_costo_id")));
            lineas.add(lr);
        }

        if (lineas.isEmpty()) {
            throw new BusinessException(
                    "No hay líneas pendientes de despacho para esta OV y el almacén indicado.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
        }
        assertArticulosUnicos(lineas);

        MovimientoCabeceraRequest cabReq = new MovimientoCabeceraRequest();
        cabReq.setSucursalId(sucursalId);
        cabReq.setAlmacenId(almacenFiltro);
        cabReq.setArticuloMovTipoId(request.getArticuloMovTipoId());
        cabReq.setFechaMov(request.getFechaMov() != null ? request.getFechaMov() : LocalDate.now());
        cabReq.setTipoReferenciaOrigen("V");
        cabReq.setOrdenVentaId(request.getOrdenVentaId());
        cabReq.setObservaciones(request.getObservaciones());
        cabReq.setLineas(lineas);

        return valeMovService.crear(cabReq);
    }

    @Override
    @Transactional
    public IntegracionTrasladoResultadoResponse ejecutarTraslado(IntegracionTrasladoEjecutarRequest request) {
        ArticuloMovTipo tipoSalida = cargarTipoIntegracion(request.getArticuloMovTipoId(), 'T', true);

        OrdenTraslado ot = ordenTrasladoRepository.findByIdForUpdate(request.getOrdenTrasladoId())
                .orElseThrow(() -> new BusinessException(
                        "Orden de traslado no encontrada.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.ORDEN_TRASLADO_NO_ENCONTRADA));

        Long almacenOrigenId = ot.getAlmacenOrigenId();
        Long sucursalId = almacenRepository.findById(almacenOrigenId)
                .orElseThrow(() -> new BusinessException(
                        "Almacén origen no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.ALMACEN_NO_ENCONTRADO))
                .getSucursalId();

        List<OrdenTrasladoDet> dets = ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(request.getOrdenTrasladoId());
        List<MovimientoLineaRequest> lineas = new ArrayList<>();
        for (OrdenTrasladoDet det : dets) {
            BigDecimal cant = det.getCantidad() != null ? det.getCantidad() : BigDecimal.ZERO;
            BigDecimal desp = det.getCantidadDespachada() != null ? det.getCantidadDespachada() : BigDecimal.ZERO;
            BigDecimal pend = cant.subtract(desp);
            if (pend.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            MovimientoLineaRequest lr = new MovimientoLineaRequest();
            lr.setArticuloId(det.getArticuloId());
            lr.setCantProcesada(pend);
            lr.setOrdenTrasladoDetId(det.getId());
            lineas.add(lr);
        }

        if (lineas.isEmpty()) {
            throw new BusinessException(
                    "No hay cantidad pendiente por despachar en esta orden de traslado.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
        }
        assertArticulosUnicos(lineas);

        MovimientoCabeceraRequest cabReq = new MovimientoCabeceraRequest();
        cabReq.setSucursalId(sucursalId);
        cabReq.setAlmacenId(almacenOrigenId);
        cabReq.setArticuloMovTipoId(tipoSalida.getId());
        cabReq.setFechaMov(request.getFechaMov() != null ? request.getFechaMov() : ot.getFecha());
        cabReq.setTipoReferenciaOrigen("T");
        cabReq.setOrdenTrasladoId(request.getOrdenTrasladoId());
        cabReq.setObservaciones(request.getObservaciones());
        cabReq.setLineas(lineas);

        MovimientoDetalleResponse salida = valeMovService.crear(cabReq);
        Long salidaId = salida.getId();
        if (!"1".equals(tipoSalida.getFlagMovEntreAlm())) {
            return new IntegracionTrasladoResultadoResponse(salida, null);
        }

        ValeMov espejo = valeMovRepository
                .findFirstByOrdenTrasladoIdAndIdGreaterThanOrderByIdAsc(request.getOrdenTrasladoId(), salidaId)
                .orElseThrow(() -> new BusinessException(
                        "No se generó el vale de ingreso espejo para el traslado.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_ESPEJO_NO_GENERADO));

        return new IntegracionTrasladoResultadoResponse(salida, valeMovService.obtener(espejo.getId()));
    }

    private ArticuloMovTipo cargarTipoIntegracion(Long id, char claseEsperada, boolean exigeFlagMovEntreAlm) {
        ArticuloMovTipo t = articuloMovTipoRepository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Tipo de movimiento no encontrado.",
                        HttpStatus.NOT_FOUND, MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO));
        if (!"1".equals(t.getFlagEstado())) {
            throw new BusinessException(
                    "El tipo de movimiento está inactivo.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
        if (!"1".equals(t.getFlagSolicitaRef())) {
            throw new BusinessException(
                    "El tipo de movimiento debe tener referencia a documento origen habilitada (flag solicita ref).",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
        if (t.getFlagClaseMov() == null || t.getFlagClaseMov().isBlank()) {
            throw new BusinessException(
                    "El tipo de movimiento debe tener clase I, V o T definida.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
        if (Character.toUpperCase(t.getFlagClaseMov().charAt(0)) != claseEsperada) {
            throw new BusinessException(
                    "El tipo de movimiento no corresponde a la operación (clase esperada " + claseEsperada + ").",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
        if (exigeFlagMovEntreAlm && !"1".equals(t.getFlagMovEntreAlm())) {
            throw new BusinessException(
                    "Para traslado entre almacenes el tipo debe tener activo movimiento entre almacenes.",
                    HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
        return t;
    }

    private static void assertArticulosUnicos(List<MovimientoLineaRequest> lineas) {
        Set<Long> articulos = new HashSet<>();
        for (MovimientoLineaRequest lr : lineas) {
            if (!articulos.add(lr.getArticuloId())) {
                throw new BusinessException(
                        "Hay más de una línea pendiente para el mismo artículo; use el movimiento manual o divida el documento origen.",
                        HttpStatus.UNPROCESSABLE_ENTITY, MovimientoErrorCode.INTEGRACION_ARTICULO_DUPLICADO_EN_ORIGEN);
            }
        }
    }

    private static Long numberToLong(Object o) {
        if (o == null) {
            return null;
        }
        if (o instanceof Number n) {
            return n.longValue();
        }
        return null;
    }

    private static BigDecimal bd(Object v) {
        if (v == null) {
            return BigDecimal.ZERO;
        }
        if (v instanceof BigDecimal b) {
            return b;
        }
        return BigDecimal.valueOf(((Number) v).doubleValue());
    }
}
