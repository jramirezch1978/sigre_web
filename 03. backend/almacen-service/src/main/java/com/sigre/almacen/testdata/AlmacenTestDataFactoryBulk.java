package com.sigre.almacen.testdata;

import org.springframework.jdbc.core.JdbcTemplate;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Inserciones masivas idempotentes (~{@link #BULK_ROWS} filas por tabla {@code almacen}) para tests IT.
 * No modifica los códigos mínimos {@code FACTORY-AL-01}, {@code LM-TEST-0001}, etc.
 */
final class AlmacenTestDataFactoryBulk {

    static final int BULK_ROWS = 120;
    static final String PREFIX_ART = "FAB-ART-";
    static final String PREFIX_UBI = "FACTORY-AL-BU-";
    static final String PREFIX_LOTE = "FAB-LOT-";
    static final String PREFIX_ALM = "FACTORY-AL-B";
    static final String PREFIX_MOTIVO = "FAB-MT-";
    static final String PREFIX_VALE = "BL";
    static final String PREFIX_OT = "OT";
    static final String PREFIX_SS = "SS";
    static final String GUIA_SERIE_BULK = "FBL";

    private static final long USER_ID = 1L;

    private AlmacenTestDataFactoryBulk() {
    }

    static Map<String, Integer> ensureBulkDataset(JdbcTemplate jdbc, BulkContext ctx) {
        Map<String, Integer> out = new LinkedHashMap<>();
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "vale_mov")) {
            return out;
        }
        out.put("bulk.core.articulo", ensureBulkCoreArticulos(jdbc));
        out.put("bulk.almacen.motivo_traslado", ensureBulkMotivosTraslado(jdbc));
        out.put("bulk.almacen.articulo_mov_tipo", ensureBulkArticuloMovTipos(jdbc));
        out.put("bulk.almacen.almacen", ensureBulkAlmacenes(jdbc, ctx));
        out.put("bulk.almacen.ubicacion_almacen", ensureBulkUbicaciones(jdbc));
        out.put("bulk.almacen.lote_pallet", ensureBulkLotes(jdbc));
        out.put("bulk.almacen.almacen_user", ensureBulkAlmacenUsers(jdbc));
        out.put("bulk.almacen.almacen_tipo_mov", ensureBulkAlmacenTipoMov(jdbc));
        out.put("bulk.almacen.vale_mov", ensureBulkValeMov(jdbc, ctx));
        out.put("bulk.almacen.vale_mov_det", ensureBulkValeMovDet(jdbc));
        out.put("bulk.almacen.orden_traslado", ensureBulkOrdenTraslado(jdbc));
        out.put("bulk.almacen.orden_traslado_det", ensureBulkOrdenTrasladoDet(jdbc));
        out.put("bulk.almacen.guia", ensureBulkGuia(jdbc, ctx));
        out.put("bulk.almacen.guia_det", ensureBulkGuiaDet(jdbc));
        out.put("bulk.almacen.sol_salida", ensureBulkSolSalida(jdbc));
        out.put("bulk.almacen.sol_salida_det", ensureBulkSolSalidaDet(jdbc));
        out.put("bulk.almacen.inventario_conteo", ensureBulkInventarioConteo(jdbc));
        out.put("bulk.almacen.articulo_bonificacion", ensureBulkArticuloBonificacion(jdbc));
        out.put("bulk.almacen.articulo_almacen", ensureBulkArticuloAlmacen(jdbc));
        out.put("bulk.almacen.articulo_almacen_lote", ensureBulkArticuloAlmacenLote(jdbc));
        out.put("bulk.almacen.articulo_almacen_posicion", ensureBulkArticuloAlmacenPosicion(jdbc));
        out.put("bulk.almacen.articulo_saldo_mensual", ensureBulkArticuloSaldoMensual(jdbc));
        return out;
    }

    record BulkContext(Long sucursalId, Long tipoMovId, Long proveedorId) {
    }

    private static int ensureBulkCoreArticulos(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "core", "articulo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                SELECT 10000 + g, ? || LPAD(g::text, 4, '0'), 'Artículo bulk factory ' || g, 'BIEN', um.id, ac.id,
                    2.5000 + (g % 50) * 0.15, '1'
                FROM generate_series(1, ?) AS g
                JOIN core.unidad_medida um ON um.codigo = 'KG'
                JOIN core.articulo_categ ac ON ac.cat_art = 'MP'
                ON CONFLICT (codigo) DO NOTHING
                """, PREFIX_ART, BULK_ROWS);
    }

    private static int ensureBulkMotivosTraslado(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "motivo_traslado")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.motivo_traslado (codigo, nombre, flag_estado, created_by)
                SELECT ? || LPAD(g::text, 3, '0'), 'Motivo traslado bulk ' || g, '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (codigo) DO NOTHING
                """, PREFIX_MOTIVO, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkArticuloMovTipos(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "articulo_mov_tipo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.articulo_mov_tipo (
                    tipo_mov, desc_tipo_mov, flag_contabiliza, flag_clase_mov, factor_sldo_total, flag_estado, created_by)
                SELECT 'B' || LPAD(g::text, 9, '0'), 'Mov bulk factory ' || g, '1', 'I', 1.00, '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (tipo_mov) DO NOTHING
                """, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkAlmacenes(JdbcTemplate jdbc, BulkContext ctx) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "almacen")
                || ctx.sucursalId() == null) {
            return 0;
        }
        Long tipoId = jdbc.query(
                "SELECT id FROM almacen.almacen_tipo WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                AlmacenTestDataFactory.CODIGO_ALMACEN_TIPO);
        if (tipoId == null) {
            tipoId = jdbc.query(
                    "SELECT id FROM almacen.almacen_tipo WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                    rs -> rs.next() ? rs.getLong(1) : null);
        }
        if (tipoId == null) {
            return 0;
        }
        Long finalTipoId = tipoId;
        return jdbc.update("""
                INSERT INTO almacen.almacen (sucursal_id, almacen_tipo_id, codigo, nombre, flag_estado, created_by, updated_by)
                SELECT ?, ?, ? || LPAD(g::text, 3, '0'), 'Almacén bulk factory ' || g, '1', ?, ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (sucursal_id, codigo) DO NOTHING
                """, ctx.sucursalId(), finalTipoId, PREFIX_ALM, USER_ID, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkUbicaciones(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "ubicacion_almacen")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.ubicacion_almacen (almacen_id, codigo, nombre, pasillo, estante, nivel, created_by)
                SELECT a.id, ? || LPAD(g::text, 3, '0'), 'Ubicación bulk ' || g,
                    CHR(65 + ((g - 1) % 5)), LPAD(((g - 1) % 10 + 1)::text, 2, '0'), '01', ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                ON CONFLICT (almacen_id, codigo) DO NOTHING
                """, PREFIX_UBI, USER_ID, BULK_ROWS, PREFIX_ALM, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkLotes(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "lote_pallet")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.lote_pallet (almacen_id, articulo_id, nro_lote, fecha_produccion, fecha_vencimiento, observacion, flag_estado, created_by)
                SELECT a.id, art.id, ? || LPAD(g::text, 4, '0'),
                    CURRENT_DATE - (g % 30), CURRENT_DATE + (90 + (g % 180)), 'Lote bulk factory', '1', ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                JOIN core.articulo art ON art.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 4, '0')
                ON CONFLICT (almacen_id, articulo_id, nro_lote) DO NOTHING
                """, PREFIX_LOTE, USER_ID, BULK_ROWS, PREFIX_ALM, Math.min(BULK_ROWS, 100),
                PREFIX_ART, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkAlmacenUsers(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "almacen_user")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.almacen_user (almacen_id, usuario_id, flag_estado, created_by)
                SELECT a.id, ?, '1', ?
                FROM almacen.almacen a
                WHERE a.codigo LIKE ? || '%'
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.almacen_user au WHERE au.almacen_id = a.id AND au.usuario_id = ?
                  )
                """, USER_ID, USER_ID, PREFIX_ALM, USER_ID);
    }

    private static int ensureBulkAlmacenTipoMov(JdbcTemplate jdbc) {
        if (!AlmacenTestDataFactory.tableExists(jdbc, "almacen", "almacen_tipo_mov")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado, created_by)
                SELECT a.id, t.id, '1', ?
                FROM almacen.almacen a
                CROSS JOIN (
                    SELECT id FROM almacen.articulo_mov_tipo
                    WHERE tipo_mov LIKE 'B%' OR tipo_mov = ?
                    ORDER BY id LIMIT 1
                ) t
                WHERE a.codigo LIKE ? || '%'
                ON CONFLICT (almacen_id, articulo_mov_tipo_id) DO NOTHING
                """, USER_ID, AlmacenTestDataFactory.TIPO_MOV_FACTORY, PREFIX_ALM);
    }

    private static int ensureBulkValeMov(JdbcTemplate jdbc, BulkContext ctx) {
        if (ctx.sucursalId() == null) {
            return 0;
        }
        Long tipoId = resolveBulkTipoMovId(jdbc, ctx.tipoMovId());
        Long provId = ctx.proveedorId() != null ? ctx.proveedorId() : 1L;
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.vale_mov (sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale, proveedor_id, flag_estado, created_by)
                SELECT ?, a.id, ?, ?::date, ? || LPAD(g::text, 10, '0'), ?, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                ON CONFLICT (nro_vale) DO NOTHING
                """, ctx.sucursalId(), tipoId, today, PREFIX_VALE, provId, USER_ID, BULK_ROWS,
                PREFIX_ALM, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkValeMovDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.vale_mov_det (vale_mov_id, articulo_id, cant_procesada, costo_unitario, moneda_id, flag_estado, created_by)
                SELECT vm.id, art.id, (5 + (vm.id % 20))::numeric,
                    ROUND(COALESCE(art.precio_venta, 3.5) * 0.85, 6), m.id, '1', ?
                FROM almacen.vale_mov vm
                JOIN core.articulo art ON art.codigo = ? || LPAD(RIGHT(vm.nro_vale, 4), 4, '0')
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                WHERE vm.nro_vale LIKE ? || '%' AND LENGTH(vm.nro_vale) = 12
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.vale_mov_det d WHERE d.vale_mov_id = vm.id AND d.articulo_id = art.id
                  )
                """, USER_ID, PREFIX_ART, PREFIX_VALE);
    }

    private static int ensureBulkOrdenTraslado(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.orden_traslado (almacen_origen_id, almacen_destino_id, nro_orden_traslado, fecha, flag_estado, observacion, created_by)
                SELECT w1.id, w2.id, ? || LPAD(g::text, 10, '0'), ?::date, '1', 'OT bulk factory ' || g, ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen w1 ON w1.codigo = ? || CASE WHEN g % 2 = 1 THEN '001' ELSE '002' END
                JOIN almacen.almacen w2 ON w2.codigo = ? || CASE WHEN g % 2 = 1 THEN '002' ELSE '001' END
                ON CONFLICT (nro_orden_traslado) DO NOTHING
                """, PREFIX_OT, today, USER_ID, BULK_ROWS, PREFIX_ALM, PREFIX_ALM);
    }

    private static int ensureBulkOrdenTrasladoDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.orden_traslado_det (orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida, created_by)
                SELECT ot.id, art.id, (8 + (ot.id % 15))::numeric, (4 + (ot.id % 8))::numeric, (3 + (ot.id % 6))::numeric, ?
                FROM almacen.orden_traslado ot
                JOIN core.articulo art ON art.codigo = ? || LPAD((1 + ((ot.id % ?)))::text, 4, '0')
                WHERE ot.nro_orden_traslado LIKE ? || '%' AND LENGTH(ot.nro_orden_traslado) = 12
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.orden_traslado_det d
                      WHERE d.orden_traslado_id = ot.id AND d.articulo_id = art.id
                  )
                """, USER_ID, PREFIX_ART, BULK_ROWS, PREFIX_OT);
    }

    private static int ensureBulkGuia(JdbcTemplate jdbc, BulkContext ctx) {
        if (ctx.sucursalId() == null) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.guia (sucursal_id, serie, numero, fecha_emision, fecha_traslado,
                    motivo_traslado_id, destinatario_id, transportista_id, vale_mov_id, flag_estado, created_by)
                SELECT ?, ?, LPAD(g::text, 8, '0'), ?::date, ?::date, mt.id, 2, 3, vm.id, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.vale_mov vm ON vm.nro_vale = ? || LPAD(g::text, 10, '0')
                CROSS JOIN (SELECT id FROM almacen.motivo_traslado WHERE flag_estado = '1' ORDER BY id LIMIT 1) mt
                ON CONFLICT (sucursal_id, serie, numero) DO NOTHING
                """, ctx.sucursalId(), GUIA_SERIE_BULK, today, today, USER_ID, BULK_ROWS, PREFIX_VALE);
    }

    private static int ensureBulkGuiaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.guia_det (guia_id, vale_mov_id, articulo_id, unidad_medida_id, cantidad, flag_estado, created_by)
                SELECT g.id, g.vale_mov_id, art.id, art.unidad_medida_id, (6 + (g.id % 12))::numeric, '1', ?
                FROM almacen.guia g
                JOIN core.articulo art ON art.codigo = ? || LPAD((1 + ((g.id % ?)))::text, 4, '0')
                WHERE g.serie = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.guia_det gd WHERE gd.guia_id = g.id AND gd.articulo_id = art.id
                  )
                """, USER_ID, PREFIX_ART, BULK_ROWS, GUIA_SERIE_BULK);
    }

    private static int ensureBulkSolSalida(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.sol_salida (almacen_id, nro_sol_salida, fecha, solicitante_id, flag_estado, observacion, created_by)
                SELECT a.id, ? || LPAD(g::text, 10, '0'), ?::date, ?, '1', 'SS bulk factory ' || g, ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                ON CONFLICT (nro_sol_salida) DO NOTHING
                """, PREFIX_SS, today, USER_ID, USER_ID, BULK_ROWS, PREFIX_ALM, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkSolSalidaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.sol_salida_det (sol_salida_id, articulo_id, cantidad, cantidad_despachada, created_by)
                SELECT ss.id, art.id, (5 + (ss.id % 10))::numeric, (2 + (ss.id % 4))::numeric, ?
                FROM almacen.sol_salida ss
                JOIN core.articulo art ON art.codigo = ? || LPAD((1 + ((ss.id % ?)))::text, 4, '0')
                WHERE ss.nro_sol_salida LIKE ? || '%' AND LENGTH(ss.nro_sol_salida) = 12
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.sol_salida_det sd WHERE sd.sol_salida_id = ss.id AND sd.articulo_id = art.id
                  )
                """, USER_ID, PREFIX_ART, BULK_ROWS, PREFIX_SS);
    }

    private static int ensureBulkInventarioConteo(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.inventario_conteo (
                    almacen_id, articulo_id, fecha_conteo, nro_conteo, saldo_sistema,
                    cantidad_conteo_1, auditor_conteo_1, nro_ficha_conteo_1, costo_unitario, diferencia,
                    vale_mov_ajuste_id, ubicacion_id, usuario_id, flag_estado, created_by)
                SELECT a.id, art.id, ?::date, 1 + ((g - 1) % 3), (70 + (g % 50))::numeric,
                    (68 + (g % 48))::numeric, 'AUD-BULK-' || g, 'FICHA-BULK-' || LPAD(g::text, 4, '0'),
                    COALESCE(art.precio_venta, 3.5), -2.0, vm.id, ub.id, ?, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                JOIN core.articulo art ON art.codigo = ? || LPAD(g::text, 4, '0')
                JOIN almacen.vale_mov vm ON vm.nro_vale = ? || LPAD(g::text, 10, '0')
                JOIN almacen.ubicacion_almacen ub ON ub.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM almacen.inventario_conteo ic
                    WHERE ic.nro_ficha_conteo_1 = 'FICHA-BULK-' || LPAD(g::text, 4, '0')
                )
                """, today, USER_ID, USER_ID, BULK_ROWS, PREFIX_ALM, Math.min(BULK_ROWS, 100),
                PREFIX_ART, PREFIX_VALE, PREFIX_UBI, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkArticuloBonificacion(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.articulo_bonificacion (articulo_id, cantidad_minima, cantidad_bonificacion, fecha_inicio, fecha_fin, flag_estado, created_by)
                SELECT art.id, (8 + (g % 12))::numeric, (0.5 + (g % 3) * 0.25)::numeric,
                    CURRENT_DATE - 7, CURRENT_DATE + 90, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN core.articulo art ON art.codigo = ? || LPAD(g::text, 4, '0')
                WHERE NOT EXISTS (SELECT 1 FROM almacen.articulo_bonificacion b WHERE b.articulo_id = art.id)
                """, USER_ID, BULK_ROWS, PREFIX_ART);
    }

    private static int ensureBulkArticuloAlmacen(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen (almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio, created_by)
                SELECT a.id, art.id, (30 + (g % 80))::numeric, (g % 10)::numeric,
                    ROUND(COALESCE(art.precio_venta, 3.5) * 0.82, 6), ?
                FROM generate_series(1, ?) AS g
                JOIN almacen.almacen a ON a.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                JOIN core.articulo art ON art.codigo = ? || LPAD(g::text, 4, '0')
                ON CONFLICT (almacen_id, articulo_id) DO NOTHING
                """, USER_ID, BULK_ROWS, PREFIX_ALM, Math.min(BULK_ROWS, 100), PREFIX_ART);
    }

    private static int ensureBulkArticuloAlmacenLote(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen_lote (almacen_id, articulo_id, lote_pallet_id, cantidad_total, saldo, costo_promedio, created_by)
                SELECT lp.almacen_id, lp.articulo_id, lp.id, (20 + (lp.id % 40))::numeric, (18 + (lp.id % 35))::numeric,
                    ROUND(COALESCE(art.precio_venta, 3.5) * 0.9, 6), ?
                FROM almacen.lote_pallet lp
                JOIN core.articulo art ON art.id = lp.articulo_id
                WHERE lp.nro_lote LIKE ? || '%'
                ON CONFLICT (almacen_id, articulo_id, lote_pallet_id) DO NOTHING
                """, USER_ID, PREFIX_LOTE);
    }

    private static int ensureBulkArticuloAlmacenPosicion(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen_posicion (ubicacion_almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio, created_by)
                SELECT ub.id, art.id, (6 + (ub.id % 25))::numeric, (ub.id % 4)::numeric,
                    ROUND(COALESCE(art.precio_venta, 3.5) * 0.88, 6), ?
                FROM almacen.ubicacion_almacen ub
                JOIN core.articulo art ON art.codigo = ? || LPAD((1 + ((ub.id % ?)))::text, 4, '0')
                WHERE ub.codigo LIKE ? || '%'
                ON CONFLICT (articulo_id, ubicacion_almacen_id) DO NOTHING
                """, USER_ID, PREFIX_ART, BULK_ROWS, PREFIX_UBI);
    }

    private static int ensureBulkArticuloSaldoMensual(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.articulo_saldo_mensual (
                    almacen_id, articulo_id, vale_mov_det_id, fecha, tipo, cantidad, costo_unitario, costo_total,
                    saldo_cantidad, saldo_costo_unitario, saldo_costo_total, created_by)
                SELECT aa.almacen_id, aa.articulo_id, vd.id, ?::date, 'INGRESO',
                    vd.cant_procesada, vd.costo_unitario, vd.cant_procesada * COALESCE(vd.costo_unitario, 0),
                    aa.cantidad_disponible, aa.costo_promedio, aa.cantidad_disponible * aa.costo_promedio, ?
                FROM almacen.vale_mov_det vd
                JOIN almacen.vale_mov vm ON vm.id = vd.vale_mov_id
                JOIN almacen.articulo_almacen aa ON aa.almacen_id = vm.almacen_id AND aa.articulo_id = vd.articulo_id
                WHERE vm.nro_vale LIKE ? || '%' AND LENGTH(vm.nro_vale) = 12
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.articulo_saldo_mensual s WHERE s.vale_mov_det_id = vd.id
                  )
                """, today, USER_ID, PREFIX_VALE);
    }

    private static Long resolveBulkTipoMovId(JdbcTemplate jdbc, Long fallback) {
        Long bulk = jdbc.query(
                "SELECT id FROM almacen.articulo_mov_tipo WHERE tipo_mov LIKE 'B%' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
        if (bulk != null) {
            return bulk;
        }
        if (fallback != null) {
            return fallback;
        }
        return jdbc.query(
                "SELECT id FROM almacen.articulo_mov_tipo WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }
}
