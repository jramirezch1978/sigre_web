package com.sigre.almacen.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.DashboardLogisticoResponse;
import com.sigre.almacen.dto.DashboardLogisticoResponse.MovimientoDiaItem;
import com.sigre.almacen.dto.DashboardLogisticoResponse.ProductoTerminadoStockItem;
import com.sigre.almacen.dto.DiagnosticoAlmacenResponse;
import com.sigre.almacen.service.DashboardLogisticoService;
import com.sigre.almacen.service.ReporteAlmacenService;
import com.sigre.common.service.ConfiguracionParametroService;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DashboardLogisticoServiceImpl implements DashboardLogisticoService {

    /** Parámetro universal en config.configuracion (módulo GENERAL). */
    private static final String PARAM_CLASE_PRODUCTO_TERMINADO = "CLASE_PRODUCTO_TERMINADO";
    private static final String DEFAULT_CLASE_PT = "01";
    private static final int DIAS_SERIE = 14;

    private final DataSource dataSource;
    private final ReporteAlmacenService reporteAlmacenService;
    private final ConfiguracionParametroService configParam;

    @Override
    @Transactional(readOnly = true)
    public DashboardLogisticoResponse resumen(Long sucursalId) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);

        String codClase = leerClaseProductoTerminado();
        String descClase = leerDescClase(jdbc, codClase);

        MovCounts mov = contarMovimientosActivos(jdbc, sucursalId);
        List<DiagnosticoAlmacenResponse> porAlmacen = filtrarPorSucursal(
                reporteAlmacenService.diagnostico(null), jdbc, sucursalId);

        BigDecimal valorTotal = porAlmacen.stream()
                .map(d -> d.getValorInventario() != null ? d.getValorInventario() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<ProductoTerminadoStockItem> pt = listarProductoTerminado(jdbc, sucursalId, codClase);
        List<MovimientoDiaItem> serie = serieMovimientosDiarios(jdbc, sucursalId, DIAS_SERIE);

        return DashboardLogisticoResponse.builder()
                .claseProductoTerminado(codClase)
                .claseProductoTerminadoDesc(descClase)
                .totalIngresosActivos(mov != null ? mov.ingresos : 0)
                .totalSalidasActivos(mov != null ? mov.salidas : 0)
                .valorInventarioTotal(valorTotal != null ? valorTotal : BigDecimal.ZERO)
                .valorizacionPorAlmacen(porAlmacen != null ? porAlmacen : List.of())
                .productoTerminado(pt != null ? pt : List.of())
                .serieMovimientos(serie)
                .build();
    }

    /** Últimos {@code dias} con ceros en días sin movimiento. */
    private List<MovimientoDiaItem> serieMovimientosDiarios(JdbcTemplate jdbc, Long sucursalId, int dias) {
        LocalDate hasta = LocalDate.now();
        LocalDate desde = hasta.minusDays(dias - 1L);
        Map<LocalDate, long[]> porDia = new HashMap<>();
        try {
            jdbc.query(
                    """
                    SELECT v.fecha_mov AS dia,
                           COALESCE(SUM(CASE WHEN COALESCE(t.factor_sldo_total, 0) > 0 THEN 1 ELSE 0 END), 0) AS ingresos,
                           COALESCE(SUM(CASE WHEN COALESCE(t.factor_sldo_total, 0) < 0 THEN 1 ELSE 0 END), 0) AS salidas
                      FROM almacen.vale_mov v
                      JOIN almacen.articulo_mov_tipo t ON t.id = v.articulo_mov_tipo_id
                     WHERE v.flag_estado = '1'
                       AND v.fecha_mov BETWEEN ? AND ?
                       AND (?::bigint IS NULL OR v.sucursal_id = ?)
                     GROUP BY v.fecha_mov
                    """,
                    rs -> {
                        while (rs.next()) {
                            LocalDate dia = rs.getDate("dia").toLocalDate();
                            porDia.put(dia, new long[]{rs.getLong("ingresos"), rs.getLong("salidas")});
                        }
                        return null;
                    },
                    java.sql.Date.valueOf(desde), java.sql.Date.valueOf(hasta), sucursalId, sucursalId);
        } catch (Exception ignored) {
            // serie vacía → se rellena con ceros
        }
        List<MovimientoDiaItem> out = new ArrayList<>(dias);
        for (LocalDate d = desde; !d.isAfter(hasta); d = d.plusDays(1)) {
            long[] v = porDia.get(d);
            out.add(MovimientoDiaItem.builder()
                    .fecha(d)
                    .ingresos(v != null ? v[0] : 0L)
                    .salidas(v != null ? v[1] : 0L)
                    .build());
        }
        return out;
    }

    /** Lee vía {@code config.fn_get_parametro_txt} (nunca SELECT directo a la tabla). */
    private String leerClaseProductoTerminado() {
        try {
            String v = configParam.getTexto(PARAM_CLASE_PRODUCTO_TERMINADO, DEFAULT_CLASE_PT);
            return v != null && !v.isBlank() ? v.trim() : DEFAULT_CLASE_PT;
        } catch (Exception ex) {
            return DEFAULT_CLASE_PT;
        }
    }

    private String leerDescClase(JdbcTemplate jdbc, String codClase) {
        try {
            List<String> rows = jdbc.query(
                    "SELECT desc_clase FROM core.articulo_clase WHERE cod_clase = ? AND flag_estado = '1' LIMIT 1",
                    (rs, i) -> rs.getString(1),
                    codClase);
            return rows.isEmpty() ? "PRODUCTOS TERMINADOS" : rows.get(0);
        } catch (Exception ex) {
            return "PRODUCTOS TERMINADOS";
        }
    }

    private MovCounts contarMovimientosActivos(JdbcTemplate jdbc, Long sucursalId) {
        String sql = """
                SELECT
                    COALESCE(SUM(CASE WHEN COALESCE(t.factor_sldo_total, 0) > 0 THEN 1 ELSE 0 END), 0) AS ingresos,
                    COALESCE(SUM(CASE WHEN COALESCE(t.factor_sldo_total, 0) < 0 THEN 1 ELSE 0 END), 0) AS salidas
                  FROM almacen.vale_mov v
                  JOIN almacen.articulo_mov_tipo t ON t.id = v.articulo_mov_tipo_id
                 WHERE v.flag_estado = '1'
                   AND (?::bigint IS NULL OR v.sucursal_id = ?)
                """;
        return jdbc.query(sql, rs -> {
            if (!rs.next()) {
                return new MovCounts(0, 0);
            }
            return new MovCounts(rs.getLong("ingresos"), rs.getLong("salidas"));
        }, sucursalId, sucursalId);
    }

    private List<DiagnosticoAlmacenResponse> filtrarPorSucursal(
            List<DiagnosticoAlmacenResponse> all, JdbcTemplate jdbc, Long sucursalId) {
        if (sucursalId == null || all == null || all.isEmpty()) {
            return all != null ? all : List.of();
        }
        List<Long> ids = jdbc.query(
                "SELECT id FROM almacen.almacen WHERE sucursal_id = ? AND flag_estado = '1'",
                (rs, i) -> rs.getLong(1),
                sucursalId);
        if (ids.isEmpty()) {
            return List.of();
        }
        return all.stream().filter(d -> ids.contains(d.getAlmacenId())).toList();
    }

    /**
     * Stock PT: artículos con {@code articulo_clase.cod_clase = param},
     * o fallback a almacenes tipo {@code PT} si la columna/clase aún no está poblada.
     */
    private List<ProductoTerminadoStockItem> listarProductoTerminado(
            JdbcTemplate jdbc, Long sucursalId, String codClase) {
        boolean tieneColumnaClase = tieneColumna(jdbc, "core", "articulo", "articulo_clase_id");
        List<ProductoTerminadoStockItem> porClase = List.of();
        if (tieneColumnaClase) {
            porClase = jdbc.query(
                    """
                    SELECT a.id, a.codigo, a.nombre,
                           COALESCE(sc.desc_subcateg, c.desc_categ, 'GENERAL') AS grupo,
                           alm.codigo AS alm_cod, alm.nombre AS alm_nom,
                           aa.cantidad_disponible,
                           (aa.cantidad_disponible * COALESCE(aa.costo_promedio, 0)) AS valor
                      FROM almacen.articulo_almacen aa
                      JOIN core.articulo a ON a.id = aa.articulo_id
                      JOIN almacen.almacen alm ON alm.id = aa.almacen_id
                      LEFT JOIN core.articulo_clase cl ON cl.id = a.articulo_clase_id
                      LEFT JOIN core.articulo_categ c ON c.id = a.articulo_categ_id
                      LEFT JOIN core.articulo_sub_categ sc ON sc.id = a.articulo_sub_categ_id
                     WHERE aa.cantidad_disponible > 0
                       AND alm.flag_estado = '1'
                       AND cl.cod_clase = ?
                       AND (?::bigint IS NULL OR alm.sucursal_id = ?)
                     ORDER BY 4, a.codigo, alm.codigo
                    """,
                    (rs, i) -> mapPt(rs),
                    codClase, sucursalId, sucursalId);
        }
        if (!porClase.isEmpty()) {
            return porClase;
        }
        // Fallback: almacenes tipo PRODUCTO TERMINADO
        return jdbc.query(
                """
                SELECT a.id, a.codigo, a.nombre,
                       COALESCE(sc.desc_subcateg, c.desc_categ, 'GENERAL') AS grupo,
                       alm.codigo AS alm_cod, alm.nombre AS alm_nom,
                       aa.cantidad_disponible,
                       (aa.cantidad_disponible * COALESCE(aa.costo_promedio, 0)) AS valor
                  FROM almacen.articulo_almacen aa
                  JOIN core.articulo a ON a.id = aa.articulo_id
                  JOIN almacen.almacen alm ON alm.id = aa.almacen_id
                  JOIN almacen.almacen_tipo at ON at.id = alm.almacen_tipo_id
                  LEFT JOIN core.articulo_categ c ON c.id = a.articulo_categ_id
                  LEFT JOIN core.articulo_sub_categ sc ON sc.id = a.articulo_sub_categ_id
                 WHERE aa.cantidad_disponible > 0
                   AND alm.flag_estado = '1'
                   AND at.codigo = 'PT'
                   AND (?::bigint IS NULL OR alm.sucursal_id = ?)
                 ORDER BY 4, a.codigo, alm.codigo
                """,
                (rs, i) -> mapPt(rs),
                sucursalId, sucursalId);
    }

    private ProductoTerminadoStockItem mapPt(java.sql.ResultSet rs) throws java.sql.SQLException {
        String codigo = rs.getString("codigo");
        String nombre = rs.getString("nombre");
        return ProductoTerminadoStockItem.builder()
                .articuloId(rs.getLong("id"))
                .codigo(codigo)
                .nombre(nombre)
                .denominacion(codigo)
                .grupo(rs.getString("grupo"))
                .almacenCodigo(rs.getString("alm_cod"))
                .almacenNombre(rs.getString("alm_nom"))
                .cantidad(rs.getBigDecimal("cantidad_disponible"))
                .valor(rs.getBigDecimal("valor"))
                .build();
    }

    private boolean tieneColumna(JdbcTemplate jdbc, String schema, String table, String column) {
        Integer n = jdbc.queryForObject(
                """
                SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = ? AND table_name = ? AND column_name = ?
                """,
                Integer.class, schema, table, column);
        return n != null && n > 0;
    }

    private record MovCounts(long ingresos, long salidas) {
    }
}
