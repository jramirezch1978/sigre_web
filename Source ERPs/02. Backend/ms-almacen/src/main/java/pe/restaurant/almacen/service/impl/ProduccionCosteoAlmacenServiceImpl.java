package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.domain.ValeMovFlagEstado;
import pe.restaurant.almacen.dto.ProcesoCosteoAlmacenResponse;
import pe.restaurant.almacen.event.CosteoPeriodoProcesadoEvent;
import pe.restaurant.almacen.event.publisher.AlmacenPreAsientoPublisher;
import pe.restaurant.almacen.service.ProduccionCosteoAlmacenService;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class ProduccionCosteoAlmacenServiceImpl implements ProduccionCosteoAlmacenService {

    private static final String TIPO_REF_PRODUCCION = "P";

    private final JdbcTemplate jdbcTemplate;
    private final AlmacenPreAsientoPublisher preAsientoPublisher;

    @Override
    public ProcesoCosteoAlmacenResponse aplicarCosteoEnAlmacen(CosteoPeriodoProcesadoEvent evento) {
        Integer anio = evento.getAnio();
        Integer mes = evento.getMes();
        Long sucursalFiltroId = evento.getSucursalFiltroId();
        Long almacenFiltroId = evento.getAlmacenFiltroId();
        Long usuarioId = evento.getUsuarioId() != null ? evento.getUsuarioId() : TenantContext.getUsuarioId();

        LocalDate fechaInicio = LocalDate.of(anio, mes, 1);
        LocalDate fechaFin = fechaInicio.plusMonths(1);

        int costeosEnPeriodo = contarCosteos(anio, mes, sucursalFiltroId);
        if (costeosEnPeriodo == 0) {
            log.warn("Costeo {}-{} sin registros en produccion.costeo_produccion (sucursalFiltro={})",
                    anio, mes, sucursalFiltroId);
            return ProcesoCosteoAlmacenResponse.builder()
                    .anio(anio)
                    .mes(mes)
                    .sucursalFiltroId(sucursalFiltroId)
                    .costeosEnPeriodo(0)
                    .lineasValeActualizadas(0)
                    .articulosAlmacenActualizados(0)
                    .mensaje("No hay costeos persistidos para el período.")
                    .build();
        }

        int lineasVale = actualizarCostoEnValesProduccion(anio, mes, sucursalFiltroId, almacenFiltroId,
                fechaInicio, fechaFin, usuarioId);
        int articulos = actualizarCostoPromedioDesdeCosteo(anio, mes, sucursalFiltroId, almacenFiltroId,
                fechaInicio, fechaFin, usuarioId);

        preAsientoPublisher.publicarCosteoProduccion(evento, costeosEnPeriodo, lineasVale);

        String mensaje = "Costeo aplicado en almacén: %d líneas de vale (ingreso producción), %d artículos-almacén."
                .formatted(lineasVale, articulos);
        log.info("{} Periodo {}-{}, sucursalFiltro={}, eventId={}",
                mensaje, anio, mes, sucursalFiltroId, evento.getEventId());

        return ProcesoCosteoAlmacenResponse.builder()
                .anio(anio)
                .mes(mes)
                .sucursalFiltroId(sucursalFiltroId)
                .costeosEnPeriodo(costeosEnPeriodo)
                .lineasValeActualizadas(lineasVale)
                .articulosAlmacenActualizados(articulos)
                .mensaje(mensaje)
                .build();
    }

    private int contarCosteos(Integer anio, Integer mes, Long sucursalFiltroId) {
        String sql = """
                SELECT COUNT(*)::int
                FROM produccion.costeo_produccion cp
                INNER JOIN produccion.orden_trabajo ot ON ot.id = cp.orden_trabajo_id
                WHERE cp.anio = ? AND cp.mes = ?
                  AND (? IS NULL OR ot.sucursal_id = ?)
                """;
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, anio, mes, sucursalFiltroId, sucursalFiltroId);
        return count != null ? count : 0;
    }

    /**
     * Actualiza {@code vale_mov_det.costo_unitario} en vales de ingreso por producción confirmados (tipo P).
     */
    private int actualizarCostoEnValesProduccion(Integer anio, Integer mes, Long sucursalFiltroId, Long almacenFiltroId,
                                                 LocalDate fechaInicio, LocalDate fechaFin, Long usuarioId) {
        String sql = """
                UPDATE almacen.vale_mov_det vmd
                SET costo_unitario = cp.costo_unitario,
                    updated_by = ?,
                    fec_modificacion = NOW()
                FROM almacen.vale_mov vm
                INNER JOIN produccion.costeo_produccion cp ON cp.orden_trabajo_id = vm.orden_trabajo_id
                INNER JOIN produccion.orden_trabajo ot ON ot.id = vm.orden_trabajo_id
                INNER JOIN produccion.parte_produccion pp ON pp.orden_trabajo_id = ot.id
                INNER JOIN produccion.parte_produccion_producido ppp
                    ON ppp.parte_produccion_id = pp.id AND ppp.articulo_id = vmd.articulo_id
                WHERE vm.id = vmd.vale_mov_id
                  AND vm.tipo_referencia_origen = ?
                  AND vm.flag_estado = ?
                  AND cp.anio = ? AND cp.mes = ?
                  AND cp.costo_unitario IS NOT NULL AND cp.costo_unitario > 0
                  AND pp.fecha >= ? AND pp.fecha < ?
                  AND (? IS NULL OR ot.sucursal_id = ?)
                  AND (? IS NULL OR vm.almacen_id = ?)
                """;
        return jdbcTemplate.update(sql,
                usuarioId,
                TIPO_REF_PRODUCCION,
                ValeMovFlagEstado.CERRADO,
                anio, mes,
                fechaInicio, fechaFin,
                sucursalFiltroId, sucursalFiltroId,
                almacenFiltroId, almacenFiltroId);
    }

    /**
     * Sincroniza {@code articulo_almacen.costo_promedio} con el costo unitario del costeo para artículos producidos
     * en el período y con movimiento de ingreso por producción en el mismo almacén.
     */
    private int actualizarCostoPromedioDesdeCosteo(Integer anio, Integer mes, Long sucursalFiltroId, Long almacenFiltroId,
                                                     LocalDate fechaInicio, LocalDate fechaFin, Long usuarioId) {
        String sql = """
                UPDATE almacen.articulo_almacen aa
                SET costo_promedio = sub.costo_unitario,
                    ultima_actualizacion = NOW(),
                    updated_by = ?,
                    fec_modificacion = NOW()
                FROM (
                    SELECT DISTINCT vm.almacen_id, ppp.articulo_id, cp.costo_unitario
                    FROM produccion.costeo_produccion cp
                    INNER JOIN produccion.orden_trabajo ot ON ot.id = cp.orden_trabajo_id
                    INNER JOIN produccion.parte_produccion pp ON pp.orden_trabajo_id = ot.id
                    INNER JOIN produccion.parte_produccion_producido ppp ON ppp.parte_produccion_id = pp.id
                    INNER JOIN almacen.vale_mov vm ON vm.orden_trabajo_id = ot.id
                    WHERE vm.tipo_referencia_origen = ?
                      AND vm.flag_estado = ?
                      AND cp.anio = ? AND cp.mes = ?
                      AND cp.costo_unitario IS NOT NULL AND cp.costo_unitario > 0
                      AND pp.fecha >= ? AND pp.fecha < ?
                      AND (? IS NULL OR ot.sucursal_id = ?)
                      AND (? IS NULL OR vm.almacen_id = ?)
                ) sub
                WHERE aa.almacen_id = sub.almacen_id
                  AND aa.articulo_id = sub.articulo_id
                """;
        return jdbcTemplate.update(sql,
                usuarioId,
                TIPO_REF_PRODUCCION,
                ValeMovFlagEstado.CERRADO,
                anio, mes,
                fechaInicio, fechaFin,
                sucursalFiltroId, sucursalFiltroId,
                almacenFiltroId, almacenFiltroId);
    }
}
