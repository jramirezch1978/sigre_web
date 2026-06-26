package pe.restaurant.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.dto.ProcesoAlmacenFiltroRequest;
import pe.restaurant.almacen.dto.ProcesoAlmacenResponse;
import pe.restaurant.almacen.service.AlmacenProcesoService;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class AlmacenProcesoServiceImpl implements AlmacenProcesoService {

    private static final String MENU_RECALCULO = "ALMACEN_PROC_RECALCULO";
    private static final String MENU_CUADRE = "ALMACEN_PROC_CUADRE_STOCK";
    private static final String MENU_ACT_AUTO = "ALMACEN_PROC_ACT_AUTO";

    private final JdbcTemplate jdbcTemplate;

    @Override
    public ProcesoAlmacenResponse recalcularPreciosPromedio(ProcesoAlmacenFiltroRequest filtro) {
        Long almacenId = filtro != null ? filtro.getAlmacenId() : null;
        String countSql = """
                WITH ult AS (
                    SELECT DISTINCT ON (almacen_id, articulo_id)
                        almacen_id, articulo_id, saldo_costo_unitario
                    FROM almacen.articulo_saldo_mensual
                    WHERE saldo_costo_unitario IS NOT NULL
                    ORDER BY almacen_id, articulo_id, fecha DESC, id DESC
                )
                SELECT COUNT(*)
                FROM almacen.articulo_almacen aa
                INNER JOIN ult ON aa.almacen_id = ult.almacen_id
                             AND aa.articulo_id = ult.articulo_id
                WHERE (? IS NULL OR aa.almacen_id = ?)
                """;
        String updateSql = """
                WITH ult AS (
                    SELECT DISTINCT ON (almacen_id, articulo_id)
                        almacen_id, articulo_id, saldo_costo_unitario
                    FROM almacen.articulo_saldo_mensual
                    WHERE saldo_costo_unitario IS NOT NULL
                    ORDER BY almacen_id, articulo_id, fecha DESC, id DESC
                )
                UPDATE almacen.articulo_almacen aa
                SET costo_promedio = ult.saldo_costo_unitario,
                    ultima_actualizacion = NOW()
                FROM ult
                WHERE aa.almacen_id = ult.almacen_id
                  AND aa.articulo_id = ult.articulo_id
                  AND (? IS NULL OR aa.almacen_id = ?)
                """;
        log.info("Iniciando {}. almacenId={}", MENU_RECALCULO, almacenId);
        int esperados = queryInt(countSql, almacenId, almacenId);
        int actualizados = jdbcTemplate.update(updateSql, almacenId, almacenId);
        boolean validacionOk = actualizados == esperados;
        String detalle = "esperados=" + esperados + ", actualizados=" + actualizados;
        if (!validacionOk) {
            log.warn("{} finalizo con diferencias: {}", MENU_RECALCULO, detalle);
        } else {
            log.info("{} finalizo correctamente: {}", MENU_RECALCULO, detalle);
        }
        return ProcesoAlmacenResponse.builder()
                .procesados(actualizados)
                .registrosEsperados(esperados)
                .validacionOk(validacionOk)
                .detalleValidacion(detalle)
                .mensaje("Costo promedio actualizado desde el último saldo valorizado (kardex).")
                .codigoMenu(MENU_RECALCULO)
                .build();
    }

    @Override
    public ProcesoAlmacenResponse cuadrarStockVsPosiciones(ProcesoAlmacenFiltroRequest filtro) {
        Long almacenId = filtro != null ? filtro.getAlmacenId() : null;
        String baseCte = """
                WITH sums AS (
                    SELECT u.almacen_id, p.articulo_id, SUM(p.cantidad_disponible) AS total_pos
                    FROM almacen.articulo_almacen_posicion p
                    INNER JOIN almacen.ubicacion_almacen u ON u.id = p.ubicacion_almacen_id
                    WHERE (? IS NULL OR u.almacen_id = ?)
                    GROUP BY u.almacen_id, p.articulo_id
                ),
                base AS (
                    SELECT aa.almacen_id,
                           aa.articulo_id,
                           COALESCE(sums.total_pos, 0) AS total_pos
                    FROM almacen.articulo_almacen aa
                    LEFT JOIN sums
                           ON aa.almacen_id = sums.almacen_id
                          AND aa.articulo_id = sums.articulo_id
                    WHERE (? IS NULL OR aa.almacen_id = ?)
                )
                """;
        String countEvaluadosSql = baseCte + """
                SELECT COUNT(*) FROM base
                """;
        String countDiferenciasSql = baseCte + """
                SELECT COUNT(*)
                FROM almacen.articulo_almacen aa
                INNER JOIN base ON aa.almacen_id = base.almacen_id
                               AND aa.articulo_id = base.articulo_id
                WHERE COALESCE(aa.cantidad_disponible, 0) <> base.total_pos
                """;
        String updateSql = baseCte + """
                UPDATE almacen.articulo_almacen aa
                SET cantidad_disponible = base.total_pos,
                    ultima_actualizacion = NOW()
                FROM base
                WHERE aa.almacen_id = base.almacen_id
                  AND aa.articulo_id = base.articulo_id
                  AND COALESCE(aa.cantidad_disponible, 0) <> base.total_pos
                """;
        log.info("Iniciando {}. almacenId={}", MENU_CUADRE, almacenId);
        int evaluados = queryInt(countEvaluadosSql, almacenId, almacenId, almacenId, almacenId);
        int diferencias = queryInt(countDiferenciasSql, almacenId, almacenId, almacenId, almacenId);
        int actualizados = jdbcTemplate.update(updateSql, almacenId, almacenId, almacenId, almacenId);
        boolean validacionOk = actualizados == diferencias;
        String detalle = "evaluados=" + evaluados + ", diferencias=" + diferencias + ", actualizados=" + actualizados;
        if (!validacionOk) {
            log.warn("{} finalizo con diferencias: {}", MENU_CUADRE, detalle);
        } else {
            log.info("{} finalizo correctamente: {}", MENU_CUADRE, detalle);
        }
        return ProcesoAlmacenResponse.builder()
                .procesados(actualizados)
                .registrosEsperados(diferencias)
                .validacionOk(validacionOk)
                .detalleValidacion(detalle)
                .mensaje("Cantidades alineadas con posiciones; incluye artículos sin posición (stock en 0).")
                .codigoMenu(MENU_CUADRE)
                .build();
    }

    @Override
    public ProcesoAlmacenResponse actualizacionAutomatica(ProcesoAlmacenFiltroRequest filtro) {
        log.info("Iniciando {}. almacenId={}", MENU_ACT_AUTO, filtro != null ? filtro.getAlmacenId() : null);
        ProcesoAlmacenResponse cuadre = cuadrarStockVsPosiciones(filtro);
        ProcesoAlmacenResponse rec = recalcularPreciosPromedio(filtro);
        boolean validacionOk = Boolean.TRUE.equals(cuadre.getValidacionOk())
                && Boolean.TRUE.equals(rec.getValidacionOk());
        int esperados = safeInt(cuadre.getRegistrosEsperados()) + safeInt(rec.getRegistrosEsperados());
        String detalle = "cuadre={" + cuadre.getDetalleValidacion() + "}; recalculo={" + rec.getDetalleValidacion() + "}";
        if (!validacionOk) {
            log.warn("{} finalizo con observaciones: {}", MENU_ACT_AUTO, detalle);
        } else {
            log.info("{} finalizo correctamente: {}", MENU_ACT_AUTO, detalle);
        }
        return ProcesoAlmacenResponse.builder()
                .procesados(cuadre.getProcesados() + rec.getProcesados())
                .registrosEsperados(esperados)
                .validacionOk(validacionOk)
                .detalleValidacion(detalle)
                .mensaje("Cuadre de posiciones: " + cuadre.getProcesados()
                        + " filas; recálculo costo desde kardex: " + rec.getProcesados() + " filas.")
                .codigoMenu(MENU_ACT_AUTO)
                .build();
    }

    private int queryInt(String sql, Object... args) {
        Integer value = jdbcTemplate.queryForObject(sql, Integer.class, args);
        return value != null ? value : 0;
    }

    private int safeInt(Integer value) {
        return value != null ? value : 0;
    }
}
