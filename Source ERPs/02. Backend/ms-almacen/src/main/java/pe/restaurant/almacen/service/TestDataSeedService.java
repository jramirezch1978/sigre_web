package pe.restaurant.almacen.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.common.security.TenantContext;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.function.IntSupplier;

/**
 * Seeds demo data for local/testing environments.
 *
 * <p>IMPORTANT: This service is designed to be invoked only when explicitly enabled via
 * {@code app.testdata.enabled=true}. It mutates the tenant database (DELETE/INSERT).</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TestDataSeedService {

    /** Volumen demo masivo (números de vale LM + 10 dígitos, longitud 12). */
    private static final int SEED_VALE_COUNT = 60;
    private static final int SEED_GUIA_COUNT = 35;
    private static final int SEED_OT_COUNT = 28;
    private static final int SEED_INV_CONTEO_COUNT = 24;
    private static final int SEED_SOL_SALIDA_COUNT = 32;
    private static final int SEED_UBIC_COUNT = 28;
    private static final int SEED_LOTE_COUNT = 40;
    private static final int SEED_SALDO_MENSUAL_ROWS = 45;

    private final DataSource dataSource; // tenant routing datasource

    /**
     * Siembra demo SIN transacción global: cada paso se ejecuta de forma
     * independiente (auto-commit) y tolerante a fallos. Así, si una tabla legacy
     * tiene <em>schema-drift</em> en un tenant (p.ej. `guia.estado` ausente en
     * Cantabria), ese paso se omite (valor -1 en el reporte) sin tumbar los
     * demás. El orden respeta las dependencias FK (vale_mov antes que guia/saldo).
     */
    public Map<String, Integer> seedAlmacenDemoData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("_sucursalId", (int) resolveSucursalId());

        // ── Core minimal (if missing) ───────────────────────────────────────
        safe(out, "core.articulo", () -> seedCoreArticulo(jdbc));
        safe(out, "core.entidad_contribuyente", () -> seedEntidadContribuyente(jdbc));

        // ── Almacén transaccional ──────────────────────────────────────────
        safe(out, "almacen.ubicacion_almacen", () -> seedUbicacionAlmacen(jdbc));
        safe(out, "almacen.lote_pallet", () -> seedLotePallet(jdbc));
        safe(out, "almacen.almacen_user", () -> seedAlmacenUser(jdbc));
        safe(out, "almacen.almacen_tipo_mov", () -> seedAlmacenTipoMov(jdbc));
        safe(out, "almacen.vale_mov + det", () -> seedValeMov(jdbc));
        safe(out, "almacen.guia + det", () -> seedGuia(jdbc));
        safe(out, "almacen.orden_traslado + det", () -> seedOrdenTraslado(jdbc));
        safe(out, "almacen.inventario_conteo", () -> seedInventarioConteo(jdbc));
        safe(out, "almacen.sol_salida + det", () -> seedSolicitudSalida(jdbc));
        safe(out, "almacen.articulo_bonificacion", () -> seedArticuloBonificacion(jdbc));
        safe(out, "almacen.articulo_almacen", () -> seedArticuloAlmacen(jdbc));
        safe(out, "almacen.articulo_almacen_posicion", () -> seedArticuloAlmacenPosicion(jdbc));
        safe(out, "almacen.articulo_saldo_mensual", () -> seedArticuloSaldoMensual(jdbc));

        return out;
    }

    /**
     * Ejecuta un paso de seed aislado: registra el nº de filas, o -1 si falla
     * (y loguea el motivo) para no abortar el resto de la siembra.
     */
    private void safe(Map<String, Integer> out, String key, IntSupplier step) {
        try {
            out.put(key, step.getAsInt());
        } catch (Exception ex) {
            out.put(key, -1);
            log.warn("Seed '{}' omitido por error: {}", key, ex.getMessage());
        }
    }

    /**
     * Sucursal a usar en cabeceras (vale_mov, guia). Se toma del contexto del
     * tenant de la petición; {@code auth.sucursal} es un schema central que no
     * existe en todos los tenants (p.ej. Cantabria), y la columna es solo un
     * Long sin FK, así que un valor del contexto (o 1 por defecto) es suficiente.
     */
    private long resolveSucursalId() {
        Long s = TenantContext.getSucursalId();
        return (s != null && s > 0) ? s : 1L;
    }

    private int seedCoreArticulo(JdbcTemplate jdbc) {
        // core.articulo usually has no seed SQL in this project.
        // Use PK-based upsert because some environments may not enforce UNIQUE(codigo).
        return jdbc.update("""
            INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
            SELECT v.id, v.codigo, v.nombre, v.tipo, um.id, ac.id, v.precio, '1'
            FROM (VALUES
                (1, 'ART-001', 'Arroz Extra Granel',      'BIEN', 'KG', 'MP',  3.50),
                (2, 'ART-002', 'Aceite Vegetal lt',       'BIEN', 'LT', 'MP',  8.90),
                (3, 'ART-003', 'Sal iodada kg',           'BIEN', 'KG', 'MP',  2.10),
                (4, 'ART-004', 'Fideos spaghetti',        'BIEN', 'KG', 'MP',  4.20),
                (5, 'ART-005', 'Pollo Entero kg',         'BIEN', 'KG', 'MP', 12.50),
                (6, 'ART-006', 'Tomate fresco kg',        'BIEN', 'KG', 'MP',  5.80),
                (7, 'ART-007', 'Cebolla roja kg',         'BIEN', 'KG', 'MP',  3.40),
                (8, 'ART-008', 'Papa amarilla kg',        'BIEN', 'KG', 'MP',  2.80),
                (9, 'ART-009', 'Limón kg',                'BIEN', 'KG', 'MP',  6.00),
                (10, 'ART-010', 'Azúcar rubia kg',        'BIEN', 'KG', 'MP',  4.50),
                (11, 'ART-011', 'Leche evaporada lt',     'BIEN', 'LT', 'MP',  7.20),
                (12, 'ART-012', 'Mantequilla kg',         'BIEN', 'KG', 'MP', 22.00)
            ) AS v(id, codigo, nombre, tipo, um_cod, cat_cod, precio)
            JOIN core.unidad_medida um ON um.codigo = v.um_cod
            JOIN core.articulo_categ ac ON ac.cat_art = v.cat_cod
            ON CONFLICT (id) DO UPDATE SET
                codigo = EXCLUDED.codigo,
                nombre = EXCLUDED.nombre,
                tipo = EXCLUDED.tipo,
                unidad_medida_id = EXCLUDED.unidad_medida_id,
                articulo_categ_id = EXCLUDED.articulo_categ_id,
                precio_venta = EXCLUDED.precio_venta,
                flag_estado = EXCLUDED.flag_estado
            """);
    }

    private int seedEntidadContribuyente(JdbcTemplate jdbc) {
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

    private int seedUbicacionAlmacen(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.ubicacion_almacen");
        return jdbc.update("""
            INSERT INTO almacen.ubicacion_almacen (almacen_id, codigo, nombre, pasillo, estante, nivel)
            SELECT a.id,
                   'PICK-' || LPAD(g::text, 2, '0'),
                   'Picking demo ' || g,
                   CHR(64 + ((g - 1) / 8) + 1),
                   LPAD((((g - 1) % 8) + 1)::text, 2, '0'),
                   LPAD((g % 5 + 1)::text, 2, '0')
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
            """, SEED_UBIC_COUNT);
    }

    private int seedLotePallet(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.lote_pallet");
        return jdbc.update("""
            INSERT INTO almacen.lote_pallet (almacen_id, articulo_id, nro_lote, fecha_produccion, fecha_vencimiento, observacion, flag_estado)
            SELECT a.id, art.id,
                   'L-SEED-' || LPAD(g::text, 5, '0'),
                   CURRENT_DATE - (g % 20),
                   CURRENT_DATE + (60 + (g % 120)),
                   'Lote masivo seed',
                   '1'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
            JOIN core.articulo art ON art.codigo = (
                ARRAY['ART-001','ART-002','ART-003','ART-004','ART-005','ART-006','ART-007','ART-008']
            )[1 + ((g - 1) % 8)]
            """, SEED_LOTE_COUNT);
    }

    private int seedAlmacenUser(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.almacen_user");
        return jdbc.update("""
            INSERT INTO almacen.almacen_user (almacen_id, usuario_id, flag_estado)
            SELECT a.id, 1, '1' FROM almacen.almacen a WHERE a.flag_estado = '1'
            """);
    }

    private int seedAlmacenTipoMov(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.almacen_tipo_mov");
        return jdbc.update("""
            INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado)
            SELECT a.id, t.id, '1'
            FROM almacen.almacen a
            CROSS JOIN almacen.articulo_mov_tipo t
            WHERE a.flag_estado = '1' AND t.flag_estado = '1'
            ON CONFLICT (almacen_id, articulo_mov_tipo_id) DO NOTHING
            """);
    }

    private int seedValeMov(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        long sucursalId = resolveSucursalId();
        clearOperationalRefsBeforeValeReseed(jdbc);
        jdbc.update("DELETE FROM almacen.articulo_saldo_mensual");
        jdbc.update("DELETE FROM almacen.vale_mov_det");
        jdbc.update("DELETE FROM almacen.vale_mov");

        // nro_vale VARCHAR(12): prefijo LM + 10 dígitos (ej. LM0000000042).
        // sucursal_id desde el contexto del tenant (auth.sucursal no existe en
        // todos los tenants, p.ej. Cantabria); es solo un Long sin FK.
        int cCab = jdbc.update("""
            INSERT INTO almacen.vale_mov (sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale, proveedor_id, flag_estado)
            SELECT ?, a.id, t.id, ?::date, 'LM' || LPAD(gs.g::text, 10, '0'), e.id, '1'
            FROM generate_series(1, ?) AS gs(g)
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado='1' ORDER BY id LIMIT 1) a
            CROSS JOIN (SELECT id FROM almacen.articulo_mov_tipo WHERE flag_estado='1' ORDER BY id LIMIT 1) t
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente ORDER BY id LIMIT 1) e
            """, sucursalId, today, SEED_VALE_COUNT);

        int cDet = jdbc.update("""
            INSERT INTO almacen.vale_mov_det (vale_mov_id, articulo_id, cant_procesada, costo_unitario, moneda_id, flag_estado)
            SELECT vm.id, art.id,
                   (5 + (vm.id % 15))::numeric,
                   COALESCE(art.precio_venta, 3.5000) * 0.85,
                   m.id,
                   '1'
            FROM almacen.vale_mov vm
            JOIN core.articulo art ON art.codigo = (
                ARRAY['ART-001','ART-005','ART-002','ART-006','ART-003']
            )[1 + ((vm.id - 1) % 5)]
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            WHERE vm.nro_vale ~ '^LM[0-9]{10}$'
            """);

        int cDet2 = jdbc.update("""
            INSERT INTO almacen.vale_mov_det (vale_mov_id, articulo_id, cant_procesada, costo_unitario, moneda_id, flag_estado)
            SELECT vm.id, art.id,
                   (2 + (vm.id % 7))::numeric,
                   COALESCE(art.precio_venta, 12.5000) * 0.90,
                   m.id,
                   '1'
            FROM almacen.vale_mov vm
            JOIN core.articulo art ON art.codigo = 'ART-005'
            CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado='1' ORDER BY id LIMIT 1) m
            WHERE vm.nro_vale ~ '^LM[0-9]{10}$'
              AND vm.id % 3 = 0
            """);

        return cCab + cDet + cDet2;
    }

    /** Evita FK al borrar vales en re-seed (guías, inventario, saldos). */
    private void clearOperationalRefsBeforeValeReseed(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.guia_det");
        jdbc.update("DELETE FROM almacen.guia");
        jdbc.update("DELETE FROM almacen.inventario_conteo");
        jdbc.update("UPDATE almacen.vale_mov SET orden_traslado_id = NULL WHERE orden_traslado_id IS NOT NULL");
    }

    private int seedGuia(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        long sucursalId = resolveSucursalId();
        jdbc.update("DELETE FROM almacen.guia_det");
        jdbc.update("DELETE FROM almacen.guia");

        int c1 = jdbc.update("""
            INSERT INTO almacen.guia (sucursal_id, serie, numero, fecha_emision, fecha_traslado,
                                      motivo_traslado_id, destinatario_id, transportista_id, vale_mov_id, estado, flag_estado)
            SELECT ?, 'T001', LPAD(g::text, 8, '0'), ?::date, ?::date,
                   mt.id, dest.id, trans.id, vm.id, 'EMITIDA', '1'
            FROM generate_series(1, LEAST(?, (SELECT COUNT(*)::int FROM almacen.vale_mov vm WHERE vm.nro_vale ~ '^LM[0-9]{10}$'))) AS g
            CROSS JOIN (SELECT id FROM almacen.motivo_traslado WHERE flag_estado = '1' ORDER BY id LIMIT 1) mt
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente WHERE nro_documento = '20987654321' LIMIT 1) dest
            CROSS JOIN (SELECT id FROM core.entidad_contribuyente WHERE nro_documento = '20111222333' LIMIT 1) trans
            JOIN almacen.vale_mov vm ON vm.nro_vale = ('LM' || LPAD(g::text, 10, '0'))
            """, sucursalId, today, today, SEED_GUIA_COUNT);

        int c2 = jdbc.update("""
            INSERT INTO almacen.guia_det (guia_id, vale_mov_id, articulo_id, unidad_medida_id, cantidad, flag_estado)
            SELECT g.id, g.vale_mov_id, art.id, art.unidad_medida_id,
                   (5 + (g.id % 20))::numeric, '1'
            FROM almacen.guia g
            JOIN core.articulo art ON art.codigo = (
                ARRAY['ART-001','ART-002','ART-005']
            )[1 + (g.id % 3)]
            WHERE g.serie = 'T001'
            """);

        return c1 + c2;
    }

    private int seedOrdenTraslado(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.orden_traslado_det");
        jdbc.update("DELETE FROM almacen.orden_traslado");

        int c1 = jdbc.update("""
            INSERT INTO almacen.orden_traslado (almacen_origen_id, almacen_destino_id, nro_orden_traslado, fecha, estado, observacion)
            SELECT w1.id, w2.id, 'OT' || LPAD(g::text, 10, '0'), ?::date,
                   CASE (g % 4)
                       WHEN 0 THEN 'BORRADOR'
                       WHEN 1 THEN 'PENDIENTE_APROBACION'
                       WHEN 2 THEN 'APROBADO'
                       ELSE 'CERRADO'
                   END,
                   'OT masiva seed'
            FROM generate_series(1, ?) AS g
            CROSS JOIN LATERAL (
                SELECT COUNT(*)::int AS cnt FROM almacen.almacen WHERE flag_estado = '1'
            ) c
            JOIN LATERAL (
                SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
                FROM almacen.almacen WHERE flag_estado = '1'
            ) w1 ON c.cnt >= 2 AND w1.rn = 1 + (((g - 1) % c.cnt))
            JOIN LATERAL (
                SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
                FROM almacen.almacen WHERE flag_estado = '1'
            ) w2 ON w2.rn = 1 + (g % c.cnt) AND w2.id <> w1.id
            """, today, SEED_OT_COUNT);

        int c2 = jdbc.update("""
            INSERT INTO almacen.orden_traslado_det (orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida)
            SELECT ot.id, art.id,
                   (10 + (ot.id % 25))::numeric,
                   (CASE WHEN ot.flag_estado = '0' THEN (5 + (ot.id % 10)) ELSE 0 END)::numeric,
                   (CASE WHEN ot.flag_estado = '0' THEN (5 + (ot.id % 10)) ELSE 0 END)::numeric
            FROM almacen.orden_traslado ot
            JOIN core.articulo art ON art.codigo = (
                ARRAY['ART-001','ART-005','ART-002','ART-006']
            )[1 + ((ot.id - 1) % 4)]
            WHERE ot.nro_orden_traslado LIKE 'OT%' AND LENGTH(ot.nro_orden_traslado) = 12
            """);

        int c3 = jdbc.update("""
            INSERT INTO almacen.orden_traslado_det (orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida)
            SELECT ot.id, art.id, 3.0000, 0, 0
            FROM almacen.orden_traslado ot
            JOIN core.articulo art ON art.codigo = 'ART-003'
            WHERE ot.nro_orden_traslado LIKE 'OT%' AND LENGTH(ot.nro_orden_traslado) = 12
              AND ot.id % 2 = 0
            """);

        return c1 + c2 + c3;
    }

    private int seedInventarioConteo(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.inventario_conteo");
        return jdbc.update("""
            INSERT INTO almacen.inventario_conteo (
                almacen_id, articulo_id, fecha_conteo, nro_conteo, saldo_sistema,
                cantidad_conteo_1, auditor_conteo_1, nro_ficha_conteo_1, costo_unitario,
                diferencia, vale_mov_ajuste_id, ubicacion_id, estado
            )
            SELECT a.id, art.id, ?::date,
                   1 + ((g - 1) % 3),
                   (80.0000 + (g % 40)),
                   (77.0000 + (g % 38)),
                   'AUDITOR ' || g,
                   'FICHA-' || LPAD(g::text, 5, '0'),
                   COALESCE(art.precio_venta, 3.5000),
                   ((77.0000 + (g % 38)) - (80.0000 + (g % 40))),
                   vm.id,
                   ub.id,
                   CASE (g % 4)
                       WHEN 0 THEN 'EN_PROCESO'
                       WHEN 1 THEN 'EN_PROCESO'
                       WHEN 2 THEN 'FINALIZADO'
                       ELSE 'CON_DIFERENCIA'
                   END
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
            JOIN core.articulo art ON art.codigo = (
                ARRAY[
                    'ART-001','ART-002','ART-003','ART-004','ART-005','ART-006',
                    'ART-007','ART-008','ART-009','ART-010','ART-011','ART-012'
                ]
            )[1 + ((g - 1) % 12)]
            JOIN almacen.vale_mov vm ON vm.nro_vale = (
                'LM' || LPAD((((g - 1) % ?) + 1)::text, 10, '0')
            )
            JOIN almacen.ubicacion_almacen ub ON ub.codigo = (
                'PICK-' || LPAD((((g - 1) % ?) + 1)::text, 2, '0')
            )
            """, today, SEED_INV_CONTEO_COUNT, SEED_VALE_COUNT, SEED_UBIC_COUNT);
    }

    private int seedSolicitudSalida(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.sol_salida_det");
        jdbc.update("DELETE FROM almacen.sol_salida");

        int c1 = jdbc.update("""
            INSERT INTO almacen.sol_salida (almacen_id, nro_sol_salida, fecha, estado, observacion)
            SELECT a.id, 'SS' || LPAD(g::text, 10, '0'), ?::date,
                   CASE (g % 5)
                       WHEN 0 THEN 'BORRADOR'
                       WHEN 1 THEN 'BORRADOR'
                       WHEN 2 THEN 'APROBADO'
                       WHEN 3 THEN 'DESPACHADO_PARCIAL'
                       ELSE 'DESPACHADO_TOTAL'
                   END,
                   'Solicitud masiva seed'
            FROM generate_series(1, ?) AS g
            CROSS JOIN (SELECT id FROM almacen.almacen WHERE flag_estado = '1' ORDER BY id LIMIT 1) a
            """, today, SEED_SOL_SALIDA_COUNT);

        int c2 = jdbc.update("""
            INSERT INTO almacen.sol_salida_det (sol_salida_id, articulo_id, cantidad, cantidad_despachada)
            SELECT ss.id, art.id,
                   (4 + (ss.id % 12))::numeric,
                   CASE WHEN ss.flag_estado = '1'
                        THEN (2 + (ss.id % 5))::numeric ELSE 0 END
            FROM almacen.sol_salida ss
            JOIN core.articulo art ON art.codigo = (
                ARRAY['ART-001','ART-005','ART-002','ART-006','ART-003','ART-007']
            )[1 + ((ss.id - 1) % 6)]
            WHERE ss.nro_sol_salida LIKE 'SS%' AND LENGTH(ss.nro_sol_salida) = 12
            """);

        int c3 = jdbc.update("""
            INSERT INTO almacen.sol_salida_det (sol_salida_id, articulo_id, cantidad, cantidad_despachada)
            SELECT ss.id, art.id, 2.0000, 0
            FROM almacen.sol_salida ss
            JOIN core.articulo art ON art.codigo = 'ART-004'
            WHERE ss.nro_sol_salida LIKE 'SS%' AND LENGTH(ss.nro_sol_salida) = 12
              AND ss.id % 2 = 0
            """);

        return c1 + c2 + c3;
    }

    private int seedArticuloBonificacion(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.articulo_bonificacion");
        return jdbc.update("""
            INSERT INTO almacen.articulo_bonificacion (articulo_id, cantidad_minima, cantidad_bonificacion, fecha_inicio, fecha_fin, flag_estado)
            SELECT art.id,
                   (6 + (g % 10))::numeric,
                   (0.5 + ((g % 5) * 0.25))::numeric,
                   CURRENT_DATE - (g % 14),
                   CURRENT_DATE + (30 + (g % 60)),
                   '1'
            FROM generate_series(1, 18) AS g
            JOIN core.articulo art ON art.codigo = (
                ARRAY[
                    'ART-001','ART-002','ART-003','ART-004','ART-005','ART-006',
                    'ART-007','ART-008','ART-009','ART-010','ART-011','ART-012'
                ]
            )[1 + ((g - 1) % 12)]
            """);
    }

    private int seedArticuloAlmacen(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.articulo_almacen");
        return jdbc.update("""
            INSERT INTO almacen.articulo_almacen (almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
            SELECT a.id, art.id,
                   (40 + ((a.id + art.id) % 220))::numeric,
                   ((a.id + art.id * 3) % 18)::numeric,
                   ROUND(COALESCE(art.precio_venta, 3.5000) * 0.82, 6)
            FROM almacen.almacen a
            JOIN core.articulo art ON art.flag_estado = '1'
                AND art.codigo ~ '^ART-[0-9]{3}$'
            WHERE a.flag_estado = '1'
            """);
    }

    private int seedArticuloAlmacenPosicion(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM almacen.articulo_almacen_posicion");
        return jdbc.update("""
            INSERT INTO almacen.articulo_almacen_posicion (ubicacion_almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
            SELECT ub.id, art.id,
                   (8 + (abs(hashtext(ub.id::text || '-' || art.id::text)) % 85))::numeric,
                   (abs(hashtext(art.codigo)) % 6)::numeric,
                   ROUND(COALESCE(art.precio_venta, 3.5000) * 0.88, 6)
            FROM almacen.ubicacion_almacen ub
            JOIN LATERAL (
                SELECT id, codigo, precio_venta
                FROM core.articulo
                WHERE flag_estado = '1' AND codigo ~ '^ART-[0-9]{3}$'
                ORDER BY id
                LIMIT 1 OFFSET (
                    abs(hashtext(ub.id::text))
                    % GREATEST((SELECT COUNT(*)::int FROM core.articulo WHERE flag_estado = '1' AND codigo ~ '^ART-[0-9]{3}$'), 1)
                )
            ) art ON TRUE
            WHERE ub.codigo LIKE 'PICK-%'
            """);
    }

    private int seedArticuloSaldoMensual(JdbcTemplate jdbc) {
        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.articulo_saldo_mensual");
        return jdbc.update("""
            INSERT INTO almacen.articulo_saldo_mensual (
                almacen_id, articulo_id, vale_mov_det_id, fecha, tipo,
                cantidad, costo_unitario, costo_total, saldo_cantidad, saldo_costo_unitario, saldo_costo_total
            )
            SELECT vm.almacen_id, vmd.articulo_id, vmd.id, ?::date, 'INGRESO',
                   vmd.cant_procesada,
                   COALESCE(vmd.costo_unitario, 0),
                   ROUND(COALESCE(vmd.cant_procesada, 0) * COALESCE(vmd.costo_unitario, 0), 4),
                   vmd.cant_procesada,
                   COALESCE(vmd.costo_unitario, 0),
                   ROUND(COALESCE(vmd.cant_procesada, 0) * COALESCE(vmd.costo_unitario, 0), 4)
            FROM almacen.vale_mov_det vmd
            JOIN almacen.vale_mov vm ON vm.id = vmd.vale_mov_id
            WHERE vmd.id IN (
                SELECT vmd2.id
                FROM almacen.vale_mov_det vmd2
                JOIN almacen.vale_mov vm2 ON vm2.id = vmd2.vale_mov_id
                WHERE vm2.nro_vale ~ '^LM[0-9]{10}$'
                ORDER BY vmd2.id
                LIMIT ?
            )
            """, today, SEED_SALDO_MENSUAL_ROWS);
    }
}

