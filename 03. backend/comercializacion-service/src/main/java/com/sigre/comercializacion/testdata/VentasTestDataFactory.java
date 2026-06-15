package com.sigre.comercializacion.testdata;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Test data factory intended for automated tests (idempotent).
 *
 * <p>Unlike the admin/demo seed endpoint, this factory avoids mass deletes and can be called
 * multiple times during a test run. It operates on the current tenant database (routing datasource).</p>
 *
 * <p>La comanda de prueba enlaza cabecera y detalle por punto de venta, mesa y cliente de fábrica
 * (constantes {@code FACTORY_*}) sin usar el último {@code comanda.id} de la tabla.</p>
 */
@Component
@RequiredArgsConstructor
public class VentasTestDataFactory {

    /** Filas masivas por tabla ventas (ver {@link VentasTestDataFactoryBulk}). */
    public static final int BULK_ROWS_PER_TABLE = VentasTestDataFactoryBulk.BULK_ROWS;

    /** Discriminadores estables para acoplar cabecera/detalle sin depender del último `id` global. */
    private static final String FACTORY_PV_CODIGO = "PV-TEST";
    private static final String FACTORY_COMANDA_MESA = "M-TEST-01";
    private static final long FACTORY_CLIENTE_CONTRIBUYENTE_ID = 2L;

    private final DataSource dataSource;

    @Transactional
    public Map<String, Integer> ensureVentasTransactionalData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("core.entidad_contribuyente", ensureEntidadContribuyente(jdbc));
        out.put("ventas.vta_zona_venta", ensureZonaVentaComercial(jdbc));
        out.put("ventas.punto_venta", ensurePuntoVenta(jdbc));
        out.put("ventas.zona + mesa", ensureZonaYMesa(jdbc));
        out.put("ventas.pedido_mesa", ensurePedidoMesa(jdbc));
        out.put("ventas.comanda + det", ensureComanda(jdbc));
        out.put("ventas.fs_factura_simpl + det + pagos", ensureFacturaSimplificada(jdbc));
        out.put("ventas.orden_venta + det", ensureOrdenVenta(jdbc));
        out.put("ventas.proforma + det", ensureProforma(jdbc));
        out.put("ventas.cierre_caja", ensureCierreCaja(jdbc));
        out.put("ventas.descuento_promocion", ensureDescuentoPromocion(jdbc));

        Map<String, Integer> bulk = VentasTestDataFactoryBulk.ensureBulkDataset(jdbc);
        bulk.forEach(out::put);

        return out;
    }

    public boolean isVentasSchemaReady() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return tableExists(jdbc, "ventas", "comanda")
                && tableExists(jdbc, "ventas", "orden_venta");
    }

    public int countComandasBulkEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM ventas.comanda
                WHERE mesa LIKE ? || '%' AND cliente_id = ? AND flag_estado = '1'
                """, Integer.class, VentasTestDataFactoryBulk.PREFIX_COMANDA_MESA, VentasTestDataFactoryBulk.CLIENTE_ID);
        return n != null ? n : 0;
    }

    public int countOrdenesVentaBulkEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM ventas.orden_venta WHERE nro_orden_venta LIKE ? || '%'",
                Integer.class, VentasTestDataFactoryBulk.PREFIX_OV);
        return n != null ? n : 0;
    }

    public int countFacturasBulkEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM ventas.fs_factura_simpl WHERE serie = ?",
                Integer.class, VentasTestDataFactoryBulk.SERIE_FS);
        return n != null ? n : 0;
    }

    static boolean tableExists(JdbcTemplate jdbc, String schema, String table) {
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM information_schema.tables
                WHERE table_schema = ? AND table_name = ?
                """, Integer.class, schema, table);
        return n != null && n > 0;
    }

    private int ensureEntidadContribuyente(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO core.entidad_contribuyente (
                id, tipo_persona, tipo_documento, nro_documento, razon_social,
                es_proveedor, es_cliente, es_empleado, flag_estado
            ) VALUES
            (2, 'JURIDICA', 'RUC', '20987654321', 'CLIENTE DEMO E.I.R.L.', FALSE, TRUE, FALSE, '1')
            ON CONFLICT (id) DO UPDATE SET
                tipo_persona = EXCLUDED.tipo_persona,
                tipo_documento = EXCLUDED.tipo_documento,
                nro_documento = EXCLUDED.nro_documento,
                razon_social = EXCLUDED.razon_social,
                es_proveedor = EXCLUDED.es_proveedor,
                es_cliente = EXCLUDED.es_cliente,
                es_empleado = EXCLUDED.es_empleado,
                flag_estado = EXCLUDED.flag_estado
            """);
    }

    private int ensureZonaVentaComercial(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO ventas.vta_zona_venta (zona_venta, desc_zona_venta, ubigeo, flag_estado)
            SELECT 'ZV-TEST', 'Zona Venta Test', '150101', '1'
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.vta_zona_venta z WHERE z.zona_venta = 'ZV-TEST'
            )
            """);
    }

    private int ensurePuntoVenta(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO ventas.punto_venta (sucursal_id, almacen_id, codigo, nombre, serie_boleta, serie_factura, tipo_impresora, flag_estado)
            SELECT s.id,
                   (SELECT a.id FROM almacen.almacen a WHERE a.flag_estado='1' ORDER BY a.id LIMIT 1),
                   ?, 'Caja Test', 'B009', 'F009', 'TICKETERA', '1'
            FROM auth.sucursal s
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.punto_venta pv
                WHERE pv.sucursal_id = s.id AND pv.codigo = ?
            )
            ORDER BY s.id
            LIMIT 1
            """, FACTORY_PV_CODIGO, FACTORY_PV_CODIGO);
    }

    private int ensureZonaYMesa(JdbcTemplate jdbc) {
        int z = jdbc.update("""
            INSERT INTO ventas.zona (sucursal_id, nombre, capacidad, flag_estado)
            SELECT s.id, 'SALON-TEST', 10, '1'
            FROM auth.sucursal s
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.zona z
                WHERE z.sucursal_id = s.id AND z.nombre = 'SALON-TEST'
            )
            ORDER BY s.id
            LIMIT 1
            """);

        int m = jdbc.update("""
            INSERT INTO ventas.mesa (zona_id, numero, capacidad, flag_estado)
            SELECT z.id, ?, 4, '1'
            FROM ventas.zona z
            WHERE z.nombre = 'SALON-TEST'
              AND NOT EXISTS (SELECT 1 FROM ventas.mesa m WHERE m.numero = ?)
            ORDER BY z.id
            LIMIT 1
            """, FACTORY_COMANDA_MESA, FACTORY_COMANDA_MESA);

        return z + m;
    }

    private int ensurePedidoMesa(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO ventas.pedido_mesa (
                sucursal_id, tipo, mesa_id, mesero_id, turno_id, numero, comensales, apertura, observaciones, flag_estado
            )
            SELECT s.id, 'SALON', m.id, 1, 1, 'PM-TEST-0001', 2, NOW(), 'Pedido test', '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM ventas.mesa WHERE numero = ? ORDER BY id LIMIT 1) m
            WHERE NOT EXISTS (SELECT 1 FROM ventas.pedido_mesa pm WHERE pm.numero = 'PM-TEST-0001')
            """, FACTORY_COMANDA_MESA);
    }

    private int ensureComanda(JdbcTemplate jdbc) {
        int cab = jdbc.update("""
            INSERT INTO ventas.comanda (sucursal_id, punto_venta_id, turno_id, cliente_id, mesa, fecha_hora, total, flag_estado)
            SELECT s.id, pv.id, 1, ec.id, ?, NOW(), 0, '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM ventas.punto_venta WHERE codigo = ? ORDER BY id LIMIT 1) pv
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente WHERE id = ?) ec
            WHERE NOT EXISTS (
                SELECT 1
                FROM ventas.comanda c
                INNER JOIN ventas.punto_venta pv2 ON pv2.id = c.punto_venta_id AND pv2.codigo = ?
                WHERE c.mesa = ?
                  AND c.flag_estado = '1'
                  AND c.cliente_id = ?
            )
            """,
                FACTORY_COMANDA_MESA,
                FACTORY_PV_CODIGO,
                FACTORY_CLIENTE_CONTRIBUYENTE_ID,
                FACTORY_PV_CODIGO,
                FACTORY_COMANDA_MESA,
                FACTORY_CLIENTE_CONTRIBUYENTE_ID);

        int det = jdbc.update("""
            INSERT INTO ventas.comanda_det (comanda_id, articulo_id, cantidad, precio_unitario, subtotal, observacion, flag_estado)
            SELECT fc.id, a.id, 1.0000, COALESCE(a.precio_venta, 1.0000), COALESCE(a.precio_venta, 1.0000), 'Item test', '1'
            FROM (
                SELECT c.id
                FROM ventas.comanda c
                INNER JOIN ventas.punto_venta pv ON pv.id = c.punto_venta_id AND pv.codigo = ?
                WHERE c.mesa = ?
                  AND c.flag_estado = '1'
                  AND c.cliente_id = ?
                ORDER BY c.id ASC
                LIMIT 1
            ) fc
            CROSS JOIN (SELECT id, precio_venta FROM core.articulo ORDER BY id LIMIT 1) a
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.comanda_det d WHERE d.comanda_id = fc.id AND d.articulo_id = a.id
            )
            """,
                FACTORY_PV_CODIGO,
                FACTORY_COMANDA_MESA,
                FACTORY_CLIENTE_CONTRIBUYENTE_ID);

        return cab + det;
    }

    private int ensureFacturaSimplificada(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();

        int cab = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl (
                sucursal_id, punto_venta_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision,
                moneda_id, subtotal, impuesto, total, ano, mes, cntbl_libro_id, flag_estado
            )
            SELECT s.id, pv.id, ec.id, dt.id, 'B009', '00000001', ?::date,
                   m.id, 10.0000, 0, 10.0000,
                   EXTRACT(YEAR FROM ?::date)::int, EXTRACT(MONTH FROM ?::date)::int,
                   1, '1'
            """, today, today, today, FACTORY_PV_CODIGO, FACTORY_CLIENTE_CONTRIBUYENTE_ID);

        int det = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl_det (fs_factura_simpl_id, articulo_id, unidad_medida_id, cantidad, precio_unitario, subtotal, flag_estado)
            SELECT f.id, a.id, a.unidad_medida_id, 1.0000, COALESCE(a.precio_venta, 10.0000), COALESCE(a.precio_venta, 10.0000), '1'
            FROM (SELECT id FROM ventas.fs_factura_simpl WHERE serie='B009' AND numero='00000001' ORDER BY id LIMIT 1) f
            CROSS JOIN (SELECT id, unidad_medida_id, precio_venta FROM core.articulo ORDER BY id LIMIT 1) a
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.fs_factura_simpl_det d WHERE d.fs_factura_simpl_id = f.id AND d.articulo_id = a.id
            )
            """);

        int pago = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl_pagos (fs_factura_simpl_id, forma_pago_id, monto, referencia, flag_estado)
            SELECT f.id, NULL, 10.0000, 'EFECTIVO', '1'
            FROM (SELECT id FROM ventas.fs_factura_simpl WHERE serie='B009' AND numero='00000001' ORDER BY id LIMIT 1) f
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.fs_factura_simpl_pagos p WHERE p.fs_factura_simpl_id = f.id
            )
            """);

        return cab + det + pago;
    }

    private int ensureOrdenVenta(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();

        int cab = jdbc.update("""
            INSERT INTO ventas.orden_venta (
                sucursal_id, nro_orden_venta, cliente_id, fecha_emision,
                moneda_id, doc_tipo_id, monto_total, flag_estado
            )
            SELECT s.id, 'OV-TEST-0001', ec.id, ?::date,
                   m.id, dt.id, 25.0000, '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente WHERE id = ?) ec
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
            WHERE NOT EXISTS (SELECT 1 FROM ventas.orden_venta ov WHERE ov.nro_orden_venta='OV-TEST-0001')
            """, today, FACTORY_CLIENTE_CONTRIBUYENTE_ID);

        int det = jdbc.update("""
            INSERT INTO ventas.orden_venta_det (
                orden_venta_id, articulo_id, linea_nro, cant_proyectada, valor_unitario, subtotal, almacen_id, flag_estado
            )
            SELECT ov.id, a.id, 1, 5.0000, COALESCE(a.precio_venta, 5.0000), 25.0000,
                   (SELECT id FROM almacen.almacen WHERE flag_estado='1' ORDER BY id LIMIT 1),
                   '1'
            FROM (SELECT id FROM ventas.orden_venta WHERE nro_orden_venta='OV-TEST-0001' ORDER BY id LIMIT 1) ov
            CROSS JOIN (SELECT id, precio_venta FROM core.articulo ORDER BY id LIMIT 1) a
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.orden_venta_det d WHERE d.orden_venta_id = ov.id AND d.articulo_id = a.id
            )
            """);

        return cab + det;
    }

    /** Proforma fija {@code PF-FACTORY-001} + una línea (idempotente). */
    private int ensureProforma(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        int cab = jdbc.update("""
            INSERT INTO ventas.proforma (
                sucursal_id, cliente_id, numero, fecha, fecha_validez, moneda_id,
                subtotal, igv, total, flag_estado
            )
            SELECT s.id, ec.id, 'PF-FACTORY-001',
                   (?::date),
                   (?::date + INTERVAL '30 days')::date,
                   m.id,
                   100.0000, 18.0000, 118.0000, '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente WHERE id = ?) ec
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            WHERE NOT EXISTS (SELECT 1 FROM ventas.proforma WHERE numero = 'PF-FACTORY-001')
            """, today, today, FACTORY_CLIENTE_CONTRIBUYENTE_ID);

        int det = jdbc.update("""
            INSERT INTO ventas.proforma_det (
                proforma_id, articulo_id, descripcion, cantidad, precio_unitario, descuento, subtotal
            )
            SELECT p.id, a.id, 'Factory línea', 2.0000, 50.0000, 0.0000, 100.0000
            FROM (SELECT id FROM ventas.proforma WHERE numero = 'PF-FACTORY-001' ORDER BY id LIMIT 1) p
            CROSS JOIN (SELECT id FROM core.articulo ORDER BY id LIMIT 1) a
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.proforma_det d WHERE d.proforma_id = p.id AND d.articulo_id = a.id
            )
            """);

        return cab + det;
    }

    /** Un cierre abierto identificado por {@code FACTORY-CIERRE-ABIERTO}. */
    private int ensureCierreCaja(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO ventas.cierre_caja (
                turno_id, ventas_efectivo, ventas_tarjeta, ventas_digital, ventas_total,
                propinas_total, fondo_inicial, observaciones, fecha_cierre, flag_estado
            )
            SELECT 888001, 10.0000, 5.0000, 2.0000, 17.0000, 1.0000, 100.0000,
                   'FACTORY-CIERRE-ABIERTO', NULL, '1'
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.cierre_caja WHERE observaciones = 'FACTORY-CIERRE-ABIERTO'
            )
            """);
    }

    /** Promoción fija {@code PROMO-FACTORY-001}. */
    private int ensureDescuentoPromocion(JdbcTemplate jdbc) {
        return jdbc.update("""
            INSERT INTO ventas.descuento_promocion (nombre, tipo, valor, fecha_inicio, fecha_fin, flag_estado)
            SELECT 'PROMO-FACTORY-001', 'PCT', 8.0000, CURRENT_DATE, CURRENT_DATE + 365, '1'
            WHERE NOT EXISTS (
                SELECT 1 FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001'
            )
            """);
    }
}

