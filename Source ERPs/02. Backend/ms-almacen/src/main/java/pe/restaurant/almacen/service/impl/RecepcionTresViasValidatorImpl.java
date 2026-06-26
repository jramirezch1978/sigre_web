package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.almacen.domain.MovimientoErrorCode;
import pe.restaurant.almacen.entity.InventarioConteo;
import pe.restaurant.almacen.repository.InventarioConteoRepository;
import pe.restaurant.almacen.service.RecepcionTresViasValidator;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class RecepcionTresViasValidatorImpl implements RecepcionTresViasValidator {

    private static final String SQL_OC_DET = """
            SELECT id, articulo_id, cant_proyectada, cant_procesada, cant_facturada, almacen_id
            FROM compras.orden_compra_det
            WHERE orden_compra_id = ? AND flag_estado = '1'
            ORDER BY id
            """;

    private final JdbcTemplate jdbcTemplate;
    private final InventarioConteoRepository inventarioConteoRepository;

    @Override
    public void validarRecepcionOc(Long ordenCompraId, Long almacenId, Long inventarioConteoId, BigDecimal tolerancia) {
        BigDecimal tol = tolerancia != null && tolerancia.compareTo(BigDecimal.ZERO) >= 0
                ? tolerancia
                : new BigDecimal("0.0001");

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(SQL_OC_DET, ordenCompraId);
        boolean hayPendiente = false;

        for (Map<String, Object> row : rows) {
            Long lineAlm = numberToLong(row.get("almacen_id"));
            if (lineAlm != null && !lineAlm.equals(almacenId)) {
                continue;
            }
            BigDecimal proj = bd(row.get("cant_proyectada"));
            BigDecimal proc = bd(row.get("cant_procesada"));
            BigDecimal fact = bd(row.get("cant_facturada"));
            BigDecimal pend = proj.subtract(proc);
            if (pend.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            hayPendiente = true;
            Long articuloId = numberToLong(row.get("articulo_id"));

            if (fact.compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(
                        "La línea de OC del artículo " + articuloId
                                + " no tiene cantidad facturada; no procede la recepción (validación 3 vías).",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        MovimientoErrorCode.VALIDACION_TRES_VIAS);
            }

            BigDecimal facturaPendiente = fact.subtract(proc);
            if (pend.compareTo(facturaPendiente) > 0 && excedeTolerancia(pend.subtract(facturaPendiente), tol)) {
                throw new BusinessException(
                        "La cantidad a recepcionar (" + pend + ") excede lo facturado pendiente ("
                                + facturaPendiente + ") para el artículo " + articuloId + ".",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        MovimientoErrorCode.VALIDACION_TRES_VIAS);
            }

            if (excedeTolerancia(proj.subtract(fact), tol)) {
                throw new BusinessException(
                        "Diferencia entre cantidad ordenada y facturada en artículo " + articuloId
                                + " (OC=" + proj + ", factura=" + fact + ").",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        MovimientoErrorCode.VALIDACION_TRES_VIAS);
            }
        }

        if (!hayPendiente) {
            return;
        }

        if (inventarioConteoId != null) {
            validarConteoFisico(inventarioConteoId, almacenId, ordenCompraId, tol);
        }
    }

    private void validarConteoFisico(Long inventarioConteoId, Long almacenId, Long ordenCompraId, BigDecimal tol) {
        InventarioConteo conteo = inventarioConteoRepository.findById(inventarioConteoId)
                .orElseThrow(() -> new ResourceNotFoundException("InventarioConteo", inventarioConteoId));
        if (!almacenId.equals(conteo.getAlmacenId())) {
            throw new BusinessException(
                    "El conteo físico no pertenece al almacén de recepción.",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    MovimientoErrorCode.VALIDACION_TRES_VIAS);
        }
        BigDecimal cantFisica = conteo.getCantidadConteo1() != null
                ? conteo.getCantidadConteo1()
                : BigDecimal.ZERO;

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(SQL_OC_DET, ordenCompraId);
        BigDecimal pendArticulo = null;
        for (Map<String, Object> row : rows) {
            Long lineAlm = numberToLong(row.get("almacen_id"));
            if (lineAlm != null && !lineAlm.equals(almacenId)) {
                continue;
            }
            if (!conteo.getArticuloId().equals(numberToLong(row.get("articulo_id")))) {
                continue;
            }
            BigDecimal proj = bd(row.get("cant_proyectada"));
            BigDecimal proc = bd(row.get("cant_procesada"));
            pendArticulo = proj.subtract(proc);
            break;
        }
        if (pendArticulo == null || pendArticulo.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                    "No hay cantidad pendiente en OC para el artículo del conteo físico.",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    MovimientoErrorCode.VALIDACION_TRES_VIAS);
        }
        if (excedeTolerancia(cantFisica.subtract(pendArticulo), tol)) {
            throw new BusinessException(
                    "El conteo físico (" + cantFisica + ") no coincide con la cantidad pendiente de recepción ("
                            + pendArticulo + ") para el artículo " + conteo.getArticuloId() + ".",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    MovimientoErrorCode.VALIDACION_TRES_VIAS);
        }
    }

    private static boolean excedeTolerancia(BigDecimal delta, BigDecimal tol) {
        return delta.abs().compareTo(tol) > 0;
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
