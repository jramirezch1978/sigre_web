package com.sigre.comercializacion.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Seeds demo data for local/testing environments (invoked via admin endpoint).
 *
 * <p>Cubre tablas {@code ventas.*} usadas por comercializacion-service: POS, OV, proforma, cierre de caja,
 * descuentos/promociones, CxC, etc.</p>
 *
 * <p>IMPORTANT: This service mutates the tenant database (DELETE/INSERT). El controlador solo
 * delega aquí cuando {@code app.testdata.enabled=true}; si no, responde 403.</p>
 */
@Service
@RequiredArgsConstructor
public class TestDataSeedService {

    /** Volumen demo masivo (POS, OV, proforma, CC, pedidos, comandas, facturas). */
    private static final int SEED_VENTAS_FS = 48;
    private static final int SEED_VENTAS_OV = 48;
    private static final int SEED_VENTAS_PF = 42;
    private static final int SEED_VENTAS_CC = 40;
    private static final int SEED_VENTAS_PEDIDO = 28;
    private static final int SEED_VENTAS_COMANDA = 32;
    private static final int SEED_VENTAS_CIERRE_EXTRA = 28;

    private final DataSource dataSource; // tenant routing datasource

    @Transactional
    public Map<String, Integer> seedVentasDemoData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        // Minimal core dependencies for FKs used by ventas.
        out.put("core.entidad_contribuyente", seedEntidadContribuyente(jdbc));

        // Evita DATABASE_ERROR por FK en la 2.ª ejecución: comanda/fs → punto_venta; pedido_mesa → mesa.
        clearVentasRowsBlockingMaestrosReseed(jdbc);

        // Maestros propios del schema ventas (sin FKs o simples)
        out.put("ventas.vta_zona_venta", seedZonaVentaComercial(jdbc));
        out.put("ventas.vta_zona_despacho", seedZonaDespacho(jdbc));
        out.put("ventas.vta_zona_reparto", seedZonaReparto(jdbc));
        out.put("ventas.canal_distribucion", seedCanalDistribucion(jdbc));
        out.put("ventas.servicios_cxc", seedServiciosCxC(jdbc));
        out.put("ventas.vendedor", seedVendedor(jdbc));

        // Carta menú (API carta)
        out.put("ventas.carta + carta_det", seedCarta(jdbc));

        // POS / sigree
        out.put("ventas.punto_venta", seedPuntoVenta(jdbc));
        out.put("ventas.zona + mesa", seedZonaYMesa(jdbc));
        out.put("ventas.pedido_mesa", seedPedidoMesa(jdbc));
        out.put("ventas.pedido_mesa_det", seedPedidoMesaDet(jdbc));
        out.put("ventas.comanda + det", seedComanda(jdbc));

        // Documentos simplificados (boleta/factura) + pagos
        out.put("ventas.fs_factura_simpl + det + pagos", seedFacturaSimplificada(jdbc));

        // OV comercial (cabecera + detalle)
        out.put("ventas.orden_venta + det", seedOrdenVenta(jdbc));

        out.put("ventas.proforma + det", seedProforma(jdbc));
        out.put("ventas.cierre_caja", seedCierreCaja(jdbc));
        out.put("ventas.descuento_promocion", seedDescuentoPromocion(jdbc));

        // CxC — datos para /api/ventas/cuentas-cobrar (PENDIENTE, PARCIAL, COBRADA, ANULADA + movimientos)
        out.put("ventas.cntas_cobrar + det", seedCuentasCobrar(jdbc));

        return out;
    }

    /**
     * Quita filas operativas que referencian {@code punto_venta} o {@code mesa} antes de que los seeds
     * de maestros las borren e inserten de nuevo (si no, PostgreSQL lanza error de FK → {@code DATABASE_ERROR}).
     */
    private void clearVentasRowsBlockingMaestrosReseed(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.comanda_det");
        jdbc.update("DELETE FROM ventas.comanda");
        jdbc.update("DELETE FROM ventas.fs_factura_simpl_pagos");
        jdbc.update("DELETE FROM ventas.fs_factura_simpl_det");
        jdbc.update("DELETE FROM ventas.fs_factura_simpl");
        if (ventasTableExists(jdbc, "pedido_mesa_det")) {
            jdbc.update("DELETE FROM ventas.pedido_mesa_det");
        }
        jdbc.update("DELETE FROM ventas.pedido_mesa");
    }

    private boolean ventasTableExists(JdbcTemplate jdbc, String tableName) {
        Boolean ok = jdbc.queryForObject(
                """
                SELECT EXISTS (
                    SELECT 1 FROM information_schema.tables
                    WHERE table_schema = 'ventas' AND table_name = ?
                )
                """,
                Boolean.class,
                tableName);
        return Boolean.TRUE.equals(ok);
    }

    private int seedEntidadContribuyente(JdbcTemplate jdbc) {
        // Keep aligned with other MS seeds to reduce FK issues.
        return jdbc.update("""
            INSERT INTO core.entidad_contribuyente (
                id, tipo_persona, tipo_documento, nro_documento, razon_social,
                es_proveedor, es_cliente, es_empleado, flag_estado
            ) VALUES
            (1, 'JURIDICA', 'RUC', '20123456789', 'PROVEEDOR DEMO S.A.C.', TRUE, FALSE, FALSE, '1'),
            (2, 'JURIDICA', 'RUC', '20987654321', 'CLIENTE DEMO E.I.R.L.', FALSE, TRUE, FALSE, '1'),
            (3, 'JURIDICA', 'RUC', '20111222333', 'TRANSPORTES ABC S.A.', FALSE, FALSE, FALSE, '1')
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

    private int seedZonaVentaComercial(JdbcTemplate jdbc) {
        // Table: ventas.vta_zona_venta (no FKs). Reset for deterministic demos.
        jdbc.update("DELETE FROM ventas.vta_zona_venta");
        return jdbc.update("""
            INSERT INTO ventas.vta_zona_venta (zona_venta, desc_zona_venta, ubigeo, flag_estado)
            SELECT 'ZV-' || LPAD(g::text, 3, '0'),
                   'Zona Venta Demo ' || LPAD(g::text, 3, '0'),
                   '150' || LPAD((100 + g)::text, 3, '0'),
                   '1'
            FROM generate_series(1, 32) AS g
            """);
    }

    private int seedZonaDespacho(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.vta_zona_despacho");
        return jdbc.update("""
            INSERT INTO ventas.vta_zona_despacho (zona_despacho, desc_zona_despacho, ubigeo, flag_estado)
            SELECT 'ZD-' || LPAD(g::text, 3, '0'),
                   'Zona Despacho Demo ' || LPAD(g::text, 3, '0'),
                   '140' || LPAD((120 + g)::text, 3, '0'),
                   '1'
            FROM generate_series(1, 14) AS g
            """);
    }

    private int seedZonaReparto(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.vta_zona_reparto");
        return jdbc.update("""
            INSERT INTO ventas.vta_zona_reparto (zona_reparto, desc_zona_reparto, ubigeo, flag_estado)
            SELECT 'ZR-' || LPAD(g::text, 3, '0'),
                   'Zona Reparto Demo ' || LPAD(g::text, 3, '0'),
                   '130' || LPAD((130 + g)::text, 3, '0'),
                   '1'
            FROM generate_series(1, 18) AS g
            """);
    }

    private int seedCanalDistribucion(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.canal_distribucion");
        return jdbc.update("""
            INSERT INTO ventas.canal_distribucion (codigo, nombre, flag_estado)
            VALUES
            ('LOCAL', 'Local', '1'),
            ('DELIV', 'Delivery', '1'),
            ('B2B', 'B2B', '1'),
            ('APP', 'App', '1'),
            ('WEB', 'Web', '1')
            """);
    }

    private int seedServiciosCxC(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.servicios_cxc");
        return jdbc.update("""
            INSERT INTO ventas.servicios_cxc (cod_servicio, desc_servicio, tarifa, cod_moneda, flag_afecto_igv, flag_estado)
            SELECT LPAD(g::text, 3, '0'),
                   'Servicio demo ' || LPAD(g::text, 3, '0'),
                   (8 + (g % 40) + g * 0.25)::numeric,
                   'PEN', '1', '1'
            FROM generate_series(1, 28) AS g
            """);
    }

    private int seedVendedor(JdbcTemplate jdbc) {
        // No FK in DDL; depends on conventions only (usuario_id).
        jdbc.update("DELETE FROM ventas.vendedor");
        return jdbc.update("""
            INSERT INTO ventas.vendedor (usuario_id, nombre, comision_porcentaje, flag_estado)
            SELECT 1 + ((g - 1) % 5),
                   'Vendedor Demo ' || LPAD(g::text, 3, '0'),
                   (1.5 + ((g % 7) * 0.35))::numeric,
                   '1'
            FROM generate_series(1, 26) AS g
            """);
    }

    /** Carta fija {@code SEED-CARTA-DEMO}: líneas tomadas de los primeros artículos activos. */
    private int seedCarta(JdbcTemplate jdbc) {
        jdbc.update("""
            DELETE FROM ventas.carta_det WHERE carta_id IN (
                SELECT id FROM ventas.carta WHERE nombre = 'SEED-CARTA-DEMO'
            )
            """);
        jdbc.update("DELETE FROM ventas.carta WHERE nombre = 'SEED-CARTA-DEMO'");
        int cab = jdbc.update("""
            INSERT INTO ventas.carta (sucursal_id, nombre, descripcion, flag_estado)
            SELECT s.id, 'SEED-CARTA-DEMO', 'Carta menú generada por test-data seed (comercializacion-service).', '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            """);
        int det = jdbc.update("""
            INSERT INTO ventas.carta_det (carta_id, articulo_id, precio, orden, flag_estado)
            SELECT c.id, a.id, COALESCE(a.precio_venta, 10.0000),
                   ROW_NUMBER() OVER (ORDER BY a.id), '1'
            FROM ventas.carta c
            JOIN LATERAL (
                SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 15
            ) a ON TRUE
            WHERE c.nombre = 'SEED-CARTA-DEMO'
            """);
        return cab + det;
    }

    private int seedPuntoVenta(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.punto_venta");
        return jdbc.update("""
            INSERT INTO ventas.punto_venta (
                sucursal_id, almacen_id, codigo, nombre, serie_boleta, serie_factura, tipo_impresora, flag_estado
            )
            SELECT s.id, a.id,
                   'PV-' || LPAD(g::text, 2, '0'),
                   'Caja demo ' || LPAD(g::text, 2, '0'),
                   'B' || LPAD(g::text, 3, '0'),
                   'F' || LPAD(g::text, 3, '0'),
                   CASE WHEN g % 3 = 0 THEN 'LASER' ELSE 'TICKETERA' END,
                   '1'
            FROM generate_series(1, 14) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado='1' ORDER BY id LIMIT 1) a
            """);
    }

    private int seedZonaYMesa(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.mesa");
        jdbc.update("DELETE FROM ventas.zona");
        int z = jdbc.update("""
            INSERT INTO ventas.zona (sucursal_id, nombre, capacidad, flag_estado)
            SELECT s.id, v.nombre, v.capacidad, '1'
            FROM (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (VALUES
                ('SALON',  60),
                ('TERRAZA', 40),
                ('VIP',    20)
            ) AS v(nombre, capacidad)
            """);
        int m = jdbc.update("""
            INSERT INTO ventas.mesa (zona_id, numero, capacidad, flag_estado)
            SELECT z.id, v.numero, v.capacidad, '1'
            FROM ventas.zona z
            JOIN (VALUES
                ('SALON',   'M-01', 4),
                ('SALON',   'M-02', 4),
                ('SALON',   'M-03', 6),
                ('SALON',   'M-04', 2),
                ('SALON',   'M-05', 4),
                ('SALON',   'M-06', 4),
                ('SALON',   'M-07', 8),
                ('SALON',   'M-08', 6),
                ('SALON',   'M-09', 4),
                ('SALON',   'M-10', 4),
                ('TERRAZA', 'T-01', 4),
                ('TERRAZA', 'T-02', 6),
                ('TERRAZA', 'T-03', 4),
                ('TERRAZA', 'T-04', 8),
                ('VIP',     'V-01', 8),
                ('VIP',     'V-02', 10),
                ('VIP',     'V-03', 12),
                ('VIP',     'V-04', 6)
            ) AS v(zona_nombre, numero, capacidad)
              ON v.zona_nombre = z.nombre
            """);
        return z + m;
    }

    /**
     * Pedidos de mesa demo: números {@code PM-DEMO-*} (único global en {@code pedido_mesa.numero}).
     * Solo borra/reinserta esos números; no vacía la tabla completa. Empareja 1 mesa ↔ 1 pedido (evita producto cartesiano).
     * Usar {@code CROSS JOIN} entre sucursal y {@code VALUES}: {@code JOIN} sin {@code ON} es inválido en PostgreSQL (error tipo {@code syntax error at end of input}).
     * No usar {@code ON CONFLICT ... DO NOTHING} aquí: en algunos servidores JDBC devuelve {@code syntax error at or near "DO"} con este {@code INSERT...SELECT...JOIN}.
     */
    private int seedPedidoMesa(JdbcTemplate jdbc) {
        // Quitar restos del seed antiguo (producto cartesiano usaba PM-0001…PM-0005).
        jdbc.update("""
            DELETE FROM ventas.pedido_mesa
            WHERE numero IN ('PM-0001', 'PM-0002', 'PM-0003', 'PM-0004', 'PM-0005')
            """);
        jdbc.update("DELETE FROM ventas.pedido_mesa WHERE numero LIKE 'PM-DEMO-%'");
        return jdbc.update("""
            INSERT INTO ventas.pedido_mesa (
                sucursal_id, tipo, mesa_id, mesero_id, turno_id, numero,
                comensales, apertura, observaciones, flag_estado
            )
            SELECT s.id, 'SALON', m.id,
                   1 + ((g - 1) % 5),
                   1 + ((g - 1) % 4),
                   'PM-DEMO-' || LPAD(g::text, 4, '0'),
                   2 + (g % 9),
                   NOW() - (((g * 7) % 180)::text || ' minutes')::interval,
                   'Pedido demo seed ' || g,
                   '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            JOIN LATERAL (
                SELECT id, numero FROM ventas.mesa
                WHERE flag_estado = '1'
                ORDER BY id
                OFFSET (
                    (g - 1) % GREATEST((SELECT COUNT(*)::int FROM ventas.mesa WHERE flag_estado = '1'), 1)
                )
                LIMIT 1
            ) m ON TRUE
            """, SEED_VENTAS_PEDIDO);
    }

    /**
     * Detalle de pedidos demo {@code PM-DEMO-*}. Si la tabla no existe en el tenant (DDL viejo),
     * no hace nada (evita romper el seed).
     */
    private int seedPedidoMesaDet(JdbcTemplate jdbc) {
        if (!ventasTableExists(jdbc, "pedido_mesa_det")) {
            return 0;
        }
        jdbc.update("""
            DELETE FROM ventas.pedido_mesa_det
            WHERE pedido_mesa_id IN (
                SELECT id FROM ventas.pedido_mesa WHERE numero LIKE 'PM-DEMO-%'
            )
            """);
        return jdbc.update("""
            INSERT INTO ventas.pedido_mesa_det (
                pedido_mesa_id, articulo_id, cantidad, precio_unitario, subtotal, observacion, flag_estado
            )
            SELECT pm.id, a.id, v.cant,
                   COALESCE(a.precio_venta, 5.0000),
                   v.cant * COALESCE(a.precio_venta, 5.0000),
                   v.obs, '1'
            FROM ventas.pedido_mesa pm
            JOIN LATERAL (
                SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 2
            ) a ON TRUE
            JOIN LATERAL (VALUES
                (1.0000, 'Línea demo A'),
                (2.0000, 'Línea demo B')
            ) AS v(cant, obs) ON TRUE
            WHERE pm.numero LIKE 'PM-DEMO-%'
            """);
    }

    private int seedComanda(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM ventas.comanda_det");
        jdbc.update("DELETE FROM ventas.comanda");
        int c = jdbc.update("""
            INSERT INTO ventas.comanda (sucursal_id, punto_venta_id, turno_id, cliente_id, mesa, fecha_hora, total, flag_estado)
            SELECT s.id, pv.id, 1 + ((g - 1) % 3), ec.id, m.numero,
                   NOW() - (((g * 13) % 240)::text || ' minutes')::interval,
                   0,
                   '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (
                SELECT id FROM ventas.punto_venta WHERE flag_estado = '1' ORDER BY id LIMIT 1
            ) pv
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1) ec
            JOIN LATERAL (
                SELECT numero FROM ventas.mesa
                WHERE flag_estado = '1'
                ORDER BY id
                OFFSET (
                    (g - 1) % GREATEST((SELECT COUNT(*)::int FROM ventas.mesa WHERE flag_estado = '1'), 1)
                )
                LIMIT 1
            ) m ON TRUE
            """, SEED_VENTAS_COMANDA);
        int d = jdbc.update("""
            INSERT INTO ventas.comanda_det (comanda_id, articulo_id, cantidad, precio_unitario, subtotal, observacion, flag_estado)
            SELECT c.id, a.id, v.cant, COALESCE(a.precio_venta, 1.0000),
                   v.cant * COALESCE(a.precio_venta, 1.0000),
                   v.obs, '1'
            FROM ventas.comanda c
            JOIN LATERAL (
                SELECT id, precio_venta
                FROM core.articulo
                ORDER BY id
                LIMIT 2
            ) a ON TRUE
            JOIN LATERAL (VALUES
                (1.0000, 'Item demo A'),
                (2.0000, 'Item demo B')
            ) AS v(cant, obs) ON TRUE
            """);
        return c + d;
    }

    private int seedFacturaSimplificada(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM ventas.fs_factura_simpl_pagos");
        jdbc.update("DELETE FROM ventas.fs_factura_simpl_det");
        jdbc.update("DELETE FROM ventas.fs_factura_simpl");

        int cab = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl (
                sucursal_id, punto_venta_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision,
                moneda_id, subtotal, impuesto, total, ano, mes, cntbl_libro_id, flag_estado
            )
            SELECT s.id, pv.id, ec.id, dt.id, pv.serie_boleta, LPAD(g::text, 8, '0'),
                   (?::date - ((g * 5) % 120)),
                   m.id, x.tot, 0, x.tot,
                   EXTRACT(YEAR FROM (?::date - ((g * 5) % 120)))::int,
                   EXTRACT(MONTH FROM (?::date - ((g * 5) % 120)))::int,
                   1, '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1) ec
            CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            JOIN LATERAL (
                SELECT id, serie_boleta FROM ventas.punto_venta
                WHERE flag_estado = '1'
                ORDER BY id
                OFFSET (
                    (g - 1) % GREATEST((SELECT COUNT(*)::int FROM ventas.punto_venta WHERE flag_estado = '1'), 1)
                )
                LIMIT 1
            ) pv ON TRUE
            CROSS JOIN LATERAL (
                SELECT (12 + ((g * 97) % 980) + g * 0.17)::numeric AS tot
            ) x
            """, today, today, today, SEED_VENTAS_FS);

        int det = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl_det (
                fs_factura_simpl_id, articulo_id, unidad_medida_id, cantidad, precio_unitario, subtotal, flag_estado
            )
            SELECT f.id, a.id, a.unidad_medida_id, v.cant, COALESCE(a.precio_venta, 10.0000),
                   v.cant * COALESCE(a.precio_venta, 10.0000),
                   '1'
            FROM ventas.fs_factura_simpl f
            JOIN LATERAL (
                SELECT id, unidad_medida_id, precio_venta
                FROM core.articulo
                ORDER BY id
                LIMIT 2
            ) a ON TRUE
            JOIN LATERAL (VALUES (1.0000), (2.0000)) AS v(cant) ON TRUE
            """);

        int pago = jdbc.update("""
            INSERT INTO ventas.fs_factura_simpl_pagos (fs_factura_simpl_id, forma_pago_id, monto, referencia, flag_estado)
            SELECT f.id, NULL, f.total, 'EFECTIVO', '1'
            FROM ventas.fs_factura_simpl f
            """);

        return cab + det + pago;
    }

    private int seedOrdenVenta(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        // almacen.vale_mov(_det) → ventas.orden_venta(_det): sin desenganchar, DELETE falla (DATABASE_ERROR).
        jdbc.update("""
            UPDATE almacen.vale_mov_det SET orden_venta_det_id = NULL
            WHERE orden_venta_det_id IN (
                SELECT id FROM ventas.orden_venta_det WHERE orden_venta_id IN (
                    SELECT id FROM ventas.orden_venta WHERE nro_orden_venta LIKE 'OV-TEST-%'
                )
            )
            """);
        jdbc.update("""
            UPDATE almacen.vale_mov SET orden_venta_id = NULL
            WHERE orden_venta_id IN (
                SELECT id FROM ventas.orden_venta WHERE nro_orden_venta LIKE 'OV-TEST-%'
            )
            """);
        jdbc.update("""
            DELETE FROM ventas.orden_venta_det
            WHERE orden_venta_id IN (
                SELECT id FROM ventas.orden_venta WHERE nro_orden_venta LIKE 'OV-TEST-%'
            )
            """);
        jdbc.update("DELETE FROM ventas.orden_venta WHERE nro_orden_venta LIKE 'OV-TEST-%'");

        int cab = jdbc.update("""
            INSERT INTO ventas.orden_venta (
                sucursal_id, nro_orden_venta, cliente_id, vendedor_id, fecha_emision,
                moneda_id, doc_tipo_id, nro_doc, monto_total, flag_estado
            )
            SELECT s.id, 'OV-TEST-' || LPAD(g::text, 4, '0'), ec.id, v.id,
                   (?::date - ((g * 3) % 45)),
                   m.id, dt.id, NULL,
                   (18 + ((g * 61) % 2400) + g * 0.09)::numeric,
                   '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1) ec
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
            JOIN LATERAL (
                SELECT id FROM ventas.vendedor
                ORDER BY id
                OFFSET (
                    (g - 1) % GREATEST((SELECT COUNT(*)::int FROM ventas.vendedor), 1)
                )
                LIMIT 1
            ) v ON TRUE
            """, today, SEED_VENTAS_OV);

        int det = jdbc.update("""
            INSERT INTO ventas.orden_venta_det (
                orden_venta_id, articulo_id, linea_nro, cant_proyectada, cant_procesada, cant_facturada,
                valor_unitario, subtotal, almacen_id, flag_estado
            )
            SELECT ov.id, a.id, v.linea, v.cant, 0, 0,
                   COALESCE(a.precio_venta, 5.0000),
                   v.cant * COALESCE(a.precio_venta, 5.0000),
                   (SELECT id FROM almacen.almacen WHERE flag_estado='1' ORDER BY id LIMIT 1),
                   '1'
            FROM ventas.orden_venta ov
            JOIN LATERAL (
                SELECT id, precio_venta
                FROM core.articulo
                ORDER BY id
                LIMIT 2
            ) a ON TRUE
            JOIN LATERAL (VALUES
                (1, 5.0000),
                (2, 3.0000)
            ) AS v(linea, cant) ON TRUE
            WHERE ov.nro_orden_venta LIKE 'OV-TEST-%'
            """);

        return cab + det;
    }

    /** Proformas demo: números {@code PF-SEED-*}. */
    private int seedProforma(JdbcTemplate jdbc) {
        if (!ventasTableExists(jdbc, "proforma") || !ventasTableExists(jdbc, "proforma_det")) {
            return 0;
        }
        jdbc.update("""
            DELETE FROM ventas.proforma_det WHERE proforma_id IN (
                SELECT id FROM ventas.proforma WHERE numero LIKE 'PF-SEED-%'
            )
            """);
        jdbc.update("DELETE FROM ventas.proforma WHERE numero LIKE 'PF-SEED-%'");
        String today = LocalDate.now().toString();
        int cab = jdbc.update("""
            INSERT INTO ventas.proforma (
                sucursal_id, cliente_id, numero, fecha, fecha_validez, moneda_id,
                subtotal, igv, total, flag_estado
            )
            SELECT s.id, ec.id, 'PF-SEED-' || LPAD(g::text, 4, '0'),
                   (?::date - ((g % 18))),
                   (?::date - ((g % 18)) + 30),
                   m.id,
                   x.sub,
                   ROUND(x.sub * 0.18, 4),
                   ROUND(x.sub * 1.18, 4),
                   '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (
                SELECT COALESCE(
                    (SELECT id FROM core.entidad_contribuyente WHERE es_cliente = TRUE ORDER BY id LIMIT 1),
                    (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1)
                ) AS id
            ) ec
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            CROSS JOIN LATERAL (
                SELECT (35 + ((g * 89) % 3200) + g * 0.11)::numeric AS sub
            ) x
            """, today, today, SEED_VENTAS_PF);

        int det = jdbc.update("""
            INSERT INTO ventas.proforma_det (
                proforma_id, articulo_id, descripcion, cantidad, precio_unitario, descuento, subtotal
            )
            SELECT p.id, a.id, 'Línea seed', 1.0000,
                   COALESCE(a.precio_venta, 10.0000),
                   0.0000,
                   COALESCE(a.precio_venta, 10.0000)
            FROM ventas.proforma p
            JOIN LATERAL (
                SELECT id, precio_venta FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1
            ) a ON TRUE
            WHERE p.numero LIKE 'PF-SEED-%'
            """);

        return cab + det;
    }

    /** Cierres demo identificados por {@code observaciones} {@code SEED-FASE4-*}. */
    private int seedCierreCaja(JdbcTemplate jdbc) {
        if (!ventasTableExists(jdbc, "cierre_caja")) {
            return 0;
        }
        jdbc.update("DELETE FROM ventas.cierre_caja WHERE observaciones LIKE 'SEED-FASE4-%'");
        jdbc.update("DELETE FROM ventas.cierre_caja WHERE observaciones LIKE 'SEED-FASE4-BULK-%'");
        int base = jdbc.update("""
            INSERT INTO ventas.cierre_caja (
                turno_id, ventas_efectivo, ventas_tarjeta, ventas_digital, ventas_total,
                propinas_total, fondo_inicial, fondo_final, diferencia, observaciones, fecha_cierre, flag_estado
            ) VALUES
            (900001, 100.0000, 50.0000, 25.0000, 175.0000, 5.0000, 200.0000, NULL, 0.0000,
             'SEED-FASE4-ABIERTO', NULL, '1'),
            (900002, 80.0000, 40.0000, 10.0000, 130.0000, 2.0000, 150.0000, 280.0000, 0.0000,
             'SEED-FASE4-CERRADO', NOW(), '1'),
            (900003, 220.0000, 110.0000, 45.0000, 375.0000, 12.0000, 300.0000, NULL, 0.0000,
             'SEED-FASE4-T900003', NULL, '1'),
            (900004, 95.0000, 180.0000, 60.0000, 335.0000, 8.0000, 250.0000, 595.0000, 2.0000,
             'SEED-FASE4-T900004', NOW(), '1'),
            (900005, 45.0000, 90.0000, 15.0000, 150.0000, 3.0000, 120.0000, NULL, 0.0000,
             'SEED-FASE4-T900005', NULL, '1'),
            (900006, 310.0000, 95.0000, 88.0000, 493.0000, 15.0000, 400.0000, 908.0000, 15.0000,
             'SEED-FASE4-T900006', NOW(), '1'),
            (900007, 55.0000, 55.0000, 20.0000, 130.0000, 4.0000, 100.0000, NULL, 0.0000,
             'SEED-FASE4-T900007', NULL, '1'),
            (900008, 400.0000, 200.0000, 100.0000, 700.0000, 20.0000, 500.0000, 1220.0000, 20.0000,
             'SEED-FASE4-T900008', NOW(), '1'),
            (900009, 70.0000, 30.0000, 25.0000, 125.0000, 6.0000, 80.0000, NULL, 0.0000,
             'SEED-FASE4-T900009', NULL, '1'),
            (900010, 150.0000, 150.0000, 40.0000, 340.0000, 10.0000, 200.0000, 550.0000, 10.0000,
             'SEED-FASE4-T900010', NOW(), '1'),
            (900011, 88.0000, 42.0000, 30.0000, 160.0000, 5.0000, 150.0000, NULL, 0.0000,
             'SEED-FASE4-T900011', NULL, '1'),
            (900012, 175.0000, 225.0000, 50.0000, 450.0000, 11.0000, 180.0000, 641.0000, 11.0000,
             'SEED-FASE4-T900012', NOW(), '1'),
            (900013, 33.0000, 67.0000, 12.0000, 112.0000, 2.0000, 90.0000, NULL, 0.0000,
             'SEED-FASE4-T900013', NULL, '1'),
            (900014, 260.0000, 140.0000, 75.0000, 475.0000, 14.0000, 320.0000, 821.0000, 6.0000,
             'SEED-FASE4-T900014', NOW(), '1'),
            (900015, 62.0000, 38.0000, 18.0000, 118.0000, 7.0000, 110.0000, NULL, 0.0000,
             'SEED-FASE4-T900015', NULL, '1')
            """);
        int bulk = jdbc.update("""
            INSERT INTO ventas.cierre_caja (
                turno_id, ventas_efectivo, ventas_tarjeta, ventas_digital, ventas_total,
                propinas_total, fondo_inicial, fondo_final, diferencia, observaciones, fecha_cierre, flag_estado
            )
            SELECT 900015 + g::bigint,
                   (40 + ((g * 17) % 320))::numeric,
                   (25 + ((g * 11) % 210))::numeric,
                   (10 + ((g * 9) % 120))::numeric,
                   (85 + ((g * 31) % 650))::numeric,
                   (3 + (g % 12))::numeric,
                   (90 + ((g * 23) % 400))::numeric,
                   CASE WHEN g % 3 = 0 THEN (180 + ((g * 29) % 900))::numeric ELSE NULL END,
                   ((g % 7) * 1.5)::numeric,
                   'SEED-FASE4-BULK-' || LPAD(g::text, 4, '0'),
                   CASE WHEN g % 3 = 0 THEN NOW() ELSE NULL END,
                   '1'
            FROM generate_series(1, ?) AS g
            """, SEED_VENTAS_CIERRE_EXTRA);
        return base + bulk;
    }

    /**
     * Promociones demo masivas: nombre {@code SEED-PROMO-%}. Sin FKs; seguro en cualquier tenant con la tabla.
     * {@code hora_inicio}/{@code hora_fin} opcionales para escenarios de happy hour.
     */
    private int seedDescuentoPromocion(JdbcTemplate jdbc) {
        if (!ventasTableExists(jdbc, "descuento_promocion")) {
            return 0;
        }
        jdbc.update("DELETE FROM ventas.descuento_promocion WHERE nombre LIKE 'SEED-PROMO-%'");
        return jdbc.update("""
            INSERT INTO ventas.descuento_promocion (
                nombre, tipo, valor, fecha_inicio, fecha_fin, dias_aplicacion,
                hora_inicio, hora_fin, monto_minimo, flag_estado
            ) VALUES
            ('SEED-PROMO-0001', 'PCT', 5.0000, '2026-01-01', '2026-12-31', 'LUN-VIE', NULL, NULL, 20.0000, '1'),
            ('SEED-PROMO-0002', 'PCT', 8.0000, '2026-01-01', '2026-12-31', 'SAB-DOM', NULL, NULL, 50.0000, '1'),
            ('SEED-PROMO-0003', 'MONTO_FIJO', 3.5000, '2026-02-01', '2026-11-30', NULL, NULL, NULL, 15.0000, '1'),
            ('SEED-PROMO-0004', 'PCT', 12.0000, '2026-03-01', '2026-12-31', 'LUN,MIE,VIE', TIME '15:00', TIME '18:00', 40.0000, '1'),
            ('SEED-PROMO-0005', 'MONTO_FIJO', 10.0000, '2026-01-15', NULL, NULL, NULL, NULL, 100.0000, '1'),
            ('SEED-PROMO-0006', 'PCT', 15.0000, '2026-01-01', '2026-06-30', NULL, NULL, NULL, NULL, '0'),
            ('SEED-PROMO-0007', 'PCT', 7.0000, '2026-05-01', '2026-12-31', 'MAR,JUE', NULL, NULL, 35.0000, '1'),
            ('SEED-PROMO-0008', 'MONTO_FIJO', 6.0000, '2026-01-01', '2026-12-31', 'LUN-DOM', NULL, NULL, 25.0000, '1'),
            ('SEED-PROMO-0009', 'PCT', 20.0000, '2026-06-01', '2026-08-31', NULL, TIME '12:00', TIME '14:00', 80.0000, '1'),
            ('SEED-PROMO-0010', 'PCT', 4.0000, '2026-01-01', '2027-01-01', 'VIE,SAB', NULL, NULL, 60.0000, '1'),
            ('SEED-PROMO-0011', 'MONTO_FIJO', 12.5000, '2026-02-15', '2026-12-15', NULL, NULL, NULL, 120.0000, '1'),
            ('SEED-PROMO-0012', 'PCT', 10.0000, '2026-01-01', '2026-12-31', 'LUN-VIE', TIME '17:00', TIME '20:00', 30.0000, '1'),
            ('SEED-PROMO-0013', 'PCT', 25.0000, '2026-04-01', '2026-05-31', NULL, NULL, NULL, 200.0000, '1'),
            ('SEED-PROMO-0014', 'MONTO_FIJO', 4.0000, '2026-01-01', '2026-12-31', NULL, NULL, NULL, 10.0000, '1'),
            ('SEED-PROMO-0015', 'PCT', 6.0000, '2026-07-01', '2026-09-30', 'SAB,DOM', NULL, NULL, 45.0000, '1'),
            ('SEED-PROMO-0016', 'PCT', 18.0000, '2026-01-01', '2026-03-31', NULL, NULL, NULL, NULL, '0'),
            ('SEED-PROMO-0017', 'MONTO_FIJO', 8.0000, '2026-03-01', '2026-12-31', 'LUN,MAR,MIE', NULL, NULL, 55.0000, '1'),
            ('SEED-PROMO-0018', 'PCT', 9.0000, '2026-01-01', '2028-01-01', NULL, TIME '22:00', TIME '23:59', 70.0000, '1'),
            ('SEED-PROMO-0019', 'MONTO_FIJO', 15.0000, '2026-05-08', NULL, 'LUN-VIE', NULL, NULL, 150.0000, '1'),
            ('SEED-PROMO-0020', 'PCT', 11.0000, '2026-01-01', '2026-12-31', NULL, NULL, NULL, 90.0000, '1'),
            ('SEED-PROMO-0021', 'PCT', 3.0000, '2026-02-01', '2026-10-31', 'JUE,VIE,SAB', NULL, NULL, 18.0000, '1'),
            ('SEED-PROMO-0022', 'MONTO_FIJO', 20.0000, '2026-01-01', '2026-12-31', NULL, NULL, NULL, 250.0000, '1'),
            ('SEED-PROMO-0023', 'PCT', 14.0000, '2026-04-15', '2026-12-31', 'LUN-VIE', TIME '07:00', TIME '10:00', 40.0000, '1'),
            ('SEED-PROMO-0024', 'PCT', 16.0000, '2026-08-01', '2026-12-31', NULL, NULL, NULL, 95.0000, '1'),
            ('SEED-PROMO-0025', 'MONTO_FIJO', 7.5000, '2026-01-01', '2026-12-31', 'DOM', NULL, NULL, 22.0000, '1')
            """);
    }

    /**
     * Carga cuentas por cobrar alineadas al API {@code /api/ventas/cuentas-cobrar}: varios {@code estado},
     * movimientos {@code CARGO}/{@code ABONO}/{@code AJUSTE} (no usar valores fuera del enum JPA).
     * Serie fija {@code CC-DEMO} para identificar filas de este seed.
     */
    private int seedCuentasCobrar(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        Long conceptoFinId = resolveFirstConceptoFinancieroId(jdbc);

        // finanzas.liquidacion_det.cntas_cobrar_id → ventas.cntas_cobrar
        jdbc.update("""
            UPDATE finanzas.liquidacion_det SET cntas_cobrar_id = NULL
            WHERE cntas_cobrar_id IN (
                SELECT id FROM ventas.cntas_cobrar WHERE serie = 'CC-DEMO'
            )
            """);
        jdbc.update("""
            DELETE FROM ventas.cntas_cobrar_det
            WHERE cntas_cobrar_id IN (
                SELECT id FROM ventas.cntas_cobrar WHERE serie = 'CC-DEMO'
            )
            """);
        jdbc.update("DELETE FROM ventas.cntas_cobrar WHERE serie = 'CC-DEMO'");

        int cab = jdbc.update("""
            INSERT INTO ventas.cntas_cobrar (
                sucursal_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision, fecha_vencimiento,
                moneda_id, total, saldo, ano, mes, cntbl_libro_id, flag_estado
            )
            SELECT s.id, cli.id, dt.id, 'CC-DEMO', LPAD(g::text, 5, '0'),
                   fe, fe + (10 + (g % 50)),
                   m.id,
                   x.tot,
                   y.saldo,
                   EXTRACT(YEAR FROM fe)::int,
                   EXTRACT(MONTH FROM fe)::int,
                   1,
                   CASE (g % 5)
                       WHEN 1 THEN '0'
                       WHEN 0 THEN '5'
                       WHEN 2 THEN '4'
                       WHEN 3 THEN '4'
                       ELSE '1'
                   END
            FROM generate_series(1, ?) AS g
            CROSS JOIN LATERAL (SELECT (?::date + ((g % 24) - 12))::date AS fe) fe
            CROSS JOIN (SELECT id FROM auth.sucursal ORDER BY id LIMIT 1) s
            CROSS JOIN (
                SELECT COALESCE(
                    (SELECT id FROM core.entidad_contribuyente WHERE es_cliente = TRUE ORDER BY id LIMIT 1),
                    (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1)
                ) AS id
            ) cli
            CROSS JOIN (SELECT id FROM core.doc_tipo ORDER BY id LIMIT 1) dt
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
            CROSS JOIN LATERAL (
                SELECT (55 + ((g * 91) % 8900))::numeric AS tot,
                       CASE (g % 5)
                           WHEN 0 THEN 'COBRADA'
                           WHEN 1 THEN 'ANULADA'
                           WHEN 2 THEN 'PARCIAL'
                           WHEN 3 THEN 'PARCIAL'
                           ELSE 'PENDIENTE'
                       END AS estado
            ) x
            CROSS JOIN LATERAL (
                SELECT CASE
                    WHEN x.estado IN ('COBRADA', 'ANULADA') THEN 0::numeric
                    WHEN x.estado = 'PARCIAL' THEN ROUND(x.tot * 0.37, 4)
                    ELSE x.tot
                END AS saldo
            ) y
            """, SEED_VENTAS_CC, today);

        if (conceptoFinId == null) {
            return cab;
        }

        int detCargo = jdbc.update("""
            INSERT INTO ventas.cntas_cobrar_det (
                cntas_cobrar_id, nro_item, concepto_financiero_id, credito_fiscal_id, fecha_mov, tipo_mov, monto, referencia, flag_estado
            )
            SELECT c.id, 1, ?, 1, c.fecha_emision, 'CARGO', c.total, 'Seed: cargo documento', '1'
            FROM ventas.cntas_cobrar c
            WHERE c.serie = 'CC-DEMO'
            """, conceptoFinId);

        int detAbono = jdbc.update("""
            INSERT INTO ventas.cntas_cobrar_det (
                cntas_cobrar_id, nro_item, concepto_financiero_id, credito_fiscal_id, fecha_mov, tipo_mov, monto, referencia, flag_estado
            )
            SELECT c.id, 1, ?, 1, c.fecha_emision + 1, 'ABONO', (c.total - c.saldo), 'Seed: cobro / aplicación', '1'
            FROM ventas.cntas_cobrar c
            WHERE c.serie = 'CC-DEMO'
              AND c.flag_estado IN ('4', '5')
              AND (c.total - c.saldo) <> 0
            """, conceptoFinId);

        int detAjusteAnul = jdbc.update("""
            INSERT INTO ventas.cntas_cobrar_det (
                cntas_cobrar_id, nro_item, concepto_financiero_id, credito_fiscal_id, fecha_mov, tipo_mov, monto, referencia, flag_estado
            )
            SELECT c.id, 1, ?, 1, c.fecha_emision + 2, 'AJUSTE', -c.total, 'Seed: reversión por anulación', '1'
            FROM ventas.cntas_cobrar c
            WHERE c.serie = 'CC-DEMO'
              AND c.flag_estado = '0'
            """, conceptoFinId);

        return cab + detCargo + detAbono + detAjusteAnul;
    }

    /**
     * {@code cntas_cobrar_det.concepto_financiero_id} es NOT NULL (DDL). Sin catálogo en {@code finanzas.concepto_financiero},
     * el seed solo inserta cabeceras CC-DEMO.
     */
    private Long resolveFirstConceptoFinancieroId(JdbcTemplate jdbc) {
        try {
            return jdbc.queryForObject(
                    """
                    SELECT id FROM finanzas.concepto_financiero
                    WHERE flag_estado = '1'
                    ORDER BY id
                    LIMIT 1
                    """,
                    Long.class);
        } catch (Exception e) {
            return null;
        }
    }
}

