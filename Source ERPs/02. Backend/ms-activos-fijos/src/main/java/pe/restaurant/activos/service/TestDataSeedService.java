package pe.restaurant.activos.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Carga datos de demostración en el esquema {@code activos} del tenant actual.
 * Solo debe invocarse con {@code app.testdata.enabled=true}. Elimina filas previas del mismo seed (prefijo SEED-AF).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TestDataSeedService {

    private static final long SEED_USER_ID = 1L;

    /** Código de la sucursal insertada solo cuando la BD no tenía ninguna (seed demo). */
    private static final String SEED_SUCURSAL_CODIGO = "AF";

    private final JdbcTemplate jdbcTemplate;

    @Transactional
    public Map<String, Integer> seedActivosDemoData() {
        JdbcTemplate jdbc = jdbcTemplate;
        try {
            assertSeedPreconditions(jdbc);

            Long sucursalId = resolveSucursalIdForSeed(jdbc);

            boolean maestroTieneUnidades = columnExists(jdbc, "activos", "af_maestro", "unidades_produccion_totales");

            deleteSeedRows(jdbc);

        Map<String, Integer> out = new LinkedHashMap<>();

        Long claseLinealId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado)
                VALUES ('SEED-AF-CL-LINEAL', 'Clase seed LINEAL', 'LINEAL', 120, '1')
                RETURNING id
                """);
        Long claseUopId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado)
                VALUES ('SEED-AF-CL-UOP', 'Clase seed UOP', 'UNIDADES_PRODUCIDAS', 120, '1')
                RETURNING id
                """);
        out.put("activos.af_clase", 2);

        Long subLinealId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado)
                VALUES (?, 'SEED-AF-SUB-LINEAL', 'Subclase seed lineal', 120, '1')
                RETURNING id
                """, claseLinealId);
        Long subUopId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado)
                VALUES (?, 'SEED-AF-SUB-UOP', 'Subclase seed UOP', 120, '1')
                RETURNING id
                """, claseUopId);
        out.put("activos.af_sub_clase", 2);

        Long ubiA = insertReturningLong(jdbc, """
                INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado)
                VALUES (?, 'SEED-AF-UBI-A', 'Ubicación seed A', '1')
                RETURNING id
                """, sucursalId);
        Long ubiB = insertReturningLong(jdbc, """
                INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado)
                VALUES (?, 'SEED-AF-UBI-B', 'Ubicación seed B', '1')
                RETURNING id
                """, sucursalId);
        out.put("activos.af_ubicacion", 2);

        Long maestroPrincipal = insertMaestro(jdbc, maestroTieneUnidades, "SEED-AF-M-PRINCIPAL", "Activo principal seed",
                subLinealId, ubiA, "2024-01-10", "50000.0000", "5000.0000", null, null);
        Long maestroUop = insertMaestro(jdbc, maestroTieneUnidades, "SEED-AF-M-UOP", "Activo UOP seed",
                subUopId, ubiB, "2024-02-01", "30000.0000", "1000.0000", 100000, 500);
        Long maestroVenta = insertMaestro(jdbc, maestroTieneUnidades, "SEED-AF-M-VENDIDO", "Activo vendido seed",
                subLinealId, ubiA, "2023-06-01", "8000.0000", "500.0000", null, null);
        out.put("activos.af_maestro", 3);

        int matriz = jdbc.update("""
                INSERT INTO activos.af_matriz_sub_clase (af_sub_clase_id, cuenta_activo_id, cuenta_dep_acum_id,
                    cuenta_gasto_dep_id, cuenta_baja_id, cuenta_res_venta_id, centro_costo_id, flag_estado)
                VALUES (?, NULL, NULL, NULL, NULL, NULL, NULL, '1')
                ON CONFLICT (af_sub_clase_id) DO NOTHING
                """, subLinealId);
        matriz += jdbc.update("""
                INSERT INTO activos.af_matriz_sub_clase (af_sub_clase_id, cuenta_activo_id, cuenta_dep_acum_id,
                    cuenta_gasto_dep_id, cuenta_baja_id, cuenta_res_venta_id, centro_costo_id, flag_estado)
                VALUES (?, NULL, NULL, NULL, NULL, NULL, NULL, '1')
                ON CONFLICT (af_sub_clase_id) DO NOTHING
                """, subUopId);
        out.put("activos.af_matriz_sub_clase", matriz);

        out.put("activos.af_calculo_cntbl", jdbc.update("""
                INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by)
                VALUES (?, 2025, 1, 375.0000, 375.0000, 49625.0000, '1', ?)
                ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                """, maestroPrincipal, SEED_USER_ID));

        Long adaptId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, flag_estado, created_by)
                VALUES (?, DATE '2025-03-01', 'Adaptación demo seed', 2500.0000, '1', ?)
                RETURNING id
                """, maestroPrincipal, SEED_USER_ID);
        out.put("activos.af_adaptacion", 1);
        out.put("activos.af_adaptacion_det", jdbc.update("""
                INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, unidad_medida_id, flag_estado, created_by)
                VALUES (?, 'Detalle adaptación seed', 2500.0000, NULL, '1', ?)
                """, adaptId, SEED_USER_ID));
        out.put("activos.af_adaptacion_dep", jdbc.update("""
                INSERT INTO activos.af_adaptacion_dep (af_adaptacion_id, anio, mes, depreciacion_periodo, depreciacion_acumulada, flag_estado, created_by)
                VALUES (?, 2025, 3, 50.0000, 50.0000, '1', ?)
                ON CONFLICT (af_adaptacion_id, anio, mes) DO NOTHING
                """, adaptId, SEED_USER_ID));

        Long asegId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_aseguradora (nombre, ruc, contacto, flag_estado, created_by)
                VALUES ('SEED-AF Aseguradora Demo', '20999999999', 'Contacto seed', '1', ?)
                RETURNING id
                """, SEED_USER_ID);
        out.put("activos.af_aseguradora", 1);

        Long polizaId = insertReturningLong(jdbc, """
                INSERT INTO activos.af_poliza_seguro (af_aseguradora_id, numero_poliza, fecha_inicio, fecha_fin, prima, cobertura, flag_estado, created_by)
                VALUES (?, 'SEED-AF-POL-001', DATE '2025-01-01', DATE '2026-12-31', 1200.0000, 48000.0000, '1', ?)
                RETURNING id
                """, asegId, SEED_USER_ID);
        out.put("activos.af_poliza_seguro", 1);
        out.put("activos.af_poliza_activo", jdbc.update("""
                INSERT INTO activos.af_poliza_activo (af_poliza_seguro_id, af_maestro_id, valor_asegurado, flag_estado, created_by)
                VALUES (?, ?, 45000.0000, '1', ?)
                """, polizaId, maestroPrincipal, SEED_USER_ID));
        out.put("activos.af_prima_devengo", jdbc.update("""
                INSERT INTO activos.af_prima_devengo (af_poliza_seguro_id, anio, mes, importe_devengado, meses_vigencia_poliza, flag_estado, created_by)
                VALUES (?, 2025, 6, 100.0000, 24, '1', ?)
                ON CONFLICT (af_poliza_seguro_id, anio, mes) DO NOTHING
                """, polizaId, SEED_USER_ID));

        out.put("activos.af_historial", jdbc.update("""
                INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, valor_anterior, valor_nuevo,
                    usuario_id, fecha_evento, ip_origen, modulo, flag_estado, created_by)
                VALUES (?, 'ALTA', 'Registro histórico seed', NULL, 'ALTA', ?, ?, '127.0.0.1', 'SEED-AF', '1', ?)
                """, maestroPrincipal, SEED_USER_ID, LocalDateTime.now(), SEED_USER_ID));

        out.put("activos.af_documento", jdbc.update("""
                INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo, descripcion,
                    fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by)
                VALUES (?, 'FACTURA', 'factura-seed.pdf', 'SEED-AF/docs/factura-seed.pdf', 'Documento demo',
                    CURRENT_DATE, 1024, 'pdf', ?, '1', ?)
                """, maestroPrincipal, SEED_USER_ID, SEED_USER_ID));

        out.put("activos.af_operaciones", jdbc.update("""
                INSERT INTO activos.af_operaciones (af_maestro_id, tipo, fecha_programada, fecha_ejecucion, costo, proveedor_servicio, flag_estado, created_by)
                VALUES (?, 'MANTENIMIENTO', DATE '2025-08-01', NULL, 150.0000, 'Proveedor seed', '1', ?)
                """, maestroPrincipal, SEED_USER_ID));

        out.put("activos.af_traslado", jdbc.update("""
                INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id, solicitante_id,
                    aprobador_id, fecha_solicitud, fecha_ejecucion, motivo, flag_estado, created_by)
                VALUES (?, ?, ?, ?, NULL, DATE '2025-04-01', NULL, 'Traslado demo seed', '1', ?)
                """, maestroPrincipal, ubiA, ubiB, SEED_USER_ID, SEED_USER_ID));

        out.put("activos.af_software", jdbc.update("""
                INSERT INTO activos.af_software (af_maestro_id, licencia, proveedor_software, fecha_vigencia_ini, fecha_vigencia_fin, soporte, flag_estado, created_by)
                VALUES (?, 'LIC-SEED-001', 'Vendor seed', DATE '2025-01-01', DATE '2026-12-31', 'Soporte seed', '1', ?)
                """, maestroPrincipal, SEED_USER_ID));

        out.put("activos.af_accesorios", jdbc.update("""
                INSERT INTO activos.af_accesorios (af_maestro_id, descripcion, costo, fecha_instalacion, flag_estado, created_by)
                VALUES (?, 'Accesorio seed', 200.0000, DATE '2025-02-01', '1', ?)
                """, maestroPrincipal, SEED_USER_ID));

        out.put("activos.af_revaluacion", jdbc.update("""
                INSERT INTO activos.af_revaluacion (af_maestro_id, fecha, valor_anterior, valor_nuevo, sustento, perito_id, flag_estado, created_by)
                VALUES (?, DATE '2025-05-01', 50000.0000, 52000.0000, 'Revaluación demo seed', NULL, '1', ?)
                """, maestroPrincipal, SEED_USER_ID));

        out.put("activos.af_venta", jdbc.update("""
                INSERT INTO activos.af_venta (af_maestro_id, fecha_baja, motivo, valor_venta, comprador, flag_estado, created_by)
                VALUES (?, DATE '2025-07-01', 'VENTA', 7500.0000, 'Comprador seed', '1', ?)
                """, maestroVenta, SEED_USER_ID));

        if (tableExists(jdbc, "activos", "af_valuacion")) {
            out.put("activos.af_valuacion", jdbc.update("""
                    INSERT INTO activos.af_valuacion (af_maestro_id, fecha_valuacion, valor_anterior, valor_nuevo, metodo_valuacion,
                        responsable_id, observaciones, fecha_aprobacion, aprobador_id, flag_estado, created_by)
                    VALUES (?, DATE '2025-09-01', 50000.00, 51500.00, 'COSTO', ?, 'Valuación seed', NULL, NULL, '1', ?)
                    """, maestroPrincipal, SEED_USER_ID, SEED_USER_ID));
        } else {
            out.put("activos.af_valuacion", 0);
        }

        log.info("Seed activos completado: {}", out);
        return out;
        } catch (DataAccessException e) {
            String detail = rootMessage(e);
            log.error("Seed activos falló en SQL: {}", detail, e);
            throw new BusinessException(
                    "Fallo al ejecutar seed en la base de datos: " + detail,
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.SEED_BD_INCOMPATIBLE);
        } catch (RuntimeException e) {
            Throwable root = org.springframework.core.NestedExceptionUtils.getMostSpecificCause(e);
            if (root instanceof java.sql.SQLException sqlEx) {
                log.error("Seed activos: SQLException envuelta: {}", sqlEx.getMessage(), e);
                throw new BusinessException(
                        "Fallo al ejecutar seed en la base de datos: " + sqlEx.getMessage(),
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.SEED_BD_INCOMPATIBLE);
            }
            throw e;
        }
    }

    private static void deleteSeedRows(JdbcTemplate jdbc) {
        final String seedMaestroIds = "SELECT id FROM activos.af_maestro WHERE codigo LIKE 'SEED-AF-%'";

        jdbc.update("""
                DELETE FROM activos.af_prima_devengo WHERE af_poliza_seguro_id IN (
                    SELECT id FROM activos.af_poliza_seguro WHERE numero_poliza LIKE 'SEED-AF-%')
                """);
        jdbc.update("DELETE FROM activos.af_poliza_activo WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        jdbc.update("DELETE FROM activos.af_poliza_seguro WHERE numero_poliza LIKE 'SEED-AF-%'");

        jdbc.update("DELETE FROM activos.af_documento WHERE ruta_archivo LIKE 'SEED-AF/%'");
        jdbc.update("DELETE FROM activos.af_historial WHERE af_maestro_id IN (" + seedMaestroIds + ")");

        jdbc.update("""
                DELETE FROM activos.af_matriz_sub_clase WHERE af_sub_clase_id IN (
                    SELECT id FROM activos.af_sub_clase WHERE codigo LIKE 'SEED-AF-%')
                """);

        jdbc.update("DELETE FROM activos.af_adaptacion_dep WHERE af_adaptacion_id IN ("
                + "SELECT id FROM activos.af_adaptacion WHERE af_maestro_id IN (" + seedMaestroIds + "))");
        jdbc.update("DELETE FROM activos.af_adaptacion_det WHERE af_adaptacion_id IN ("
                + "SELECT id FROM activos.af_adaptacion WHERE af_maestro_id IN (" + seedMaestroIds + "))");
        jdbc.update("DELETE FROM activos.af_adaptacion WHERE af_maestro_id IN (" + seedMaestroIds + ")");

        jdbc.update("DELETE FROM activos.af_calculo_cntbl WHERE af_maestro_id IN (" + seedMaestroIds + ")");

        jdbc.update("DELETE FROM activos.af_operaciones WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        jdbc.update("DELETE FROM activos.af_traslado WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        jdbc.update("DELETE FROM activos.af_venta WHERE af_maestro_id IN (" + seedMaestroIds + ")");

        jdbc.update("DELETE FROM activos.af_software WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        jdbc.update("DELETE FROM activos.af_accesorios WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        jdbc.update("DELETE FROM activos.af_revaluacion WHERE af_maestro_id IN (" + seedMaestroIds + ")");

        if (tableExists(jdbc, "activos", "af_valuacion")) {
            jdbc.update("DELETE FROM activos.af_valuacion WHERE af_maestro_id IN (" + seedMaestroIds + ")");
        }

        jdbc.update("DELETE FROM activos.af_maestro WHERE codigo LIKE 'SEED-AF-%'");
        jdbc.update("DELETE FROM activos.af_sub_clase WHERE codigo LIKE 'SEED-AF-%'");
        jdbc.update("DELETE FROM activos.af_clase WHERE codigo LIKE 'SEED-AF-%'");
        jdbc.update("DELETE FROM activos.af_ubicacion WHERE codigo LIKE 'SEED-AF-%'");
        jdbc.update("DELETE FROM activos.af_aseguradora WHERE nombre = ?", "SEED-AF Aseguradora Demo");
    }

    private static void assertSeedPreconditions(JdbcTemplate jdbc) {
        String[] requiredActivos = {
                "af_clase", "af_sub_clase", "af_ubicacion", "af_maestro", "af_matriz_sub_clase",
                "af_calculo_cntbl", "af_adaptacion", "af_adaptacion_det", "af_adaptacion_dep",
                "af_aseguradora", "af_poliza_seguro", "af_poliza_activo", "af_prima_devengo",
                "af_historial", "af_documento", "af_operaciones", "af_traslado", "af_software",
                "af_accesorios", "af_revaluacion", "af_venta"
        };
        for (String t : requiredActivos) {
            if (!tableExists(jdbc, "activos", t)) {
                throw new BusinessException(
                        "Falta la tabla activos." + t + ". Aplique migraciones Flyway / DDL del tenant antes del seed.",
                        HttpStatus.PRECONDITION_FAILED,
                        ActivosErrorCodes.SEED_BD_INCOMPATIBLE);
            }
        }
    }

    /**
     * Obtiene un {@code sucursal_id} válido para {@code af_ubicacion}. Si no existe {@code auth.sucursal},
     * crea esquema/tabla mínimos alineados con {@code 01-auth.sql} del tenant e inserta una sucursal de demo
     * (solo para entornos de prueba con {@code app.testdata.enabled}).
     */
    private Long resolveSucursalIdForSeed(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "auth", "sucursal")) {
            log.warn("auth.sucursal no existe: creando esquema auth y tabla sucursal mínima para el seed de demo.");
            jdbc.execute("CREATE SCHEMA IF NOT EXISTS auth");
            jdbc.execute("""
                    CREATE TABLE IF NOT EXISTS auth.sucursal (
                        id BIGSERIAL PRIMARY KEY,
                        codigo VARCHAR(2) NOT NULL,
                        nombre VARCHAR(150) NOT NULL,
                        direccion VARCHAR(300),
                        ciudad VARCHAR(120),
                        moneda_defult_id BIGINT,
                        pais_id BIGINT,
                        departamento_id BIGINT,
                        provincia_id BIGINT,
                        distrito_id BIGINT,
                        ubigeo VARCHAR(12),
                        flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
                        created_by BIGINT,
                        fec_creacion TIMESTAMPTZ DEFAULT NOW(),
                        updated_by BIGINT,
                        fec_modificacion TIMESTAMPTZ,
                        UNIQUE (codigo)
                    )
                    """);
        }

        Long id = jdbc.query(
                "SELECT id FROM auth.sucursal ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
        if (id != null) {
            return id;
        }

        jdbc.update("""
                INSERT INTO auth.sucursal (codigo, nombre, flag_estado)
                VALUES (?, ?, '1')
                ON CONFLICT (codigo) DO NOTHING
                """, SEED_SUCURSAL_CODIGO, "Sucursal seed (demo activos fijos)");

        id = jdbc.query(
                "SELECT id FROM auth.sucursal WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                SEED_SUCURSAL_CODIGO);
        if (id == null) {
            id = jdbc.query(
                    "SELECT id FROM auth.sucursal ORDER BY id LIMIT 1",
                    rs -> rs.next() ? rs.getLong(1) : null);
        }
        if (id == null) {
            throw new BusinessException(
                    "No hay filas en auth.sucursal y no se pudo crear la sucursal de demo; revise permisos DDL en la BD.",
                    HttpStatus.PRECONDITION_FAILED,
                    ActivosErrorCodes.SEED_SIN_SUCURSAL);
        }
        return id;
    }

    private static boolean tableExists(JdbcTemplate jdbc, String schema, String tableName) {
        Integer n = jdbc.queryForObject("""
                        SELECT COUNT(*)::int FROM information_schema.tables
                        WHERE table_schema = ? AND table_name = ?
                        """,
                Integer.class, schema, tableName);
        return n != null && n > 0;
    }

    private static boolean columnExists(JdbcTemplate jdbc, String schema, String tableName, String columnName) {
        Integer n = jdbc.queryForObject("""
                        SELECT COUNT(*)::int FROM information_schema.columns
                        WHERE table_schema = ? AND table_name = ? AND column_name = ?
                        """,
                Integer.class, schema, tableName, columnName);
        return n != null && n > 0;
    }

    private static Long insertMaestro(JdbcTemplate jdbc, boolean incluirUnidades, String codigo, String nombre,
                                      Long subClaseId, Long ubicacionId, String fechaAdq,
                                      String valorAdq, String valorResidual,
                                      Integer unidadesTotales, Integer unidadesPeriodo) {
        if (incluirUnidades) {
            return insertReturningLong(jdbc, """
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, flag_estado,
                        unidades_produccion_totales, unidades_produccion_periodo)
                    VALUES (?, ?, ?, ?, CAST(? AS DATE), ?::numeric, ?::numeric, NULL, '1', ?, ?)
                    RETURNING id
                    """, codigo, nombre, subClaseId, ubicacionId, fechaAdq, valorAdq, valorResidual,
                    unidadesTotales, unidadesPeriodo);
        }
        return insertReturningLong(jdbc, """
                INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                    valor_adquisicion, valor_residual, proveedor_id, flag_estado)
                VALUES (?, ?, ?, ?, CAST(? AS DATE), ?::numeric, ?::numeric, NULL, '1')
                RETURNING id
                """, codigo, nombre, subClaseId, ubicacionId, fechaAdq, valorAdq, valorResidual);
    }

    private static String rootMessage(DataAccessException e) {
        Throwable c = e.getMostSpecificCause();
        return c != null && c.getMessage() != null ? c.getMessage() : e.getMessage();
    }

    private static Long insertReturningLong(JdbcTemplate jdbc, String sql, Object... args) {
        return jdbc.queryForObject(sql, Long.class, args);
    }
}
