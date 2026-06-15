package com.sigre.comercializacion.testdata;

import org.springframework.jdbc.core.JdbcTemplate;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Inserciones masivas idempotentes (~{@link #BULK_ROWS} filas por tabla {@code ventas}) para tests IT.
 * No altera PV-TEST, M-TEST-01, OV-TEST-0001 ni demás códigos mínimos del factory base.
 */
final class VentasTestDataFactoryBulk {

    static final int BULK_ROWS = 120;
    static final long CLIENTE_ID = 2L;
    static final String PREFIX_ZONA_VTA = "ZB";
    static final String PREFIX_ZONA_DES = "ZD";
    static final String PREFIX_ZONA_REP = "ZR";
    static final String PREFIX_CANAL = "CANB";
    static final String PREFIX_PV = "PVB";
    static final String PREFIX_ZONA = "ZONA-BULK-";
    static final String PREFIX_MESA = "M-BULK-";
    static final String PREFIX_PEDIDO = "PM-BULK-";
    static final String PREFIX_COMANDA_MESA = "M-BULK-";
    static final String PREFIX_OV = "OV-BULK-";
    static final String PREFIX_PF = "PF-BULK-";
    static final String PREFIX_PROMO = "PROMO-BULK-";
    static final String SERIE_FS = "BBL";
    static final String PREFIX_CARTA = "CARTA-BULK-";
    static final String PREFIX_RES = "RES-BULK-";

    private VentasTestDataFactoryBulk() {
    }

    static Map<String, Integer> ensureBulkDataset(JdbcTemplate jdbc) {
        Map<String, Integer> out = new LinkedHashMap<>();
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "comanda")) {
            return out;
        }
        out.put("bulk.ventas.vta_zona_venta", ensureBulkZonaVenta(jdbc));
        out.put("bulk.ventas.vta_zona_despacho", ensureBulkZonaDespacho(jdbc));
        out.put("bulk.ventas.vta_zona_reparto", ensureBulkZonaReparto(jdbc));
        out.put("bulk.ventas.canal_distribucion", ensureBulkCanalDistribucion(jdbc));
        out.put("bulk.ventas.servicios_cxc", ensureBulkServiciosCxc(jdbc));
        out.put("bulk.ventas.vendedor", ensureBulkVendedor(jdbc));
        out.put("bulk.ventas.punto_venta", ensureBulkPuntoVenta(jdbc));
        out.put("bulk.ventas.zona", ensureBulkZonas(jdbc));
        out.put("bulk.ventas.mesa", ensureBulkMesas(jdbc));
        out.put("bulk.ventas.pedido_mesa", ensureBulkPedidoMesa(jdbc));
        out.put("bulk.ventas.pedido_mesa_det", ensureBulkPedidoMesaDet(jdbc));
        out.put("bulk.ventas.comanda", ensureBulkComandas(jdbc));
        out.put("bulk.ventas.comanda_det", ensureBulkComandaDet(jdbc));
        out.put("bulk.ventas.fs_factura_simpl", ensureBulkFacturas(jdbc));
        out.put("bulk.ventas.fs_factura_simpl_det", ensureBulkFacturaDet(jdbc));
        out.put("bulk.ventas.fs_factura_simpl_pagos", ensureBulkFacturaPagos(jdbc));
        out.put("bulk.ventas.entidad_creditos_cxc", ensureBulkEntidadCreditos(jdbc));
        out.put("bulk.ventas.cntas_cobrar", ensureBulkCntasCobrar(jdbc));
        out.put("bulk.ventas.cntas_cobrar_det", ensureBulkCntasCobrarDet(jdbc));
        out.put("bulk.ventas.orden_venta", ensureBulkOrdenVenta(jdbc));
        out.put("bulk.ventas.orden_venta_det", ensureBulkOrdenVentaDet(jdbc));
        out.put("bulk.ventas.proforma", ensureBulkProformas(jdbc));
        out.put("bulk.ventas.proforma_det", ensureBulkProformaDet(jdbc));
        out.put("bulk.ventas.cierre_caja", ensureBulkCierreCaja(jdbc));
        out.put("bulk.ventas.descuento_promocion", ensureBulkDescuentoPromocion(jdbc));
        out.put("bulk.ventas.propina", ensureBulkPropinas(jdbc));
        out.put("bulk.ventas.reservacion", ensureBulkReservaciones(jdbc));
        out.put("bulk.ventas.reservacion_det", ensureBulkReservacionDet(jdbc));
        out.put("bulk.ventas.carta", ensureBulkCartas(jdbc));
        out.put("bulk.ventas.carta_det", ensureBulkCartaDet(jdbc));
        return out;
    }

    private static int ensureBulkZonaVenta(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "vta_zona_venta")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.vta_zona_venta (zona_venta, desc_zona_venta, ubigeo, flag_estado)
                SELECT ? || LPAD(g::text, 6, '0'), 'Zona venta bulk ' || g, '150101', '1'
                FROM generate_series(1, ?) AS g
                ON CONFLICT (zona_venta) DO NOTHING
                """, PREFIX_ZONA_VTA, BULK_ROWS);
    }

    private static int ensureBulkZonaDespacho(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "vta_zona_despacho")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.vta_zona_despacho (zona_despacho, desc_zona_despacho, ubigeo, flag_estado)
                SELECT ? || LPAD(g::text, 6, '0'), 'Zona despacho bulk ' || g, '150102', '1'
                FROM generate_series(1, ?) AS g
                ON CONFLICT (zona_despacho) DO NOTHING
                """, PREFIX_ZONA_DES, BULK_ROWS);
    }

    private static int ensureBulkZonaReparto(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "vta_zona_reparto")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.vta_zona_reparto (zona_reparto, desc_zona_reparto, ubigeo, flag_estado)
                SELECT ? || LPAD(g::text, 6, '0'), 'Zona reparto bulk ' || g, '150103', '1'
                FROM generate_series(1, ?) AS g
                ON CONFLICT (zona_reparto) DO NOTHING
                """, PREFIX_ZONA_REP, BULK_ROWS);
    }

    private static int ensureBulkCanalDistribucion(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "canal_distribucion")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.canal_distribucion (codigo, nombre, flag_estado)
                SELECT ? || LPAD(g::text, 4, '0'), 'Canal bulk ' || g, '1'
                FROM generate_series(1, ?) AS g
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.canal_distribucion c WHERE c.codigo = ? || LPAD(g::text, 4, '0')
                )
                """, PREFIX_CANAL, BULK_ROWS, PREFIX_CANAL);
    }

    private static int ensureBulkServiciosCxc(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "servicios_cxc")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.servicios_cxc (cod_servicio, desc_servicio, tarifa, flag_estado)
                SELECT LPAD((100 + g)::text, 3, '0'), 'Servicio CxC bulk ' || g, 10.0000 + g, '1'
                FROM generate_series(1, ?) AS g
                ON CONFLICT (cod_servicio) DO NOTHING
                """, BULK_ROWS);
    }

    private static int ensureBulkVendedor(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "vendedor")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.vendedor (usuario_id, nombre, comision_porcentaje, flag_estado)
                SELECT g, 'Vendedor bulk ' || g, 2.5000 + (g % 5), '1'
                FROM generate_series(1, ?) AS g
                WHERE NOT EXISTS (SELECT 1 FROM ventas.vendedor v WHERE v.usuario_id = g)
                """, BULK_ROWS);
    }

    private static int ensureBulkPuntoVenta(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "punto_venta")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.punto_venta (sucursal_id, almacen_id, codigo, nombre, serie_boleta, serie_factura, tipo_impresora, flag_estado)
                SELECT s.id, (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1),
                    ? || LPAD(g::text, 3, '0'), 'Caja bulk ' || g, 'B' || LPAD(g::text, 2, '0'), 'F' || LPAD(g::text, 2, '0'), 'TICKETERA', '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                ON CONFLICT (sucursal_id, codigo) DO NOTHING
                """, PREFIX_PV, BULK_ROWS);
    }

    private static int ensureBulkZonas(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "zona")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.zona (sucursal_id, nombre, capacidad, flag_estado)
                SELECT s.id, ? || LPAD(g::text, 3, '0'), 20 + (g % 30), '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.zona z WHERE z.nombre = ? || LPAD(g::text, 3, '0')
                )
                """, PREFIX_ZONA, BULK_ROWS, PREFIX_ZONA);
    }

    private static int ensureBulkMesas(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.mesa (zona_id, numero, capacidad, flag_estado)
                SELECT z.id, ? || LPAD(g::text, 3, '0'), 4 + (g % 6), '1'
                FROM generate_series(1, ?) AS g
                JOIN ventas.zona z ON z.nombre = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                ON CONFLICT (numero) DO NOTHING
                """, PREFIX_MESA, BULK_ROWS, PREFIX_ZONA, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkPedidoMesa(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.pedido_mesa (sucursal_id, tipo, mesa_id, mesero_id, turno_id, numero, comensales, apertura, flag_estado)
                SELECT s.id, 'SALON', m.id, 1, 1, ? || LPAD(g::text, 4, '0'), 2 + (g % 4), NOW(), '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                JOIN ventas.mesa m ON m.numero = ? || LPAD(g::text, 3, '0')
                ON CONFLICT (numero) DO NOTHING
                """, PREFIX_PEDIDO, BULK_ROWS, PREFIX_MESA);
    }

    private static int ensureBulkPedidoMesaDet(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "pedido_mesa_det")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.pedido_mesa_det (pedido_mesa_id, articulo_id, cantidad, precio_unitario, subtotal, flag_estado)
                SELECT pm.id, a.id, 1.0000, COALESCE(a.precio_venta, 5.0000), COALESCE(a.precio_venta, 5.0000), '1'
                FROM ventas.pedido_mesa pm
                CROSS JOIN (SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE pm.numero LIKE ? || '%'
                  AND NOT EXISTS (SELECT 1 FROM ventas.pedido_mesa_det d WHERE d.pedido_mesa_id = pm.id)
                """, PREFIX_PEDIDO);
    }

    private static int ensureBulkComandas(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.comanda (sucursal_id, punto_venta_id, turno_id, cliente_id, mesa, fecha_hora, total, flag_estado)
                SELECT s.id, pv.id, 1, ?, ? || LPAD(g::text, 3, '0'), NOW() - ((g || ' minutes')::interval), 0, '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                JOIN ventas.punto_venta pv ON pv.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.comanda c
                    WHERE c.mesa = ? || LPAD(g::text, 3, '0') AND c.cliente_id = ? AND c.flag_estado = '1'
                )
                """, CLIENTE_ID, PREFIX_COMANDA_MESA, BULK_ROWS, PREFIX_PV, Math.min(BULK_ROWS, 100),
                PREFIX_COMANDA_MESA, CLIENTE_ID);
    }

    private static int ensureBulkComandaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.comanda_det (comanda_id, articulo_id, cantidad, precio_unitario, subtotal, observacion, flag_estado)
                SELECT c.id, a.id, 1.0000, COALESCE(a.precio_venta, 8.0000), COALESCE(a.precio_venta, 8.0000), 'Det bulk', '1'
                FROM ventas.comanda c
                CROSS JOIN (SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE c.mesa LIKE ? || '%' AND c.cliente_id = ?
                  AND NOT EXISTS (SELECT 1 FROM ventas.comanda_det d WHERE d.comanda_id = c.id AND d.articulo_id = a.id)
                """, PREFIX_COMANDA_MESA, CLIENTE_ID);
    }

    private static int ensureBulkFacturas(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.fs_factura_simpl (
                    sucursal_id, punto_venta_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision,
                    moneda_id, subtotal, impuesto, total, ano, mes, cntbl_libro_id, flag_estado)
                SELECT s.id, pv.id, ?, dt.id, ?, LPAD(g::text, 8, '0'), ?::date, m.id,
                    10.0000 + g, 1.8000 + (g % 5), 11.8000 + g,
                    EXTRACT(YEAR FROM ?::date)::int, EXTRACT(MONTH FROM ?::date)::int,
                    1, '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                JOIN ventas.punto_venta pv ON pv.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                ON CONFLICT (doc_tipo_id, serie, numero) DO NOTHING
                """, CLIENTE_ID, SERIE_FS, today, today, today, BULK_ROWS, PREFIX_PV, Math.min(BULK_ROWS, 100));
    }

    private static int ensureBulkFacturaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.fs_factura_simpl_det (fs_factura_simpl_id, articulo_id, unidad_medida_id, cantidad, precio_unitario, subtotal, flag_estado)
                SELECT f.id, a.id, a.unidad_medida_id, 1.0000, COALESCE(a.precio_venta, 10.0000), COALESCE(a.precio_venta, 10.0000), '1'
                FROM ventas.fs_factura_simpl f
                CROSS JOIN (SELECT id, unidad_medida_id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE f.serie = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM ventas.fs_factura_simpl_det d WHERE d.fs_factura_simpl_id = f.id AND d.articulo_id = a.id
                  )
                """, SERIE_FS);
    }

    private static int ensureBulkFacturaPagos(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.fs_factura_simpl_pagos (fs_factura_simpl_id, monto, referencia, flag_estado)
                SELECT f.id, f.total, 'PAGO-BULK', '1'
                FROM ventas.fs_factura_simpl f
                WHERE f.serie = ?
                  AND NOT EXISTS (SELECT 1 FROM ventas.fs_factura_simpl_pagos p WHERE p.fs_factura_simpl_id = f.id)
                """, SERIE_FS);
    }

    private static int ensureBulkEntidadCreditos(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "entidad_creditos_cxc")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.entidad_creditos_cxc (entidad_contribuyente_id, moneda_id, limite_credito, dias_credito, flag_estado)
                SELECT ec.id, m.id, 5000.0000 + (ec.id % 1000), 30 + (ec.id % 15), '1'
                FROM (
                    SELECT id FROM core.entidad_contribuyente
                    WHERE es_cliente = TRUE AND flag_estado = '1'
                    ORDER BY id
                    LIMIT ?
                ) ec
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.entidad_creditos_cxc x WHERE x.entidad_contribuyente_id = ec.id
                )
                """, BULK_ROWS);
    }

    private static int ensureBulkCntasCobrar(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "cntas_cobrar")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.cntas_cobrar (
                    sucursal_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision, fecha_vencimiento,
                    moneda_id, total, saldo, ano, mes, cntbl_libro_id, flag_estado)
                SELECT s.id, ?, dt.id, 'CXB', LPAD(g::text, 8, '0'), ?::date, (?::date + 30), m.id,
                    100.0000 + g, 100.0000 + g,
                    EXTRACT(YEAR FROM ?::date)::INTEGER, EXTRACT(MONTH FROM ?::date)::INTEGER, cl.id, '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                CROSS JOIN (SELECT id FROM contabilidad.cntbl_libro WHERE codigo = '4' ORDER BY id LIMIT 1) cl
                ON CONFLICT (cliente_id, doc_tipo_id, serie, numero) DO NOTHING
                """, CLIENTE_ID, today, today, today, today, BULK_ROWS);
    }

    private static int ensureBulkCntasCobrarDet(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "finanzas", "concepto_financiero")
                || !VentasTestDataFactory.tableExists(jdbc, "ventas", "cntas_cobrar_det")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.cntas_cobrar_det (cntas_cobrar_id, concepto_financiero_id, fecha_mov, tipo_mov, monto, referencia, flag_estado)
                SELECT c.id, cf.id, ?::date, 'CARGO', c.total, 'CXC-BULK', '1'
                FROM ventas.cntas_cobrar c
                CROSS JOIN (SELECT id FROM finanzas.concepto_financiero WHERE flag_estado = '1' ORDER BY id LIMIT 1) cf
                WHERE c.serie = 'CXB'
                  AND NOT EXISTS (SELECT 1 FROM ventas.cntas_cobrar_det d WHERE d.cntas_cobrar_id = c.id)
                """, today);
    }

    private static int ensureBulkOrdenVenta(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.orden_venta (sucursal_id, nro_orden_venta, cliente_id, fecha_emision, moneda_id, doc_tipo_id, monto_total, flag_estado)
                SELECT s.id, ? || LPAD(g::text, 4, '0'), ?, ?::date, m.id, dt.id, 50.0000 + (g * 3), '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
                ON CONFLICT (nro_orden_venta) DO NOTHING
                """, PREFIX_OV, CLIENTE_ID, today, BULK_ROWS);
    }

    private static int ensureBulkOrdenVentaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.orden_venta_det (orden_venta_id, articulo_id, linea_nro, cant_proyectada, valor_unitario, subtotal, almacen_id, flag_estado)
                SELECT ov.id, a.id, 1, 5.0000, COALESCE(a.precio_venta, 10.0000), 50.0000,
                    (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1), '1'
                FROM ventas.orden_venta ov
                CROSS JOIN (SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE ov.nro_orden_venta LIKE ? || '%'
                  AND NOT EXISTS (SELECT 1 FROM ventas.orden_venta_det d WHERE d.orden_venta_id = ov.id)
                """, PREFIX_OV);
    }

    private static int ensureBulkProformas(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.proforma (sucursal_id, cliente_id, numero, fecha, fecha_validez, moneda_id, subtotal, igv, total, flag_estado)
                SELECT s.id, ?, ? || LPAD(g::text, 4, '0'), ?::date, (?::date + 30), m.id, 100.0000, 18.0000, 118.0000, '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                ON CONFLICT (numero) DO NOTHING
                """, CLIENTE_ID, PREFIX_PF, today, today, BULK_ROWS);
    }

    private static int ensureBulkProformaDet(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.proforma_det (proforma_id, articulo_id, descripcion, cantidad, precio_unitario, descuento, subtotal)
                SELECT p.id, a.id, 'Línea bulk proforma', 2.0000, 50.0000, 0, 100.0000
                FROM ventas.proforma p
                CROSS JOIN (SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE p.numero LIKE ? || '%'
                  AND NOT EXISTS (SELECT 1 FROM ventas.proforma_det d WHERE d.proforma_id = p.id)
                """, PREFIX_PF);
    }

    private static int ensureBulkCierreCaja(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.cierre_caja (turno_id, ventas_efectivo, ventas_tarjeta, ventas_digital, ventas_total,
                    propinas_total, fondo_inicial, observaciones, flag_estado)
                SELECT 880000 + g, 10.0000 + g, 5.0000, 2.0000, 17.0000 + g, 1.0000, 100.0000,
                    'CIERRE-BULK-' || g, '1'
                FROM generate_series(1, ?) AS g
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.cierre_caja c WHERE c.observaciones = 'CIERRE-BULK-' || g
                )
                """, BULK_ROWS);
    }

    private static int ensureBulkDescuentoPromocion(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO ventas.descuento_promocion (nombre, tipo, valor, fecha_inicio, fecha_fin, flag_estado)
                SELECT ? || LPAD(g::text, 3, '0'), 'PCT', 5.0000 + (g % 10), CURRENT_DATE, CURRENT_DATE + 365, '1'
                FROM generate_series(1, ?) AS g
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.descuento_promocion d WHERE d.nombre = ? || LPAD(g::text, 3, '0')
                )
                """, PREFIX_PROMO, BULK_ROWS, PREFIX_PROMO);
    }

    private static int ensureBulkPropinas(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "propina")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.propina (fs_factura_simpl_id, monto, fecha, flag_estado)
                SELECT f.id, 2.0000 + (f.id % 5), ?::date, '1'
                FROM ventas.fs_factura_simpl f
                WHERE f.serie = ?
                  AND NOT EXISTS (SELECT 1 FROM ventas.propina p WHERE p.fs_factura_simpl_id = f.id)
                """, today, SERIE_FS);
    }

    private static int ensureBulkReservaciones(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "reservacion")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO ventas.reservacion (sucursal_id, cliente_id, mesa_id, fecha, hora, comensales, estado, flag_estado)
                SELECT s.id, ?, m.id, ?::date, TIME '19:00', 2 + (g % 4), 'CONFIRMADA', '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                JOIN ventas.mesa m ON m.numero = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.reservacion r
                    WHERE r.cliente_id = ? AND r.mesa_id = m.id AND r.fecha = ?::date
                )
                """, CLIENTE_ID, today, BULK_ROWS, PREFIX_MESA, CLIENTE_ID, today);
    }

    private static int ensureBulkReservacionDet(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "reservacion_det")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.reservacion_det (reservacion_id, articulo_id, cantidad, observacion)
                SELECT r.id, a.id, 1.0000, 'Reserva bulk'
                FROM ventas.reservacion r
                CROSS JOIN (SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE r.estado = 'CONFIRMADA' AND r.cliente_id = ? AND r.fecha = CURRENT_DATE
                  AND NOT EXISTS (SELECT 1 FROM ventas.reservacion_det d WHERE d.reservacion_id = r.id)
                """, CLIENTE_ID);
    }

    private static int ensureBulkCartas(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "carta")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.carta (sucursal_id, nombre, descripcion, flag_estado)
                SELECT s.id, ? || LPAD(g::text, 3, '0'), 'Carta bulk factory ' || g, '1'
                FROM generate_series(1, ?) AS g
                CROSS JOIN (SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1) s
                WHERE NOT EXISTS (
                    SELECT 1 FROM ventas.carta c WHERE c.nombre = ? || LPAD(g::text, 3, '0')
                )
                """, PREFIX_CARTA, BULK_ROWS, PREFIX_CARTA);
    }

    private static int ensureBulkCartaDet(JdbcTemplate jdbc) {
        if (!VentasTestDataFactory.tableExists(jdbc, "ventas", "carta_det")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO ventas.carta_det (carta_id, articulo_id, precio, orden, flag_estado)
                SELECT c.id, a.id, COALESCE(a.precio_venta, 12.0000), 1, '1'
                FROM ventas.carta c
                CROSS JOIN (SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
                WHERE c.nombre LIKE ? || '%'
                  AND NOT EXISTS (SELECT 1 FROM ventas.carta_det d WHERE d.carta_id = c.id AND d.articulo_id = a.id)
                """, PREFIX_CARTA);
    }
}
