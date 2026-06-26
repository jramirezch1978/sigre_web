package pe.restaurant.activos.testdata;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Inserciones masivas idempotentes (~{@link #BULK_ROWS} filas por tabla activos) para tests IT.
 * Los códigos estables {@code FACTORY-AF-M*} del dataset mínimo no se modifican.
 */
final class ActivosTestDataFactoryBulk {

    static final int BULK_ROWS = 100;
    static final String PREFIX_MAESTRO = "FACTORY-AF-BULK-";
    static final String PREFIX_CLASE = "FACTORY-AF-CL-B";
    static final String PREFIX_SUB = "FACTORY-AF-SUB-B";
    static final String PREFIX_UBI = "FACTORY-AF-UBI-B";
    static final String PREFIX_POLIZA = "FACTORY-AF-POL-B";
    static final String PREFIX_TIPO_OP = "FBT";

    private static final long USER_ID = 1L;

    private ActivosTestDataFactoryBulk() {
    }

    static Map<String, Integer> ensureBulkDataset(JdbcTemplate jdbc, BulkContext ctx) {
        Map<String, Integer> out = new LinkedHashMap<>();
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_maestro")) {
            return out;
        }
        out.put("bulk.activos.af_clase", ensureBulkClases(jdbc));
        out.put("bulk.activos.af_sub_clase", ensureBulkSubClases(jdbc, ctx.subClaseLinealId()));
        out.put("bulk.activos.af_ubicacion", ensureBulkUbicaciones(jdbc, ctx.sucursalId()));
        out.put("bulk.activos.af_maestro", ensureBulkMaestros(jdbc, ctx));
        out.put("bulk.activos.af_maestro_cc_distrib", ensureBulkMaestroCcDistrib(jdbc));
        out.put("bulk.activos.af_tipo_operacion", ensureBulkTiposOperacion(jdbc));
        out.put("bulk.activos.af_calculo_cntbl", ensureBulkCalculos(jdbc, ctx.tipoOpDepId()));
        out.put("bulk.activos.af_adaptacion", ensureBulkAdaptaciones(jdbc));
        out.put("bulk.activos.af_adaptacion_det", ensureBulkAdaptacionDet(jdbc));
        out.put("bulk.activos.af_adaptacion_dep", ensureBulkAdaptacionDep(jdbc));
        out.put("bulk.activos.af_accesorios", ensureBulkAccesorios(jdbc));
        out.put("bulk.activos.af_software", ensureBulkSoftware(jdbc));
        out.put("bulk.activos.af_revaluacion", ensureBulkRevaluacion(jdbc));
        out.put("bulk.activos.af_operaciones", ensureBulkOperaciones(jdbc));
        out.put("bulk.activos.af_aseguradora", ensureBulkAseguradoras(jdbc));
        out.put("bulk.activos.af_poliza_seguro", ensureBulkPolizas(jdbc));
        out.put("bulk.activos.af_poliza_activo", ensureBulkPolizaActivo(jdbc));
        out.put("bulk.activos.af_prima_devengo", ensureBulkPrimaDevengo(jdbc));
        out.put("bulk.activos.af_traslado", ensureBulkTraslados(jdbc, ctx));
        out.put("bulk.activos.af_valuacion", ensureBulkValuaciones(jdbc));
        out.put("bulk.activos.af_venta", ensureBulkVentas(jdbc));
        out.put("bulk.activos.af_documento", ensureBulkDocumentos(jdbc));
        out.put("bulk.activos.af_historial", ensureBulkHistorial(jdbc));
        out.put("bulk.activos.af_numeracion_config", ensureBulkNumeracion(jdbc));
        out.put("bulk.enriquecimiento_bulk", completarBulkSinNulos(jdbc));
        return out;
    }

    record BulkContext(
            Long subClaseLinealId,
            Long sucursalId,
            Long ubiA,
            Long ubiB,
            Long proveedorId,
            Long tipoOpDepId) {
    }

    private static int ensureBulkClases(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_clase")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado, created_by)
                SELECT ? || LPAD(g::text, 3, '0'), 'Clase bulk factory ' || g, 'LINEAL', 60 + (g % 120), '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (codigo) DO NOTHING
                """, PREFIX_CLASE, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkSubClases(JdbcTemplate jdbc, Long subLinealId) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_sub_clase") || subLinealId == null) {
            return 0;
        }
        Long claseBulkId = jdbc.query(
                "SELECT id FROM activos.af_clase WHERE codigo = ? || '001'",
                rs -> rs.next() ? rs.getLong(1) : null,
                PREFIX_CLASE);
        if (claseBulkId == null) {
            claseBulkId = jdbc.query(
                    "SELECT id FROM activos.af_clase WHERE codigo = ?",
                    rs -> rs.next() ? rs.getLong(1) : null,
                    ActivosTestDataFactory.CODIGO_CLASE);
        }
        int rows = jdbc.update("""
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado, created_by)
                SELECT ?, ? || LPAD(g::text, 3, '0'), 'Subclase bulk factory ' || g, 60 + (g % 60), '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (af_clase_id, codigo) DO NOTHING
                """, claseBulkId, PREFIX_SUB, USER_ID, BULK_ROWS);
        rows += jdbc.update("""
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado, created_by)
                SELECT ?, ? || LPAD(g::text, 3, '0'), 'Subclase bulk lineal ' || g, 120, '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (af_clase_id, codigo) DO NOTHING
                """, subLinealId, PREFIX_SUB, USER_ID, BULK_ROWS);
        return rows;
    }

    private static int ensureBulkUbicaciones(JdbcTemplate jdbc, Long sucursalId) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_ubicacion") || sucursalId == null) {
            return 0;
        }
        if (ActivosTestDataFactory.columnExists(jdbc, "activos", "af_ubicacion", "created_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado, created_by, updated_by)
                    SELECT ?, ? || LPAD(g::text, 3, '0'), 'Ubicación bulk factory ' || g, '1', ?, ?
                    FROM generate_series(1, ?) AS g
                    ON CONFLICT (sucursal_id, codigo) DO NOTHING
                    """, sucursalId, PREFIX_UBI, USER_ID, USER_ID, BULK_ROWS);
        }
        return jdbc.update("""
                INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado)
                SELECT ?, ? || LPAD(g::text, 3, '0'), 'Ubicación bulk factory ' || g, '1'
                FROM generate_series(1, ?) AS g
                ON CONFLICT (sucursal_id, codigo) DO NOTHING
                """, sucursalId, PREFIX_UBI, BULK_ROWS);
    }

    private static int ensureBulkMaestros(JdbcTemplate jdbc, BulkContext ctx) {
        Long subId = ctx.subClaseLinealId();
        Long provId = ctx.proveedorId();
        if (subId == null || provId == null) {
            return 0;
        }
        boolean conEstado = ActivosTestDataFactory.columnExists(jdbc, "activos", "af_maestro", "estado_activo");
        boolean conUnidades = ActivosTestDataFactory.columnExists(jdbc, "activos", "af_maestro", "unidades_produccion_totales");
        if (conEstado && conUnidades) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado,
                        unidades_produccion_totales, unidades_produccion_periodo, created_by, updated_by)
                    SELECT ? || LPAD(g::text, 3, '0'), 'Activo bulk factory ' || g, ?,
                        u.id, DATE '2024-01-01' + ((g - 1) % 180),
                        8000.0000 + (g * 150), 400.0000 + (g % 20) * 25, ?, 'ACTIVO', '1',
                        (g % 50) * 100, (g % 12) * 10, ?, ?
                    FROM generate_series(1, ?) AS g
                    JOIN activos.af_ubicacion u ON u.sucursal_id = ? AND u.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                    ON CONFLICT (codigo) DO NOTHING
                    """, PREFIX_MAESTRO, subId, provId, USER_ID, USER_ID, BULK_ROWS,
                    ctx.sucursalId(), PREFIX_UBI, BULK_ROWS);
        }
        if (conEstado) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado, created_by, updated_by)
                    SELECT ? || LPAD(g::text, 3, '0'), 'Activo bulk factory ' || g, ?,
                        u.id, DATE '2024-01-01' + ((g - 1) % 180),
                        8000.0000 + (g * 150), 400.0000 + (g % 20) * 25, ?, 'ACTIVO', '1', ?, ?
                    FROM generate_series(1, ?) AS g
                    JOIN activos.af_ubicacion u ON u.sucursal_id = ? AND u.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                    ON CONFLICT (codigo) DO NOTHING
                    """, PREFIX_MAESTRO, subId, provId, USER_ID, USER_ID, BULK_ROWS,
                    ctx.sucursalId(), PREFIX_UBI, BULK_ROWS);
        }
        return jdbc.update("""
                INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                    valor_adquisicion, valor_residual, proveedor_id, flag_estado, created_by)
                SELECT ? || LPAD(g::text, 3, '0'), 'Activo bulk factory ' || g, ?,
                    u.id, DATE '2024-01-01' + ((g - 1) % 180),
                    8000.0000 + (g * 150), 400.0000, ?, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_ubicacion u ON u.sucursal_id = ? AND u.codigo = ? || LPAD((1 + ((g - 1) % ?))::text, 3, '0')
                ON CONFLICT (codigo) DO NOTHING
                """, PREFIX_MAESTRO, subId, provId, USER_ID, BULK_ROWS,
                ctx.sucursalId(), PREFIX_UBI, BULK_ROWS);
    }

    private static int ensureBulkMaestroCcDistrib(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_maestro_cc_distrib")
                || !ActivosTestDataFactory.tableExists(jdbc, "contabilidad", "centros_costo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_maestro_cc_distrib (af_maestro_id, centro_costo_id, porcentaje, created_by)
                SELECT m.id, cc.id, 100.0000, ?
                FROM activos.af_maestro m
                CROSS JOIN (SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1) cc
                WHERE m.codigo LIKE ? || '%'
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_maestro_cc_distrib d
                      WHERE d.af_maestro_id = m.id AND d.centro_costo_id = cc.id
                  )
                """, USER_ID, ActivosTestDataFactory.CODIGO_CC_1, PREFIX_MAESTRO);
    }

    private static int ensureBulkTiposOperacion(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_tipo_operacion")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo,
                    modulo_contable, tipo_operacion_contable, flag_estado, created_by)
                SELECT ? || LPAD(g::text, 4, '0'), 'Tipo operación bulk ' || g, 'DEBITO', 'FIJO', 'AF', 'DEPRECIACION', '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (codigo) DO NOTHING
                """, PREFIX_TIPO_OP, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkCalculos(JdbcTemplate jdbc, Long tipoOpId) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_calculo_cntbl")) {
            return 0;
        }
        if (tipoOpId != null && ActivosTestDataFactory.columnExists(jdbc, "activos", "af_calculo_cntbl", "af_tipo_operacion_id")) {
            return jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                        depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                    SELECT m.id, ?, 2025, 1 + ((g - 1) % 12),
                        50.0000 + (g % 40), 50.0000 * (1 + ((g - 1) % 12)), 10000.0000 - (g * 50), '1', ?, ?
                    FROM generate_series(1, ?) AS g
                    JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, tipoOpId, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
        }
        return jdbc.update("""
                INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                    depreciacion_acumulada, valor_neto, flag_estado, created_by)
                SELECT m.id, 2025, 1 + ((g - 1) % 12), 50.0000 + (g % 40), 50.0000 * (1 + ((g - 1) % 12)),
                    10000.0000 - (g * 50), '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkAdaptaciones(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_adaptacion")) {
            return 0;
        }
        boolean conEstado = ActivosTestDataFactory.columnExists(jdbc, "activos", "af_adaptacion", "estado");
        if (conEstado) {
            return jdbc.update("""
                    INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, estado, flag_estado, created_by, updated_by)
                    SELECT m.id, DATE '2025-01-01' + ((g - 1) % 90), 'Adaptación bulk factory ' || g,
                        200.0000 + (g * 5), 'REGISTRADO', '1', ?, ?
                    FROM generate_series(1, ?) AS g
                    JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_adaptacion a
                        WHERE a.af_maestro_id = m.id AND a.descripcion = 'Adaptación bulk factory ' || g
                    )
                    """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
        }
        return jdbc.update("""
                INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, flag_estado, created_by)
                SELECT m.id, DATE '2025-01-01' + ((g - 1) % 90), 'Adaptación bulk factory ' || g,
                    200.0000 + (g * 5), '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_adaptacion a
                    WHERE a.af_maestro_id = m.id AND a.descripcion = 'Adaptación bulk factory ' || g
                )
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkAdaptacionDet(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_adaptacion_det")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, flag_estado, created_by)
                SELECT a.id, 'Detalle bulk adaptación', a.monto_total, '1', ?
                FROM activos.af_adaptacion a
                INNER JOIN activos.af_maestro m ON m.id = a.af_maestro_id
                WHERE m.codigo LIKE ? || '%' AND a.descripcion LIKE 'Adaptación bulk factory%'
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_adaptacion_det d WHERE d.af_adaptacion_id = a.id
                  )
                """, USER_ID, PREFIX_MAESTRO);
    }

    private static int ensureBulkAdaptacionDep(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_adaptacion_dep")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_adaptacion_dep (af_adaptacion_id, anio, mes, depreciacion_periodo,
                    depreciacion_acumulada, flag_estado, created_by)
                SELECT a.id, 2025, 1 + ((m.id % 12)), 8.0000 + (m.id % 5), 8.0000 + (m.id % 5), '1', ?
                FROM activos.af_adaptacion a
                INNER JOIN activos.af_maestro m ON m.id = a.af_maestro_id
                WHERE m.codigo LIKE ? || '%' AND a.descripcion LIKE 'Adaptación bulk factory%'
                ON CONFLICT (af_adaptacion_id, anio, mes) DO NOTHING
                """, USER_ID, PREFIX_MAESTRO);
    }

    private static int ensureBulkAccesorios(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_accesorios")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_accesorios (af_maestro_id, descripcion, costo, fecha_instalacion, flag_estado, created_by)
                SELECT m.id, 'Accesorio bulk ' || g, 50.0000 + (g % 30) * 10, DATE '2024-06-01' + ((g - 1) % 60), '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_accesorios ac WHERE ac.af_maestro_id = m.id AND ac.descripcion = 'Accesorio bulk ' || g
                )
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkSoftware(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_software")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_software (af_maestro_id, licencia, proveedor_software, fecha_vigencia_ini,
                    fecha_vigencia_fin, soporte, flag_estado, created_by)
                SELECT m.id, 'LIC-BULK-' || LPAD(g::text, 3, '0'), 'Proveedor SW bulk ' || g,
                    DATE '2025-01-01', DATE '2027-12-31', 'soporte' || g || '@factory.test', '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_software s WHERE s.af_maestro_id = m.id AND s.licencia = 'LIC-BULK-' || LPAD(g::text, 3, '0')
                )
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkRevaluacion(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_revaluacion")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_revaluacion (af_maestro_id, fecha, valor_anterior, valor_nuevo, sustento, perito_id, flag_estado, created_by)
                SELECT m.id, DATE '2025-03-01' + ((g - 1) % 30), 8000.0000 + (g * 100), 8200.0000 + (g * 100),
                    'Informe bulk ' || g, ?, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_revaluacion r WHERE r.af_maestro_id = m.id AND r.fecha = DATE '2025-03-01' + ((g - 1) % 30)
                )
                """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkOperaciones(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_operaciones")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_operaciones (af_maestro_id, tipo, fecha_programada, fecha_ejecucion, costo, proveedor_servicio, flag_estado, created_by)
                SELECT m.id, CASE (g % 3) WHEN 0 THEN 'MANTENIMIENTO' WHEN 1 THEN 'CALIBRACION' ELSE 'INSPECCION' END,
                    DATE '2025-05-01' + ((g - 1) % 40), DATE '2025-05-02' + ((g - 1) % 40),
                    100.0000 + (g * 3), 'Servicio bulk ' || g, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_operaciones o
                    WHERE o.af_maestro_id = m.id AND o.fecha_programada = DATE '2025-05-01' + ((g - 1) % 40)
                )
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkAseguradoras(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_aseguradora")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_aseguradora (nombre, ruc, contacto, flag_estado, created_by)
                SELECT 'Aseguradora bulk ' || g, '20' || LPAD((99000000 + g)::text, 8, '0'),
                    'bulk' || g || '@aseg.factory.test', '1', ?
                FROM generate_series(1, ?) AS g
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_aseguradora a WHERE a.ruc = '20' || LPAD((99000000 + g)::text, 8, '0')
                )
                """, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkPolizas(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_poliza_seguro")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_poliza_seguro (af_aseguradora_id, numero_poliza, fecha_inicio, fecha_fin,
                    prima, cobertura, flag_estado, created_by)
                SELECT a.id, ? || LPAD(g::text, 3, '0'), DATE '2025-01-01', DATE '2027-12-31',
                    300.0000 + (g * 10), 15000.0000 + (g * 100), '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_aseguradora a ON a.ruc = '20' || LPAD((99000000 + g)::text, 8, '0')
                ON CONFLICT (numero_poliza) DO NOTHING
                """, PREFIX_POLIZA, USER_ID, BULK_ROWS);
    }

    private static int ensureBulkPolizaActivo(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_poliza_activo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_poliza_activo (af_poliza_seguro_id, af_maestro_id, valor_asegurado, flag_estado, created_by)
                SELECT p.id, m.id, 9000.0000 + (g * 50), '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                JOIN activos.af_poliza_seguro p ON p.numero_poliza = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_poliza_activo pa
                    WHERE pa.af_poliza_seguro_id = p.id AND pa.af_maestro_id = m.id
                )
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO, PREFIX_POLIZA);
    }

    private static int ensureBulkPrimaDevengo(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_prima_devengo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_prima_devengo (af_poliza_seguro_id, anio, mes, importe_devengado, meses_vigencia_poliza, flag_estado, created_by)
                SELECT p.id, 2025, 1 + ((g - 1) % 12), 20.0000 + (g % 10), 24, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_poliza_seguro p ON p.numero_poliza = ? || LPAD(g::text, 3, '0')
                ON CONFLICT (af_poliza_seguro_id, anio, mes) DO NOTHING
                """, USER_ID, BULK_ROWS, PREFIX_POLIZA);
    }

    private static int ensureBulkTraslados(JdbcTemplate jdbc, BulkContext ctx) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_traslado")
                || !ActivosTestDataFactory.columnExists(jdbc, "activos", "af_traslado", "estado")) {
            return 0;
        }
        Long ubiA = ctx.ubiA();
        Long ubiB = ctx.ubiB();
        if (ubiA == null || ubiB == null) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                    solicitante_id, aprobador_id, fecha_solicitud, fecha_ejecucion, motivo, estado, flag_estado, created_by)
                SELECT m.id,
                    CASE WHEN g % 2 = 0 THEN ? ELSE ? END,
                    CASE WHEN g % 2 = 0 THEN ? ELSE ? END,
                    ?, ?, DATE '2025-06-01' + ((g - 1) % 30),
                    CASE WHEN g % 4 = 0 THEN DATE '2025-06-02' + ((g - 1) % 30) ELSE NULL END,
                    'Traslado bulk factory ' || g,
                    CASE (g % 4) WHEN 0 THEN 'EJECUTADO' WHEN 1 THEN 'APROBADO' WHEN 2 THEN 'SOLICITUD' ELSE 'RECHAZADO' END,
                    '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_traslado t WHERE t.af_maestro_id = m.id AND t.motivo = 'Traslado bulk factory ' || g
                )
                """, ubiA, ubiB, ubiB, ubiA, USER_ID, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkValuaciones(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_valuacion")
                || !ActivosTestDataFactory.columnExists(jdbc, "activos", "af_valuacion", "estado")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_valuacion (af_maestro_id, fecha_valuacion, valor_anterior, valor_nuevo,
                    metodo_valuacion, tipo_revaluacion, responsable_id, estado, observaciones, flag_estado, created_by)
                SELECT m.id, DATE '2025-04-01' + ((g - 1) % 45), 8000.0000 + (g * 80), 8300.0000 + (g * 80),
                    'REVALUACION', 'INFLACION', ?, 'APROBADO', 'Valuación bulk ' || g, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_valuacion v
                    WHERE v.af_maestro_id = m.id AND v.observaciones = 'Valuación bulk ' || g
                )
                """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkVentas(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_venta")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_venta (af_maestro_id, fecha_baja, motivo, valor_venta, comprador, flag_estado, created_by)
                SELECT m.id, DATE '2025-12-01' + ((g - 1) % 20), 'VENTA', 5000.0000 + (g * 50),
                    'Comprador bulk ' || g, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (SELECT 1 FROM activos.af_venta v WHERE v.af_maestro_id = m.id)
                """, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkDocumentos(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_documento")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo,
                    descripcion, fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by)
                SELECT m.id, 'FACTURA', 'bulk-doc-' || g || '.pdf', '/factory/bulk/doc-' || g || '.pdf',
                    'Documento bulk factory', DATE '2025-02-01' + ((g - 1) % 60), 102400 + (g * 100), 'pdf', ?, '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_documento d WHERE d.af_maestro_id = m.id AND d.nombre_archivo = 'bulk-doc-' || g || '.pdf'
                )
                """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkHistorial(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_historial")) {
            return 0;
        }
        if (ActivosTestDataFactory.columnExists(jdbc, "activos", "af_historial", "valor_anterior")) {
            return jdbc.update("""
                    INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, valor_anterior, valor_nuevo,
                        usuario_id, fecha_evento, ip_origen, modulo, flag_estado, created_by)
                    SELECT m.id, 'BULK_EVENT', 'Evento historial bulk ' || g, 'ant-' || g, 'nuevo-' || g,
                        ?, NOW() - ((g || ' hours')::interval), '127.0.0.1', 'FACTORY-AF-BULK', '1', ?
                    FROM generate_series(1, ?) AS g
                    JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_historial h
                        WHERE h.af_maestro_id = m.id AND h.modulo = 'FACTORY-AF-BULK' AND h.tipo_evento = 'BULK_EVENT'
                          AND h.descripcion = 'Evento historial bulk ' || g
                    )
                    """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
        }
        return jdbc.update("""
                INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, usuario_id,
                    fecha_evento, ip_origen, modulo, flag_estado, created_by)
                SELECT m.id, 'BULK_EVENT', 'Evento historial bulk ' || g, ?, NOW(), '127.0.0.1', 'FACTORY-AF-BULK', '1', ?
                FROM generate_series(1, ?) AS g
                JOIN activos.af_maestro m ON m.codigo = ? || LPAD(g::text, 3, '0')
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_historial h
                    WHERE h.af_maestro_id = m.id AND h.modulo = 'FACTORY-AF-BULK' AND h.descripcion = 'Evento historial bulk ' || g
                )
                """, USER_ID, USER_ID, BULK_ROWS, PREFIX_MAESTRO);
    }

    private static int ensureBulkNumeracion(JdbcTemplate jdbc) {
        if (!ActivosTestDataFactory.tableExists(jdbc, "activos", "af_numeracion_config")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero, flag_estado, created_by)
                SELECT 'BULK' || LPAD(g::text, 3, '0'), 'BLK' || g, 1000 + g, 6, '1', ?
                FROM generate_series(1, ?) AS g
                ON CONFLICT (tipo) DO NOTHING
                """, USER_ID, BULK_ROWS);
    }

    private static int completarBulkSinNulos(JdbcTemplate jdbc) {
        int rows = 0;
        if (ActivosTestDataFactory.columnExists(jdbc, "activos", "af_maestro", "factura_proveedor_serie")) {
            rows += jdbc.update("""
                    UPDATE activos.af_maestro SET
                        factura_proveedor_serie = COALESCE(factura_proveedor_serie, 'F001'),
                        factura_proveedor_numero = COALESCE(factura_proveedor_numero, 'B' || LPAD(SUBSTRING(codigo FROM '[0-9]+$'), 8, '0')),
                        factura_proveedor_fecha = COALESCE(factura_proveedor_fecha, fecha_adquisicion),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE codigo LIKE ? || '%'
                    """, USER_ID, PREFIX_MAESTRO);
        }
        if (ActivosTestDataFactory.columnExists(jdbc, "activos", "af_calculo_cntbl", "af_tipo_operacion_id")) {
            Long tipoId = jdbc.query(
                    "SELECT id FROM activos.af_tipo_operacion WHERE codigo = 'FACTORY-AF' LIMIT 1",
                    rs -> rs.next() ? rs.getLong(1) : null);
            if (tipoId != null) {
                rows += jdbc.update("""
                        UPDATE activos.af_calculo_cntbl c SET af_tipo_operacion_id = ?
                        FROM activos.af_maestro m
                        WHERE m.id = c.af_maestro_id AND m.codigo LIKE ? || '%' AND c.af_tipo_operacion_id IS NULL
                        """, tipoId, PREFIX_MAESTRO);
            }
        }
        return rows;
    }
}
