package pe.restaurant.activos.testdata;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Test data factory intended for automated tests.
 *
 * <p>Unlike {@code TestDataSeedService} (admin/demo endpoint), this factory aims to be
 * idempotent and safe to call multiple times during a test run. It avoids mass deletes and
 * prefers insert-if-missing / upsert patterns.</p>
 *
 * <p>It operates on the current tenant database (routing {@link DataSource}). Integration tests
 * should call {@link #ensureActivosTransactionalData()} from {@code @BeforeEach} and load entities
 * via repositories or JDBC using the stable {@code FACTORY-AF-*} codes documented below.</p>
 * <p>Para objetos en memoria en unitarios Mockito ver {@code pe.restaurant.activos.TestDataFactory}
 * en {@code src/test/java}.</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ActivosTestDataFactory {

    private static final String[] INTEGRACION_MIGRATION_SCRIPTS = {
            "db/migration/V202602141400__af_matriz_historial_documento_prima_devengo.sql",
            "db/migration/V202605141010__af_maestro_unidades_produccion.sql",
            "db/migration/V202605151400__af_movimientos_estado_workflow.sql",
            "db/migration/V202605161200__integracion_erp_contable_compras.sql",
            "db/migration/V202605161400__af_tipo_operacion_numeracion.sql",
            "db/migration/V202605161500__af_maestro_recepcion_compra.sql",
            "db/migration/V202605161600__af_matriz_cuentas_integracion_extendida.sql",
            "db/migration/V202605171700__af_factura_cc_traslado_cntbl.sql"
    };

    private volatile boolean integracionDdlApplied;

    /** Códigos estables para localizar filas sin depender del último PK generado. */
    public static final String CODIGO_SUCURSAL = "AF";
    public static final String CODIGO_CLASE = "FACTORY-AF-CL";
    public static final String CODIGO_SUB_CLASE = "FACTORY-AF-SUB";
    public static final String CODIGO_UBICACION_A = "FACTORY-AF-UBI-A";
    public static final String CODIGO_UBICACION_B = "FACTORY-AF-UBI-B";
    public static final String CODIGO_MAESTRO = "FACTORY-AF-M";
    public static final String CODIGO_MAESTRO_2 = "FACTORY-AF-M2";
    public static final String CODIGO_MAESTRO_3 = "FACTORY-AF-M3";
    public static final String CODIGO_CLASE_UOP = "FACTORY-AF-CL-UOP";
    public static final String CODIGO_SUB_CLASE_UOP = "FACTORY-AF-SUB-UOP";
    public static final String CODIGO_POLIZA = "FACTORY-AF-POL-001";
    public static final String CODIGO_POLIZA_M2 = "FACTORY-AF-POL-002";
    public static final String RUC_ASEGURADORA = "20998887766";
    public static final String CODIGO_CC_1 = "FACTORY-AF-CC1";
    public static final String CODIGO_CC_2 = "FACTORY-AF-CC2";
    public static final String CODIGO_PLAN_CONTABLE = "FACTORY-AF-PLAN";
    public static final String CODIGO_LIBRO = "FACTORY-AF-LIB";
    /** Cuentas PCGE factory (cnta_ctbl) — IDs se resuelven tras ensurePlanContable. */
    public static final String PC_GASTO_DEP = "6811FT";
    public static final String PC_DEP_ACUM = "3911FT";
    public static final String PC_ACTIVO = "3351FT";
    public static final String PC_BAJA = "6711FT";
    public static final String PC_RES_VENTA = "5221FT";
    public static final String PC_PROVEEDOR = "4211FT";
    public static final String PC_CAPITAL = "3311FT";

    /** Filas masivas por tabla activos en dataset bulk (ver {@link ActivosTestDataFactoryBulk}). */
    public static final int BULK_ROWS_PER_TABLE = ActivosTestDataFactoryBulk.BULK_ROWS;

    static final long FACTORY_USER_ID = 1L;

    private final DataSource dataSource;

    /**
     * Ensures the minimal transactional graph required by ms-activos-fijos tests exists.
     *
     * <p>Designed to be called from integration tests (e.g. {@code ActivosTestDataFactorySmokeIT}).</p>
     */
    @Transactional
    public Map<String, Integer> ensureActivosTransactionalData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("core.entidad_contribuyente", ensureEntidadContribuyente(jdbc));
        out.put("auth.sucursal", ensureAuthSucursal(jdbc));
        out.put("activos.af_clase", ensureAfClase(jdbc));

        Long claseId = jdbc.queryForObject(
                "SELECT id FROM activos.af_clase WHERE codigo = ?", Long.class, CODIGO_CLASE);
        out.put("activos.af_sub_clase", ensureAfSubClase(jdbc, claseId));
        Long subId = jdbc.queryForObject(
                "SELECT id FROM activos.af_sub_clase WHERE codigo = ?", Long.class, CODIGO_SUB_CLASE);

        Long sucursalId = resolveSucursalId(jdbc);
        out.put("activos.af_ubicacion", ensureAfUbicaciones(jdbc, sucursalId));
        out.put("contabilidad.centros_costo", ensureCentrosCosto(jdbc));
        out.put("contabilidad.plan_contable", ensurePlanContable(jdbc));
        out.put("contabilidad.cntbl_libro", ensureCntblLibro(jdbc));
        out.put("activos.af_matriz_sub_clase", ensureAfMatriz(jdbc, subId));
        out.put("activos.af_tipo_operacion", ensureAfTiposOperacion(jdbc));

        Long ubiA = jdbc.queryForObject(
                "SELECT id FROM activos.af_ubicacion WHERE sucursal_id = ? AND codigo = ?",
                Long.class, sucursalId, CODIGO_UBICACION_A);
        Long ubiB = jdbc.queryForObject(
                "SELECT id FROM activos.af_ubicacion WHERE sucursal_id = ? AND codigo = ?",
                Long.class, sucursalId, CODIGO_UBICACION_B);

        Long proveedorId = jdbc.query(
                "SELECT id FROM core.entidad_contribuyente WHERE nro_documento = '20123456789' LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);

        out.put("activos.af_maestro", ensureAfMaestro(jdbc, subId, ubiA, proveedorId));
        Long maestroId = jdbc.queryForObject(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?", Long.class, CODIGO_MAESTRO);

        out.put("activos.af_maestro_cc_distrib", ensureMaestroCcDistrib(jdbc, maestroId));

        out.put("activos.af_calculo_cntbl", ensureAfCalculoCntbl(jdbc, maestroId, resolveTipoOperacionId(jdbc, "FACTORY-AF")));
        out.put("activos.af_adaptacion + det + dep", ensureAfAdaptacion(jdbc, maestroId));
        out.put("activos.af_aseguradora + poliza", ensureAfSeguros(jdbc, maestroId));
        out.put("activos.af_traslado", ensureAfTraslado(jdbc, maestroId, ubiA, ubiB));
        out.put("activos.af_traslado_contable", ensureAfTrasladoContableEjecutado(jdbc, maestroId, ubiA, ubiB));
        out.put("activos.af_historial", ensureAfHistorial(jdbc, maestroId));

        Map<String, Integer> extended = ensureActivosExtendedData(
                jdbc, maestroId, subId, sucursalId, ubiA, ubiB, proveedorId);
        extended.forEach(out::put);

        return out;
    }

    /**
     * Dataset ampliado: más activos, períodos de depreciación, valuación, venta, documentos e historial.
     */
    private Map<String, Integer> ensureActivosExtendedData(
            JdbcTemplate jdbc,
            Long maestroPrincipalId,
            Long subClaseLinealId,
            Long sucursalId,
            Long ubiA,
            Long ubiB,
            Long proveedorId) {
        Map<String, Integer> out = new LinkedHashMap<>();
        if (!tableExists(jdbc, "activos", "af_maestro")) {
            return out;
        }

        out.put("activos.af_clase_uop", ensureAfClaseUop(jdbc));
        Long claseUopId = jdbc.query(
                "SELECT id FROM activos.af_clase WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CLASE_UOP);
        int subUop = 0;
        Long subUopId = null;
        if (claseUopId != null) {
            subUop = ensureAfSubClaseWithCodigo(jdbc, claseUopId, CODIGO_SUB_CLASE_UOP, "Subclase factory UOP");
            subUopId = jdbc.query(
                    "SELECT id FROM activos.af_sub_clase WHERE codigo = ?",
                    rs -> rs.next() ? rs.getLong(1) : null,
                    CODIGO_SUB_CLASE_UOP);
            if (subUopId != null) {
                ensureAfMatriz(jdbc, subUopId);
            }
        }
        out.put("activos.af_sub_clase_uop", subUop);

        out.put("activos.af_maestro_extra", ensureMaestrosAdicionales(
                jdbc, subClaseLinealId, subUopId, ubiA, ubiB, proveedorId));
        Long tipoOpDep = resolveTipoOperacionId(jdbc, "FACTORY-AF");
        out.put("activos.af_calculo_cntbl_periodos", ensureAfCalculosMultiPeriodo(jdbc, maestroPrincipalId, tipoOpDep));
        out.put("activos.af_valuacion", ensureAfValuaciones(jdbc, maestroPrincipalId));
        out.put("activos.af_venta", ensureAfVentaFactory(jdbc));
        out.put("activos.af_documento", ensureAfDocumentos(jdbc, maestroPrincipalId));
        out.put("activos.af_historial_eventos", ensureAfHistorialExtendido(jdbc, maestroPrincipalId));
        out.put("activos.af_numeracion_config", ensureAfNumeracionConfig(jdbc));
        out.put("activos.af_prima_devengo_extra", ensurePrimaDevengoExtra(jdbc));
        out.put("activos.af_accesorios", ensureAfAccesorios(jdbc));
        out.put("activos.af_software", ensureAfSoftware(jdbc));
        out.put("activos.af_revaluacion", ensureAfRevaluacionLegacy(jdbc));
        out.put("activos.af_operaciones", ensureAfOperaciones(jdbc));
        out.put("activos.af_adaptacion_extra", ensureAfAdaptacionesAdicionales(jdbc));
        out.put("activos.af_traslado_extra", ensureAfTrasladosAdicionales(jdbc, ubiA, ubiB));
        out.put("activos.af_poliza_m2", ensureAfPolizaSeguroM2(jdbc));
        out.put("activos.af_documento_extra", ensureAfDocumentosAdicionales(jdbc));
        out.put("activos.enriquecimiento_sin_nulos", ensureEnriquecimientoSinNulos(jdbc));

        Map<String, Integer> bulk = ActivosTestDataFactoryBulk.ensureBulkDataset(
                jdbc,
                new ActivosTestDataFactoryBulk.BulkContext(
                        subClaseLinealId, sucursalId, ubiA, ubiB, proveedorId,
                        resolveTipoOperacionId(jdbc, "FACTORY-AF")));
        bulk.forEach(out::put);

        return out;
    }

    /** Cuenta activos con prefijo {@code FACTORY-AF-BULK-}. */
    public int countMaestrosBulkEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_maestro")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_maestro
                WHERE codigo LIKE ? || '%' AND flag_estado = '1'
                """, Integer.class, ActivosTestDataFactoryBulk.PREFIX_MAESTRO);
        return n != null ? n : 0;
    }

    public int countTablaBulkActivos(String tabla) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", tabla)) {
            return 0;
        }
        if ("af_maestro".equals(tabla)) {
            return countMaestrosBulkEnBd();
        }
        if ("af_historial".equals(tabla)) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM activos.af_historial WHERE modulo = 'FACTORY-AF-BULK'",
                    Integer.class);
            return n != null ? n : 0;
        }
        if ("af_poliza_seguro".equals(tabla)) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM activos.af_poliza_seguro WHERE numero_poliza LIKE ? AND flag_estado = '1'",
                    Integer.class, ActivosTestDataFactoryBulk.PREFIX_POLIZA + "%");
            return n != null ? n : 0;
        }
        String codigoPattern = switch (tabla) {
            case "af_clase" -> ActivosTestDataFactoryBulk.PREFIX_CLASE + "%";
            case "af_sub_clase" -> ActivosTestDataFactoryBulk.PREFIX_SUB + "%";
            case "af_ubicacion" -> ActivosTestDataFactoryBulk.PREFIX_UBI + "%";
            default -> null;
        };
        if (codigoPattern != null) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM activos.%s WHERE codigo LIKE ? AND flag_estado = '1'"
                            .formatted(tabla),
                    Integer.class, codigoPattern);
            return n != null ? n : 0;
        }
        Integer joined = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.%s x
                INNER JOIN activos.af_maestro m ON m.id = x.af_maestro_id
                WHERE m.codigo LIKE ? AND x.flag_estado = '1'
                """.formatted(tabla), Integer.class, ActivosTestDataFactoryBulk.PREFIX_MAESTRO + "%");
        return joined != null ? joined : 0;
    }

    /**
     * Aplica migraciones incrementales Flyway del módulo (ADD COLUMN IF NOT EXISTS) en el tenant actual.
     * Idempotente; no sustituye {@code 08-activos.sql} si el esquema activos no existe.
     * Fuera de la transacción del test para no abortar el bloque JDBC del IT.
     */
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void ensureActivosIntegracionDdl() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_maestro")) {
            return;
        }
        if (integracionDdlApplied && isActivosIntegracionDdlComplete(jdbc)) {
            return;
        }
        synchronized (this) {
            jdbc = new JdbcTemplate(dataSource);
            if (integracionDdlApplied && isActivosIntegracionDdlComplete(jdbc)) {
                return;
            }
            ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
            populator.setContinueOnError(true);
            for (String script : INTEGRACION_MIGRATION_SCRIPTS) {
                populator.addScript(new ClassPathResource(script));
            }
            try {
                populator.execute(dataSource);
                log.info("Migraciones integración activos aplicadas en tenant (scripts Flyway ms-activos-fijos)");
            } catch (Exception ex) {
                log.warn("No se pudieron aplicar todas las migraciones de integración activos: {}", ex.getMessage());
            }
            integracionDdlApplied = isActivosIntegracionDdlComplete(new JdbcTemplate(dataSource));
        }
    }

    /**
     * Tablas mínimas del esquema activos (DDL 08-activos) para seed factory / persist.
     */
    public boolean isActivosBaseSchemaReady() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_maestro")
                || !tableExists(jdbc, "activos", "af_calculo_cntbl")
                || !tableExists(jdbc, "activos", "af_clase")) {
            return false;
        }
        try {
            jdbc.queryForObject("SELECT COUNT(*)::int FROM activos.af_maestro", Integer.class);
            return true;
        } catch (DataAccessException ex) {
            return false;
        }
    }

    /**
     * Indica si el tenant tiene tablas/columnas mínimas para IT de contabilidad.
     */
    public boolean isActivosSchemaReady() {
        if (!isActivosBaseSchemaReady()) {
            return false;
        }
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return columnExists(jdbc, "activos", "af_calculo_cntbl", "cntbl_asiento_id")
                && columnExists(jdbc, "activos", "af_maestro", "cntbl_asiento_id");
    }

    public Long resolveMaestroId() {
        return resolveMaestroIdByCodigo(CODIGO_MAESTRO);
    }

    public Long resolveMaestroIdByCodigo(String codigo) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?", Long.class, codigo);
    }

    public Long resolveClaseId() {
        return resolveClaseIdByCodigo(CODIGO_CLASE);
    }

    public Long resolveClaseIdByCodigo(String codigo) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM activos.af_clase WHERE codigo = ?", Long.class, codigo);
    }

    public Long resolveSubClaseId() {
        return resolveSubClaseIdByCodigo(CODIGO_SUB_CLASE);
    }

    public Long resolveSubClaseIdByCodigo(String codigo) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM activos.af_sub_clase WHERE codigo = ?", Long.class, codigo);
    }

    public Long resolveUbicacionId() {
        return resolveUbicacionIdByCodigo(CODIGO_UBICACION_A);
    }

    public Long resolveUbicacionIdByCodigo(String codigoUbicacion) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long sucursalId = resolveSucursalId(jdbc);
        return jdbc.queryForObject(
                "SELECT id FROM activos.af_ubicacion WHERE sucursal_id = ? AND codigo = ?",
                Long.class, sucursalId, codigoUbicacion);
    }

    /** Primer traslado del activo factory (cualquier estado). */
    public Long resolveTrasladoFactoryId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject("""
                SELECT t.id FROM activos.af_traslado t
                INNER JOIN activos.af_maestro m ON m.id = t.af_maestro_id
                WHERE m.codigo = ?
                ORDER BY t.id
                LIMIT 1
                """, Long.class, CODIGO_MAESTRO);
    }

    /** Cálculo con depreciación &gt; 0 del activo factory (para {@code contabilizarDepreciacion}). */
    public Long resolveCalculoDepreciacionContableId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject("""
                SELECT c.id FROM activos.af_calculo_cntbl c
                INNER JOIN activos.af_maestro m ON m.id = c.af_maestro_id
                WHERE m.codigo = ? AND c.depreciacion_periodo > 0
                ORDER BY c.anio DESC, c.mes DESC
                LIMIT 1
                """, Long.class, CODIGO_MAESTRO);
    }

    public boolean hasTrasladoContableEjecutado() {
        if (!tableExists(new JdbcTemplate(dataSource), "activos", "af_traslado")) {
            return false;
        }
        if (!columnExists(new JdbcTemplate(dataSource), "activos", "af_traslado", "centro_costo_origen_id")) {
            return false;
        }
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_traslado t
                INNER JOIN activos.af_maestro m ON m.id = t.af_maestro_id
                WHERE m.codigo = ? AND t.estado = 'EJECUTADO'
                  AND t.centro_costo_origen_id IS NOT NULL
                  AND t.centro_costo_destino_id IS NOT NULL
                  AND t.centro_costo_origen_id <> t.centro_costo_destino_id
                  AND t.motivo = 'Traslado contable factory IT'
                """, Integer.class, CODIGO_MAESTRO);
        return n != null && n > 0;
    }

    /** Cuenta contable (plan_contable_det.id) por código factory. */
    public Long resolvePlanContableDetId(String cntaCtbl) {
        if (!tableExists(new JdbcTemplate(dataSource), "contabilidad", "plan_contable_det")) {
            return null;
        }
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.query(
                """
                        SELECT d.id FROM contabilidad.plan_contable_det d
                        INNER JOIN contabilidad.plan_contable p ON p.id = d.plan_contable_id
                        WHERE p.codigo = ? AND d.cnta_ctbl = ?
                        LIMIT 1
                        """,
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_PLAN_CONTABLE, cntaCtbl);
    }

    public int countCntblAsientoPorOrigen(String moduloOrigen, Long documentoOrigenId) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "contabilidad", "cntbl_asiento")) {
            return 0;
        }
        if (!columnExists(jdbc, "contabilidad", "cntbl_asiento", "documento_origen_id")) {
            Integer n = jdbc.queryForObject("""
                    SELECT COUNT(*)::int FROM contabilidad.cntbl_asiento
                    WHERE modulo_origen = ? AND flag_estado = '1' AND glosa LIKE ?
                    """, Integer.class, moduloOrigen, "%[DOC_ORIGEN_ID=" + documentoOrigenId + "]%");
            return n != null ? n : 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM contabilidad.cntbl_asiento
                WHERE modulo_origen = ? AND documento_origen_id = ? AND flag_estado = '1'
                """, Integer.class, moduloOrigen, documentoOrigenId);
        return n != null ? n : 0;
    }

    /** Filas activas del maestro principal factory en BD. */
    public int countMaestroFactoryEnBd() {
        return countMaestrosFactoryActivosEnBd(CODIGO_MAESTRO);
    }

    /** Todos los activos factory ({@code FACTORY-AF-M*}). */
    public int countMaestrosFactoryActivosEnBd() {
        return countMaestrosFactoryActivosEnBd(null);
    }

    public int countCalculosFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_calculo_cntbl")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_calculo_cntbl c
                INNER JOIN activos.af_maestro m ON m.id = c.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND c.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countValuacionesFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_valuacion")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_valuacion v
                INNER JOIN activos.af_maestro m ON m.id = v.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND v.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countDocumentosFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_documento")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_documento d
                INNER JOIN activos.af_maestro m ON m.id = d.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND d.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countAccesoriosFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_accesorios")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_accesorios a
                INNER JOIN activos.af_maestro m ON m.id = a.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND a.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countOperacionesFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_operaciones")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_operaciones o
                INNER JOIN activos.af_maestro m ON m.id = o.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND o.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countSoftwareFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_software")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_software s
                INNER JOIN activos.af_maestro m ON m.id = s.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND s.flag_estado = '1'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countHistorialFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_historial")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_historial h
                INNER JOIN activos.af_maestro m ON m.id = h.af_maestro_id
                WHERE m.codigo LIKE 'FACTORY-AF-M%' AND h.modulo = 'FACTORY-AF'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countAsientosActivosFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "contabilidad", "cntbl_asiento")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM contabilidad.cntbl_asiento
                WHERE modulo_origen IN ('AF-001', 'AF_TRASLADO')
                  AND flag_estado = '1'
                  AND glosa LIKE '%FACTORY-AF-M%'
                """, Integer.class);
        return n != null ? n : 0;
    }

    private int countMaestrosFactoryActivosEnBd(String codigoExacto) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_maestro")) {
            return 0;
        }
        if (codigoExacto != null) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM activos.af_maestro WHERE codigo = ? AND flag_estado = '1'",
                    Integer.class, codigoExacto);
            return n != null ? n : 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM activos.af_maestro WHERE codigo LIKE 'FACTORY-AF-M%' AND flag_estado = '1'",
                Integer.class);
        return n != null ? n : 0;
    }

    public int countCalculoDepreciacionEnBd(Long calculoId) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_calculo_cntbl")) {
            return 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM activos.af_calculo_cntbl WHERE id = ? AND depreciacion_periodo > 0",
                Integer.class, calculoId);
        return n != null ? n : 0;
    }

    public int countMatrizConCuentasDepreciacion() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_matriz_sub_clase")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM activos.af_matriz_sub_clase m
                INNER JOIN activos.af_sub_clase s ON s.id = m.af_sub_clase_id
                WHERE s.codigo = ? AND m.cuenta_gasto_dep_id IS NOT NULL AND m.cuenta_dep_acum_id IS NOT NULL
                """, Integer.class, CODIGO_SUB_CLASE);
        return n != null ? n : 0;
    }

    public int countTrasladoEjecutadoEnBd(Long trasladoId) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "activos", "af_traslado")) {
            return 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM activos.af_traslado WHERE id = ? AND estado = 'EJECUTADO'",
                Integer.class, trasladoId);
        return n != null ? n : 0;
    }

    public int countPlanContableFactoryEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "contabilidad", "plan_contable")) {
            return 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM contabilidad.plan_contable WHERE codigo = ?",
                Integer.class, CODIGO_PLAN_CONTABLE);
        return n != null ? n : 0;
    }

    /**
     * Deja el cálculo factory listo para IT de depreciación (sin vínculo ni asientos activos previos).
     */
    @Transactional
    public void resetDepreciacionContableFactoryState() {
        if (!isActivosSchemaReady()) {
            return;
        }
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long calculoId = resolveCalculoDepreciacionContableId();
        jdbc.update("UPDATE activos.af_calculo_cntbl SET cntbl_asiento_id = NULL WHERE id = ?", calculoId);
        if (tableExists(jdbc, "contabilidad", "cntbl_asiento")
                && columnExists(jdbc, "contabilidad", "cntbl_asiento", "documento_origen_id")) {
            jdbc.update("""
                    UPDATE contabilidad.cntbl_asiento SET flag_estado = '0'
                    WHERE modulo_origen = ? AND documento_origen_id = ?
                    """, AfIntegracionContableModulo.MODULO, calculoId);
        }
    }

    /**
     * Deja el traslado factory EJECUTADO listo para IT de traslado contable.
     */
    @Transactional
    public void resetTrasladoContableFactoryState() {
        if (!hasTrasladoContableEjecutado()) {
            return;
        }
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long trasladoId = resolveTrasladoEjecutadoContableId();
        if (columnExists(jdbc, "activos", "af_traslado", "cntbl_asiento_id")) {
            jdbc.update("UPDATE activos.af_traslado SET cntbl_asiento_id = NULL WHERE id = ?", trasladoId);
        }
        if (tableExists(jdbc, "contabilidad", "cntbl_asiento")
                && columnExists(jdbc, "contabilidad", "cntbl_asiento", "documento_origen_id")) {
            jdbc.update("""
                    UPDATE contabilidad.cntbl_asiento SET flag_estado = '0'
                    WHERE modulo_origen = ? AND documento_origen_id = ?
                    """, AfIntegracionContableModulo.MODULO, trasladoId);
        }
    }

    public Long resolveTrasladoEjecutadoContableId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject("""
                SELECT t.id FROM activos.af_traslado t
                INNER JOIN activos.af_maestro m ON m.id = t.af_maestro_id
                WHERE m.codigo = ? AND t.estado = 'EJECUTADO'
                  AND t.motivo = 'Traslado contable factory IT'
                ORDER BY t.id DESC
                LIMIT 1
                """, Long.class, CODIGO_MAESTRO);
    }

    private static Long resolveSucursalId(JdbcTemplate jdbc) {
        Long id = jdbc.query(
                "SELECT id FROM auth.sucursal WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_SUCURSAL);
        if (id != null) {
            return id;
        }
        return jdbc.queryForObject("SELECT id FROM auth.sucursal ORDER BY id LIMIT 1", Long.class);
    }

    private static int ensureEntidadContribuyente(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "entidad_contribuyente")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO core.entidad_contribuyente (
                    id, tipo_persona, tipo_documento, nro_documento, razon_social,
                    es_proveedor, es_cliente, es_empleado, flag_estado
                ) VALUES
                (1, 'JURIDICA', 'RUC', '20123456789', 'PROVEEDOR FACTORY AF S.A.C.', TRUE, FALSE, FALSE, '1')
                ON CONFLICT (id) DO UPDATE SET
                    razon_social = EXCLUDED.razon_social,
                    es_proveedor = EXCLUDED.es_proveedor,
                    flag_estado = EXCLUDED.flag_estado
                """);
    }

    private static int ensureAuthSucursal(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "auth", "sucursal")) {
            jdbc.execute("CREATE SCHEMA IF NOT EXISTS auth");
            jdbc.execute("""
                    CREATE TABLE IF NOT EXISTS auth.sucursal (
                        id BIGSERIAL PRIMARY KEY,
                        codigo VARCHAR(2) NOT NULL,
                        nombre VARCHAR(150) NOT NULL,
                        flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
                        UNIQUE (codigo)
                    )
                    """);
        }
        return jdbc.update("""
                INSERT INTO auth.sucursal (codigo, nombre, flag_estado)
                VALUES (?, 'Sucursal factory activos', '1')
                ON CONFLICT (codigo) DO NOTHING
                """, CODIGO_SUCURSAL);
    }

    private static int ensureAfClase(JdbcTemplate jdbc) {
        if (columnExists(jdbc, "activos", "af_clase", "created_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado, created_by)
                    VALUES (?, 'Clase factory test LINEAL', 'LINEAL', 120, '1', ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, metodo_depreciacion = EXCLUDED.metodo_depreciacion
                    """, CODIGO_CLASE, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado)
                VALUES (?, 'Clase factory test LINEAL', 'LINEAL', 120, '1')
                ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, metodo_depreciacion = EXCLUDED.metodo_depreciacion
                """, CODIGO_CLASE);
    }

    private static int ensureAfSubClase(JdbcTemplate jdbc, Long claseId) {
        if (columnExists(jdbc, "activos", "af_sub_clase", "created_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado, created_by)
                    VALUES (?, ?, 'Subclase factory test LINEAL', 120, '1', ?)
                    ON CONFLICT (af_clase_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, vida_util_meses = EXCLUDED.vida_util_meses
                    """, claseId, CODIGO_SUB_CLASE, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado)
                VALUES (?, ?, 'Subclase factory test LINEAL', 120, '1')
                ON CONFLICT (af_clase_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, vida_util_meses = EXCLUDED.vida_util_meses
                """, claseId, CODIGO_SUB_CLASE);
    }

    private static int ensureAfUbicaciones(JdbcTemplate jdbc, Long sucursalId) {
        if (columnExists(jdbc, "activos", "af_ubicacion", "created_by")) {
            int a = jdbc.update("""
                    INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, ?, 'Ubicación factory almacén central', '1', ?, ?)
                    ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, updated_by = EXCLUDED.updated_by
                    """, sucursalId, CODIGO_UBICACION_A, FACTORY_USER_ID, FACTORY_USER_ID);
            int b = jdbc.update("""
                    INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, ?, 'Ubicación factory planta norte', '1', ?, ?)
                    ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, updated_by = EXCLUDED.updated_by
                    """, sucursalId, CODIGO_UBICACION_B, FACTORY_USER_ID, FACTORY_USER_ID);
            return a + b;
        }
        int a = jdbc.update("""
                INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado)
                VALUES (?, ?, 'Ubicación factory almacén central', '1')
                ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, sucursalId, CODIGO_UBICACION_A);
        int b = jdbc.update("""
                INSERT INTO activos.af_ubicacion (sucursal_id, codigo, nombre, flag_estado)
                VALUES (?, ?, 'Ubicación factory planta norte', '1')
                ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, sucursalId, CODIGO_UBICACION_B);
        return a + b;
    }

    private int ensureAfMatriz(JdbcTemplate jdbc, Long subClaseId) {
        if (!tableExists(jdbc, "activos", "af_matriz_sub_clase")) {
            return 0;
        }
        Long ccId = jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CC_1);
        Long gastoDep = resolvePlanDetId(jdbc, PC_GASTO_DEP);
        Long depAcum = resolvePlanDetId(jdbc, PC_DEP_ACUM);
        Long activo = resolvePlanDetId(jdbc, PC_ACTIVO);
        Long baja = resolvePlanDetId(jdbc, PC_BAJA);
        Long resVenta = resolvePlanDetId(jdbc, PC_RES_VENTA);
        Long proveedor = resolvePlanDetId(jdbc, PC_PROVEEDOR);
        Long capital = resolvePlanDetId(jdbc, PC_CAPITAL);

        boolean ext = columnExists(jdbc, "activos", "af_matriz_sub_clase", "cuenta_proveedor_transitoria_id");
        if (ext && gastoDep != null && depAcum != null && activo != null) {
            return jdbc.update("""
                    INSERT INTO activos.af_matriz_sub_clase (
                        af_sub_clase_id, cuenta_activo_id, cuenta_dep_acum_id, cuenta_gasto_dep_id,
                        cuenta_baja_id, cuenta_res_venta_id, centro_costo_id,
                        cuenta_proveedor_transitoria_id, cuenta_capitalizacion_id, flag_estado)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, '1')
                    ON CONFLICT (af_sub_clase_id) DO UPDATE SET
                        cuenta_activo_id = EXCLUDED.cuenta_activo_id,
                        cuenta_dep_acum_id = EXCLUDED.cuenta_dep_acum_id,
                        cuenta_gasto_dep_id = EXCLUDED.cuenta_gasto_dep_id,
                        cuenta_baja_id = EXCLUDED.cuenta_baja_id,
                        cuenta_res_venta_id = EXCLUDED.cuenta_res_venta_id,
                        centro_costo_id = EXCLUDED.centro_costo_id,
                        cuenta_proveedor_transitoria_id = EXCLUDED.cuenta_proveedor_transitoria_id,
                        cuenta_capitalizacion_id = EXCLUDED.cuenta_capitalizacion_id
                    """, subClaseId, activo, depAcum, gastoDep, baja, resVenta, ccId, proveedor, capital);
        }
        if (gastoDep != null && depAcum != null && activo != null) {
            return jdbc.update("""
                    INSERT INTO activos.af_matriz_sub_clase (
                        af_sub_clase_id, cuenta_activo_id, cuenta_dep_acum_id, cuenta_gasto_dep_id,
                        cuenta_baja_id, cuenta_res_venta_id, centro_costo_id, flag_estado)
                    VALUES (?, ?, ?, ?, ?, ?, ?, '1')
                    ON CONFLICT (af_sub_clase_id) DO UPDATE SET
                        cuenta_activo_id = EXCLUDED.cuenta_activo_id,
                        cuenta_dep_acum_id = EXCLUDED.cuenta_dep_acum_id,
                        cuenta_gasto_dep_id = EXCLUDED.cuenta_gasto_dep_id,
                        cuenta_baja_id = EXCLUDED.cuenta_baja_id,
                        cuenta_res_venta_id = EXCLUDED.cuenta_res_venta_id,
                        centro_costo_id = EXCLUDED.centro_costo_id
                    """, subClaseId, activo, depAcum, gastoDep, baja, resVenta, ccId);
        }
        return jdbc.update("""
                INSERT INTO activos.af_matriz_sub_clase (af_sub_clase_id, cuenta_activo_id, cuenta_dep_acum_id,
                    cuenta_gasto_dep_id, cuenta_baja_id, cuenta_res_venta_id, centro_costo_id, flag_estado)
                VALUES (?, NULL, NULL, NULL, NULL, NULL, ?, '1')
                ON CONFLICT (af_sub_clase_id) DO NOTHING
                """, subClaseId, ccId);
    }

    private static Long resolvePlanDetId(JdbcTemplate jdbc, String cntaCtbl) {
        if (!tableExists(jdbc, "contabilidad", "plan_contable_det")) {
            return null;
        }
        return jdbc.query(
                """
                        SELECT d.id FROM contabilidad.plan_contable_det d
                        INNER JOIN contabilidad.plan_contable p ON p.id = d.plan_contable_id
                        WHERE p.codigo = ? AND d.cnta_ctbl = ?
                        LIMIT 1
                        """,
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_PLAN_CONTABLE, cntaCtbl);
    }

    private static int ensurePlanContable(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "contabilidad", "plan_contable")) {
            return 0;
        }
        jdbc.update("""
                INSERT INTO contabilidad.plan_contable (codigo, nombre, anio, effective_from, flag_estado)
                VALUES (?, 'Plan factory activos fijos', 2026, DATE '2026-01-01', '1')
                ON CONFLICT (codigo) DO NOTHING
                """, CODIGO_PLAN_CONTABLE);
        Long planId = jdbc.queryForObject(
                "SELECT id FROM contabilidad.plan_contable WHERE codigo = ?", Long.class, CODIGO_PLAN_CONTABLE);
        int rows = 0;
        rows += upsertPlanDet(jdbc, planId, PC_GASTO_DEP, "Gasto depreciación factory");
        rows += upsertPlanDet(jdbc, planId, PC_DEP_ACUM, "Depreciación acumulada factory");
        rows += upsertPlanDet(jdbc, planId, PC_ACTIVO, "Activo fijo factory");
        rows += upsertPlanDet(jdbc, planId, PC_BAJA, "Pérdida baja factory");
        rows += upsertPlanDet(jdbc, planId, PC_RES_VENTA, "Reserva revaluación factory");
        rows += upsertPlanDet(jdbc, planId, PC_PROVEEDOR, "Proveedor transitorio factory");
        rows += upsertPlanDet(jdbc, planId, PC_CAPITAL, "Capitalización factory");
        return rows;
    }

    private static int upsertPlanDet(JdbcTemplate jdbc, Long planId, String cnta, String desc) {
        return jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (
                    plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, flag_permite_mov, flag_estado)
                VALUES (?, ?, ?, 5, '1', '1')
                ON CONFLICT (plan_contable_id, cnta_ctbl) DO UPDATE SET desc_cnta = EXCLUDED.desc_cnta
                """, planId, cnta, desc);
    }

    private static int ensureCntblLibro(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "contabilidad", "cntbl_libro")) {
            return 0;
        }
        Integer exists = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM contabilidad.cntbl_libro WHERE id = 1", Integer.class);
        if (exists != null && exists > 0) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO contabilidad.cntbl_libro (id, codigo, nombre, tipo)
                VALUES (1, ?, 'Libro factory activos', 'DIARIO')
                ON CONFLICT (id) DO UPDATE SET codigo = EXCLUDED.codigo, nombre = EXCLUDED.nombre
                """, CODIGO_LIBRO);
    }

    public Long resolveLibroId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "contabilidad", "cntbl_libro")) {
            return 1L;
        }
        Long byId = jdbc.query("SELECT id FROM contabilidad.cntbl_libro WHERE id = 1",
                rs -> rs.next() ? rs.getLong(1) : null);
        if (byId != null) {
            return byId;
        }
        return jdbc.query(
                "SELECT id FROM contabilidad.cntbl_libro WHERE codigo = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_LIBRO);
    }

    private int ensureAfMaestro(JdbcTemplate jdbc, Long subId, Long ubiId, Long proveedorId) {
        boolean conUnidades = columnExists(jdbc, "activos", "af_maestro", "unidades_produccion_totales");
        boolean conEstadoActivo = columnExists(jdbc, "activos", "af_maestro", "estado_activo");

        if (conUnidades && conEstadoActivo) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado,
                        unidades_produccion_totales, unidades_produccion_periodo, created_by)
                    VALUES (?, 'Activo factory test', ?, ?, DATE '2023-01-15', 12000.0000, 1000.0000, ?, 'ACTIVO', '1',
                        NULL, NULL, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, af_ubicacion_id = EXCLUDED.af_ubicacion_id
                    """, CODIGO_MAESTRO, subId, ubiId, proveedorId, FACTORY_USER_ID);
        }
        if (conEstadoActivo) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado, created_by)
                    VALUES (?, 'Activo factory test', ?, ?, DATE '2023-01-15', 12000.0000, 1000.0000, ?, 'ACTIVO', '1', ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, af_ubicacion_id = EXCLUDED.af_ubicacion_id
                    """, CODIGO_MAESTRO, subId, ubiId, proveedorId, FACTORY_USER_ID);
        }
        if (conUnidades) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, flag_estado,
                        unidades_produccion_totales, unidades_produccion_periodo, created_by)
                    VALUES (?, 'Activo factory test', ?, ?, DATE '2023-01-15', 12000.0000, 1000.0000, ?, '1', NULL, NULL, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, CODIGO_MAESTRO, subId, ubiId, proveedorId, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                    valor_adquisicion, valor_residual, proveedor_id, flag_estado, created_by)
                VALUES (?, 'Activo factory test', ?, ?, DATE '2023-01-15', 12000.0000, 1000.0000, ?, '1', ?)
                ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, CODIGO_MAESTRO, subId, ubiId, proveedorId, FACTORY_USER_ID);
    }

    private static int ensureCentrosCosto(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "contabilidad", "centros_costo")) {
            return 0;
        }
        int c1 = jdbc.update("""
                INSERT INTO contabilidad.centros_costo (cencos, desc_cencos, flag_estado)
                VALUES (?, 'CC factory activos 1', '1')
                ON CONFLICT (cencos) DO NOTHING
                """, CODIGO_CC_1);
        int c2 = jdbc.update("""
                INSERT INTO contabilidad.centros_costo (cencos, desc_cencos, flag_estado)
                VALUES (?, 'CC factory activos 2', '1')
                ON CONFLICT (cencos) DO NOTHING
                """, CODIGO_CC_2);
        return c1 + c2;
    }

    private static int ensureMaestroCcDistrib(JdbcTemplate jdbc, Long maestroId) {
        if (!tableExists(jdbc, "activos", "af_maestro_cc_distrib")
                || !tableExists(jdbc, "contabilidad", "centros_costo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_maestro_cc_distrib (af_maestro_id, centro_costo_id, porcentaje, created_by)
                SELECT ?, cc.id, v.pct, ?
                FROM (VALUES (?::varchar, 70.0000), (?::varchar, 30.0000)) AS v(cencos, pct)
                JOIN contabilidad.centros_costo cc ON cc.cencos = v.cencos
                ON CONFLICT (af_maestro_id, centro_costo_id) DO UPDATE SET porcentaje = EXCLUDED.porcentaje
                """, maestroId, FACTORY_USER_ID, CODIGO_CC_1, CODIGO_CC_2);
    }

    private static int ensureAfCalculoCntbl(JdbcTemplate jdbc, Long maestroId, Long tipoOperacionId) {
        if (!tableExists(jdbc, "activos", "af_calculo_cntbl")) {
            return 0;
        }
        boolean conUpdatedBy = columnExists(jdbc, "activos", "af_calculo_cntbl", "updated_by");
        if (columnExists(jdbc, "activos", "af_calculo_cntbl", "af_tipo_operacion_id") && tipoOperacionId != null) {
            if (conUpdatedBy) {
                return jdbc.update("""
                        INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                            depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                        VALUES (?, ?, 2025, 1, 91.6667, 91.6667, 10908.3333, '1', ?, ?)
                        ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                        """, maestroId, tipoOperacionId, FACTORY_USER_ID, FACTORY_USER_ID);
            }
            return jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                        depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by)
                    VALUES (?, ?, 2025, 1, 91.6667, 91.6667, 10908.3333, '1', ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, tipoOperacionId, FACTORY_USER_ID);
        }
        if (conUpdatedBy) {
            return jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                        depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                    VALUES (?, 2025, 1, 91.6667, 91.6667, 10908.3333, '1', ?, ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                    depreciacion_acumulada, valor_neto, flag_estado, created_by)
                VALUES (?, 2025, 1, 91.6667, 91.6667, 10908.3333, '1', ?)
                ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                """, maestroId, FACTORY_USER_ID);
    }

    private static int ensureAfAdaptacion(JdbcTemplate jdbc, Long maestroId) {
        if (!tableExists(jdbc, "activos", "af_adaptacion")) {
            return 0;
        }
        boolean conEstado = columnExists(jdbc, "activos", "af_adaptacion", "estado");
        Long adaptId = jdbc.query(
                """
                        SELECT id FROM activos.af_adaptacion
                        WHERE af_maestro_id = ? AND descripcion = 'Adaptación factory test'
                        LIMIT 1
                        """,
                rs -> rs.next() ? rs.getLong(1) : null,
                maestroId);

        int cab;
        if (adaptId == null) {
            if (conEstado) {
                cab = jdbc.update("""
                        INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, estado,
                            flag_estado, created_by)
                        VALUES (?, DATE '2025-03-01', 'Adaptación factory test', 500.0000, 'REGISTRADO', '1', ?)
                        """, maestroId, FACTORY_USER_ID);
            } else {
                cab = jdbc.update("""
                        INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, flag_estado, created_by)
                        VALUES (?, DATE '2025-03-01', 'Adaptación factory test', 500.0000, '1', ?)
                        """, maestroId, FACTORY_USER_ID);
            }
            adaptId = jdbc.queryForObject("""
                    SELECT id FROM activos.af_adaptacion
                    WHERE af_maestro_id = ? AND descripcion = 'Adaptación factory test'
                    ORDER BY id DESC LIMIT 1
                    """, Long.class, maestroId);
        } else {
            cab = 0;
        }

        int det = 0;
        int dep = 0;
        if (tableExists(jdbc, "activos", "af_adaptacion_det")) {
            Long unidadId = resolveUnidadMedidaId(jdbc);
            if (unidadId != null && columnExists(jdbc, "activos", "af_adaptacion_det", "unidad_medida_id")) {
                if (columnExists(jdbc, "activos", "af_adaptacion_det", "updated_by")) {
                    det = jdbc.update("""
                            INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, unidad_medida_id,
                                flag_estado, created_by, updated_by)
                            SELECT ?, 'Detalle adaptación mano de obra', 300.0000, ?, '1', ?, ?
                            WHERE NOT EXISTS (
                                SELECT 1 FROM activos.af_adaptacion_det d
                                WHERE d.af_adaptacion_id = ? AND d.descripcion = 'Detalle adaptación mano de obra'
                            )
                            """, adaptId, unidadId, FACTORY_USER_ID, FACTORY_USER_ID, adaptId);
                    det += jdbc.update("""
                            INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, flag_estado, created_by, updated_by)
                            SELECT ?, 'Detalle adaptación materiales', 200.0000, '1', ?, ?
                            WHERE NOT EXISTS (
                                SELECT 1 FROM activos.af_adaptacion_det d
                                WHERE d.af_adaptacion_id = ? AND d.descripcion = 'Detalle adaptación materiales'
                            )
                            """, adaptId, FACTORY_USER_ID, FACTORY_USER_ID, adaptId);
                } else {
                    det = jdbc.update("""
                            INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, unidad_medida_id, flag_estado, created_by)
                            SELECT ?, 'Detalle adaptación mano de obra', 300.0000, ?, '1', ?
                            WHERE NOT EXISTS (
                                SELECT 1 FROM activos.af_adaptacion_det d
                                WHERE d.af_adaptacion_id = ? AND d.descripcion = 'Detalle adaptación mano de obra'
                            )
                            """, adaptId, unidadId, FACTORY_USER_ID, adaptId);
                    det += jdbc.update("""
                            INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, flag_estado, created_by)
                            SELECT ?, 'Detalle adaptación materiales', 200.0000, '1', ?
                            WHERE NOT EXISTS (
                                SELECT 1 FROM activos.af_adaptacion_det d
                                WHERE d.af_adaptacion_id = ? AND d.descripcion = 'Detalle adaptación materiales'
                            )
                            """, adaptId, FACTORY_USER_ID, adaptId);
                }
            } else {
                det = jdbc.update("""
                        INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, flag_estado, created_by, updated_by)
                        SELECT ?, 'Detalle factory test', 500.0000, '1', ?, ?
                        WHERE NOT EXISTS (
                            SELECT 1 FROM activos.af_adaptacion_det d
                            WHERE d.af_adaptacion_id = ? AND d.descripcion = 'Detalle factory test'
                        )
                        """, adaptId, FACTORY_USER_ID, FACTORY_USER_ID, adaptId);
            }
        }
        if (tableExists(jdbc, "activos", "af_adaptacion_dep")) {
            dep = jdbc.update("""
                    INSERT INTO activos.af_adaptacion_dep (af_adaptacion_id, anio, mes, depreciacion_periodo,
                        depreciacion_acumulada, flag_estado, created_by)
                    VALUES (?, 2025, 3, 10.0000, 10.0000, '1', ?)
                    ON CONFLICT (af_adaptacion_id, anio, mes) DO NOTHING
                    """, adaptId, FACTORY_USER_ID);
        }
        return cab + det + dep;
    }

    private static int ensureAfSeguros(JdbcTemplate jdbc, Long maestroId) {
        if (!tableExists(jdbc, "activos", "af_aseguradora")) {
            return 0;
        }
        Long asegId = jdbc.query(
                "SELECT id FROM activos.af_aseguradora WHERE ruc = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                RUC_ASEGURADORA);
        int asegRows = 0;
        if (asegId == null) {
            asegRows = jdbc.update("""
                    INSERT INTO activos.af_aseguradora (nombre, ruc, contacto, flag_estado, created_by)
                    VALUES ('Aseguradora factory AF', ?, 'contacto@factory.test', '1', ?)
                    """, RUC_ASEGURADORA, FACTORY_USER_ID);
            asegId = jdbc.queryForObject(
                    "SELECT id FROM activos.af_aseguradora WHERE ruc = ?", Long.class, RUC_ASEGURADORA);
        }

        int pol = jdbc.update("""
                INSERT INTO activos.af_poliza_seguro (af_aseguradora_id, numero_poliza, fecha_inicio, fecha_fin,
                    prima, cobertura, flag_estado, created_by)
                VALUES (?, ?, DATE '2025-01-01', DATE '2026-12-31', 600.0000, 12000.0000, '1', ?)
                ON CONFLICT (numero_poliza) DO NOTHING
                """, asegId, CODIGO_POLIZA, FACTORY_USER_ID);

        Long polizaId = jdbc.queryForObject(
                "SELECT id FROM activos.af_poliza_seguro WHERE numero_poliza = ?", Long.class, CODIGO_POLIZA);

        int polAct = 0;
        if (tableExists(jdbc, "activos", "af_poliza_activo")) {
            polAct = jdbc.update("""
                    INSERT INTO activos.af_poliza_activo (af_poliza_seguro_id, af_maestro_id, valor_asegurado, flag_estado, created_by)
                    SELECT ?, ?, 11000.0000, '1', ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_poliza_activo pa
                        WHERE pa.af_poliza_seguro_id = ? AND pa.af_maestro_id = ?
                    )
                    """, polizaId, maestroId, FACTORY_USER_ID, polizaId, maestroId);
        }

        int devengo = 0;
        if (tableExists(jdbc, "activos", "af_prima_devengo")) {
            devengo = jdbc.update("""
                    INSERT INTO activos.af_prima_devengo (af_poliza_seguro_id, anio, mes, importe_devengado,
                        meses_vigencia_poliza, flag_estado, created_by)
                    VALUES (?, 2025, 6, 25.0000, 24, '1', ?)
                    ON CONFLICT (af_poliza_seguro_id, anio, mes) DO NOTHING
                    """, polizaId, FACTORY_USER_ID);
        }
        return asegRows + pol + polAct + devengo;
    }

    private static int ensureAfTrasladoContableEjecutado(JdbcTemplate jdbc, Long maestroId, Long ubiOrigen, Long ubiDestino) {
        if (!tableExists(jdbc, "activos", "af_traslado")
                || !columnExists(jdbc, "activos", "af_traslado", "estado")
                || !columnExists(jdbc, "activos", "af_traslado", "centro_costo_origen_id")
                || !tableExists(jdbc, "contabilidad", "centros_costo")) {
            return 0;
        }
        Long cc1 = jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CC_1);
        Long cc2 = jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CC_2);
        if (cc1 == null || cc2 == null || cc1.equals(cc2)) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                    solicitante_id, fecha_solicitud, fecha_ejecucion, motivo, estado,
                    centro_costo_origen_id, centro_costo_destino_id, flag_estado, created_by)
                SELECT ?, ?, ?, ?, DATE '2025-06-01', DATE '2025-06-02',
                    'Traslado contable factory IT', 'EJECUTADO', ?, ?, '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_traslado t
                    WHERE t.af_maestro_id = ? AND t.motivo = 'Traslado contable factory IT'
                )
                """, maestroId, ubiOrigen, ubiDestino, FACTORY_USER_ID, cc1, cc2, FACTORY_USER_ID, maestroId);
    }

    private static int ensureAfTraslado(JdbcTemplate jdbc, Long maestroId, Long ubiOrigen, Long ubiDestino) {
        if (!tableExists(jdbc, "activos", "af_traslado")) {
            return 0;
        }
        boolean conEstado = columnExists(jdbc, "activos", "af_traslado", "estado");
        if (conEstado) {
            return jdbc.update("""
                    INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                        solicitante_id, fecha_solicitud, motivo, estado, flag_estado, created_by)
                    SELECT ?, ?, ?, ?, DATE '2025-04-01', 'Traslado factory test', 'SOLICITUD', '1', ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_traslado t
                        WHERE t.af_maestro_id = ? AND t.motivo = 'Traslado factory test'
                    )
                    """, maestroId, ubiOrigen, ubiDestino, FACTORY_USER_ID, FACTORY_USER_ID, maestroId);
        }
        return jdbc.update("""
                INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                    solicitante_id, fecha_solicitud, motivo, flag_estado, created_by)
                SELECT ?, ?, ?, ?, DATE '2025-04-01', 'Traslado factory test', '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_traslado t
                    WHERE t.af_maestro_id = ? AND t.motivo = 'Traslado factory test'
                )
                """, maestroId, ubiOrigen, ubiDestino, FACTORY_USER_ID, FACTORY_USER_ID, maestroId);
    }

    private static int ensureAfHistorial(JdbcTemplate jdbc, Long maestroId) {
        if (!tableExists(jdbc, "activos", "af_historial")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, usuario_id,
                    fecha_evento, ip_origen, modulo, flag_estado, created_by)
                SELECT ?, 'ALTA', 'Historial factory test', ?, ?, '127.0.0.1', 'FACTORY-AF', '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_historial h
                    WHERE h.af_maestro_id = ? AND h.modulo = 'FACTORY-AF' AND h.tipo_evento = 'ALTA'
                )
                """, maestroId, FACTORY_USER_ID, LocalDateTime.now(), FACTORY_USER_ID, maestroId);
    }

    private static int ensureAfClaseUop(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO activos.af_clase (codigo, nombre, metodo_depreciacion, vida_util_meses, flag_estado)
                VALUES (?, 'Clase factory UOP', 'UNIDADES_PRODUCIDAS', 120, '1')
                ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, CODIGO_CLASE_UOP);
    }

    private static int ensureAfSubClaseWithCodigo(
            JdbcTemplate jdbc, Long claseId, String codigo, String nombre) {
        return jdbc.update("""
                INSERT INTO activos.af_sub_clase (af_clase_id, codigo, nombre, vida_util_meses, flag_estado)
                VALUES (?, ?, ?, 120, '1')
                ON CONFLICT (af_clase_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, claseId, codigo, nombre);
    }

    private static int ensureMaestrosAdicionales(
            JdbcTemplate jdbc,
            Long subLinealId,
            Long subUopId,
            Long ubiA,
            Long ubiB,
            Long proveedorId) {
        int rows = 0;
        if (subLinealId != null) {
            rows += insertMaestroFactory(jdbc, CODIGO_MAESTRO_2, "Activo factory M2 equipos",
                    subLinealId, ubiB, proveedorId, "2024-06-01", "18500.0000", null, null);
            Long m2Id = resolveMaestroIdByCodigo(jdbc, CODIGO_MAESTRO_2);
            rows += ensureAfCalculosMultiPeriodo(jdbc, m2Id, resolveTipoOperacionId(jdbc, "FACTORY-AF"));
            rows += ensureMaestroCcDistribFor(jdbc, m2Id);
        }
        if (subUopId != null) {
            rows += insertMaestroFactory(jdbc, CODIGO_MAESTRO_3, "Activo factory M3 UOP",
                    subUopId, ubiA, proveedorId, "2024-03-15", "22000.0000", 50000, 1200);
            rows += ensureAfCalculosMultiPeriodo(jdbc, resolveMaestroIdByCodigo(jdbc, CODIGO_MAESTRO_3),
                    resolveTipoOperacionId(jdbc, "FACTORY-UO"));
        }
        return rows;
    }

    private static Long resolveMaestroIdByCodigo(JdbcTemplate jdbc, String codigo) {
        return jdbc.queryForObject(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?", Long.class, codigo);
    }

    private static int insertMaestroFactory(
            JdbcTemplate jdbc,
            String codigo,
            String nombre,
            Long subId,
            Long ubiId,
            Long proveedorId,
            String fechaAdq,
            String valorAdq,
            Integer uopTotal,
            Integer uopPeriodo) {
        boolean conUnidades = columnExists(jdbc, "activos", "af_maestro", "unidades_produccion_totales");
        boolean conEstadoActivo = columnExists(jdbc, "activos", "af_maestro", "estado_activo");
        if (conUnidades && conEstadoActivo && uopTotal != null) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado,
                        unidades_produccion_totales, unidades_produccion_periodo, created_by)
                    VALUES (?, ?, ?, ?, CAST(? AS DATE), CAST(? AS NUMERIC), 500.0000, ?, 'ACTIVO', '1', ?, ?, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, codigo, nombre, subId, ubiId, fechaAdq, valorAdq, proveedorId, uopTotal, uopPeriodo, FACTORY_USER_ID);
        }
        if (conEstadoActivo) {
            return jdbc.update("""
                    INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                        valor_adquisicion, valor_residual, proveedor_id, estado_activo, flag_estado, created_by)
                    VALUES (?, ?, ?, ?, CAST(? AS DATE), CAST(? AS NUMERIC), 500.0000, ?, 'ACTIVO', '1', ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, codigo, nombre, subId, ubiId, fechaAdq, valorAdq, proveedorId, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO activos.af_maestro (codigo, nombre, af_sub_clase_id, af_ubicacion_id, fecha_adquisicion,
                    valor_adquisicion, valor_residual, proveedor_id, flag_estado, created_by)
                VALUES (?, ?, ?, ?, CAST(? AS DATE), CAST(? AS NUMERIC), 500.0000, ?, '1', ?)
                ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, codigo, nombre, subId, ubiId, fechaAdq, valorAdq, proveedorId, FACTORY_USER_ID);
    }

    private static int ensureMaestroCcDistribFor(JdbcTemplate jdbc, Long maestroId) {
        if (maestroId == null) {
            return 0;
        }
        return ensureMaestroCcDistrib(jdbc, maestroId);
    }

    private static int ensureAfCalculosMultiPeriodo(JdbcTemplate jdbc, Long maestroId, Long tipoOperacionId) {
        if (maestroId == null || !tableExists(jdbc, "activos", "af_calculo_cntbl")) {
            return 0;
        }
        boolean conTipoOp = columnExists(jdbc, "activos", "af_calculo_cntbl", "af_tipo_operacion_id")
                && tipoOperacionId != null;
        boolean conUpdatedBy = columnExists(jdbc, "activos", "af_calculo_cntbl", "updated_by");
        int rows = 0;
        for (int mes = 2; mes <= 12; mes++) {
            if (conTipoOp && conUpdatedBy) {
                rows += jdbc.update("""
                        INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                            depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                        VALUES (?, ?, 2025, ?, 91.6667, 1000.0000, 11000.0000, '1', ?, ?)
                        ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                        """, maestroId, tipoOperacionId, mes, FACTORY_USER_ID, FACTORY_USER_ID);
            } else if (conTipoOp) {
                rows += jdbc.update("""
                        INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                            depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by)
                        VALUES (?, ?, 2025, ?, 91.6667, 1000.0000, 11000.0000, '1', ?)
                        ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                        """, maestroId, tipoOperacionId, mes, FACTORY_USER_ID);
            } else {
                rows += jdbc.update("""
                        INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                            depreciacion_acumulada, valor_neto, flag_estado, created_by)
                        VALUES (?, 2025, ?, 91.6667, 1000.0000, 11000.0000, '1', ?)
                        ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                        """, maestroId, mes, FACTORY_USER_ID);
            }
        }
        if (conTipoOp && conUpdatedBy) {
            rows += jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                        depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                    VALUES (?, ?, 2026, 2, 91.6667, 100.0000, 11900.0000, '1', ?, ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, tipoOperacionId, FACTORY_USER_ID, FACTORY_USER_ID);
            rows += jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, af_tipo_operacion_id, anio, mes,
                        depreciacion_periodo, depreciacion_acumulada, valor_neto, flag_estado, created_by, updated_by)
                    VALUES (?, ?, 2026, 3, 91.6667, 191.6667, 11808.3333, '1', ?, ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, tipoOperacionId, FACTORY_USER_ID, FACTORY_USER_ID);
        } else {
            rows += jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                        depreciacion_acumulada, valor_neto, flag_estado, created_by)
                    VALUES (?, 2026, 2, 91.6667, 100.0000, 11900.0000, '1', ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, FACTORY_USER_ID);
            rows += jdbc.update("""
                    INSERT INTO activos.af_calculo_cntbl (af_maestro_id, anio, mes, depreciacion_periodo,
                        depreciacion_acumulada, valor_neto, flag_estado, created_by)
                    VALUES (?, 2026, 3, 91.6667, 191.6667, 11808.3333, '1', ?)
                    ON CONFLICT (af_maestro_id, anio, mes) DO NOTHING
                    """, maestroId, FACTORY_USER_ID);
        }
        return rows;
    }

    private static int ensureAfValuaciones(JdbcTemplate jdbc, Long maestroPrincipalId) {
        if (!tableExists(jdbc, "activos", "af_valuacion")
                || !columnExists(jdbc, "activos", "af_valuacion", "estado")) {
            return 0;
        }
        int rows = jdbc.update("""
                INSERT INTO activos.af_valuacion (af_maestro_id, fecha_valuacion, valor_anterior, valor_nuevo,
                    metodo_valuacion, tipo_revaluacion, responsable_id, estado, observaciones, flag_estado, created_by)
                SELECT ?, DATE '2025-05-15', 12000.0000, 12500.0000, 'REVALUACION', 'INFLACION', ?, 'APROBADO',
                    'Valuación factory M principal', '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_valuacion v
                    WHERE v.af_maestro_id = ? AND v.observaciones = 'Valuación factory M principal'
                )
                """, maestroPrincipalId, FACTORY_USER_ID, FACTORY_USER_ID, maestroPrincipalId);

        Long maestro2 = jdbc.query(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_MAESTRO_2);
        if (maestro2 != null) {
            rows += jdbc.update("""
                    INSERT INTO activos.af_valuacion (af_maestro_id, fecha_valuacion, valor_anterior, valor_nuevo,
                        metodo_valuacion, tipo_revaluacion, responsable_id, estado, observaciones, flag_estado, created_by)
                    SELECT ?, DATE '2025-07-01', 18500.0000, 19000.0000, 'REVALUACION', 'MERCADO', ?, 'APROBADO',
                        'Valuación factory M2', '1', ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_valuacion v
                        WHERE v.af_maestro_id = ? AND v.observaciones = 'Valuación factory M2'
                    )
                    """, maestro2, FACTORY_USER_ID, FACTORY_USER_ID, maestro2);
        }
        return rows;
    }

    private static int ensureAfVentaFactory(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_venta")) {
            return 0;
        }
        Long maestro3 = jdbc.query(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_MAESTRO_3);
        if (maestro3 == null) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO activos.af_venta (af_maestro_id, fecha_baja, motivo, valor_venta, comprador, flag_estado, created_by)
                SELECT ?, DATE '2025-11-30', 'VENTA', 15000.0000, 'Comprador factory test', '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_venta v WHERE v.af_maestro_id = ? AND v.comprador = 'Comprador factory test'
                )
                """, maestro3, FACTORY_USER_ID, maestro3);
    }

    private static int ensureAfDocumentos(JdbcTemplate jdbc, Long maestroPrincipalId) {
        if (!tableExists(jdbc, "activos", "af_documento")) {
            return 0;
        }
        int rows = jdbc.update("""
                INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo,
                    descripcion, fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by)
                SELECT ?, 'FACTURA', 'factory-factura-m.pdf', '/factory/docs/factura-m.pdf',
                    'Factura compra factory M', DATE '2025-01-10', 102400, 'pdf', ?, '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_documento d
                    WHERE d.af_maestro_id = ? AND d.nombre_archivo = 'factory-factura-m.pdf'
                )
                """, maestroPrincipalId, FACTORY_USER_ID, FACTORY_USER_ID, maestroPrincipalId);

        Long maestro2 = jdbc.query(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_MAESTRO_2);
        if (maestro2 != null) {
            rows += jdbc.update("""
                    INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo,
                        descripcion, fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by)
                    SELECT ?, 'GARANTIA', 'factory-garantia-m2.pdf', '/factory/docs/garantia-m2.pdf',
                        'Garantía factory M2', DATE '2025-02-20', 51200, 'pdf', ?, '1', ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_documento d
                        WHERE d.af_maestro_id = ? AND d.nombre_archivo = 'factory-garantia-m2.pdf'
                    )
                    """, maestro2, FACTORY_USER_ID, FACTORY_USER_ID, maestro2);
        }
        return rows;
    }

    private static int ensureAfHistorialExtendido(JdbcTemplate jdbc, Long maestroId) {
        if (!tableExists(jdbc, "activos", "af_historial")) {
            return 0;
        }
        int rows = 0;
        rows += insertHistorialIfMissing(jdbc, maestroId, "DEPRECIACION", "Depreciación período factory 2025/02",
                "10908.33", "10816.67");
        rows += insertHistorialIfMissing(jdbc, maestroId, "TRASLADO", "Traslado ubicación factory",
                "FACTORY-AF-UBI-A", "FACTORY-AF-UBI-B");
        rows += insertHistorialIfMissing(jdbc, maestroId, "VALUACION", "Revaluación inflación factory",
                "12000.00", "12500.00");
        rows += insertHistorialIfMissing(jdbc, maestroId, "ADAPTACION", "Capitalización adaptación factory",
                "500.00", "12500.00");
        rows += insertHistorialIfMissing(jdbc, maestroId, "SEGURO", "Alta póliza seguro factory",
                "0", "600.00");
        return rows;
    }

    private static int insertHistorialIfMissing(
            JdbcTemplate jdbc, Long maestroId, String tipoEvento, String descripcion) {
        return insertHistorialIfMissing(jdbc, maestroId, tipoEvento, descripcion, "prev", "nuevo");
    }

    private static int insertHistorialIfMissing(
            JdbcTemplate jdbc,
            Long maestroId,
            String tipoEvento,
            String descripcion,
            String valorAnterior,
            String valorNuevo) {
        if (columnExists(jdbc, "activos", "af_historial", "valor_anterior")) {
            return jdbc.update("""
                    INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, valor_anterior, valor_nuevo,
                        usuario_id, fecha_evento, ip_origen, modulo, flag_estado, created_by, updated_by)
                    SELECT ?, ?, ?, ?, ?, ?, ?, '127.0.0.1', 'FACTORY-AF', '1', ?, ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_historial h
                        WHERE h.af_maestro_id = ? AND h.modulo = 'FACTORY-AF' AND h.tipo_evento = ?
                    )
                    """, maestroId, tipoEvento, descripcion, valorAnterior, valorNuevo,
                    FACTORY_USER_ID, LocalDateTime.now(), FACTORY_USER_ID, FACTORY_USER_ID,
                    maestroId, tipoEvento);
        }
        return jdbc.update("""
                INSERT INTO activos.af_historial (af_maestro_id, tipo_evento, descripcion, usuario_id,
                    fecha_evento, ip_origen, modulo, flag_estado, created_by)
                SELECT ?, ?, ?, ?, ?, '127.0.0.1', 'FACTORY-AF', '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_historial h
                    WHERE h.af_maestro_id = ? AND h.modulo = 'FACTORY-AF' AND h.tipo_evento = ?
                )
                """, maestroId, tipoEvento, descripcion, FACTORY_USER_ID, LocalDateTime.now(),
                FACTORY_USER_ID, maestroId, tipoEvento);
    }

    private static int ensureAfTiposOperacion(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_tipo_operacion")) {
            return 0;
        }
        int rows = 0;
        if (columnExists(jdbc, "activos", "af_tipo_operacion", "created_by")) {
            rows += jdbc.update("""
                    INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo, tasa,
                        metodo_calculo, afecta_contabilidad, modulo_contable, tipo_operacion_contable, observaciones,
                        flag_estado, created_by, updated_by)
                    VALUES ('FACTORY-AF', 'Depreciación activo factory', 'DEBITO', 'FIJO', 0.0833,
                        'LINEAL', TRUE, 'AF', 'DEPRECIACION', 'Tipo operación factory depreciación', '1', ?, ?)
                    ON CONFLICT (codigo) DO UPDATE SET descripcion = EXCLUDED.descripcion, observaciones = EXCLUDED.observaciones
                    """, FACTORY_USER_ID, FACTORY_USER_ID);
            rows += jdbc.update("""
                    INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo, tasa,
                        metodo_calculo, afecta_contabilidad, modulo_contable, tipo_operacion_contable, observaciones,
                        flag_estado, created_by, updated_by)
                    VALUES ('FACTORY-TR', 'Traslado activo factory', 'DEBITO', 'FIJO', 0,
                        'NINGUNO', TRUE, 'AF', 'TRASLADO', 'Tipo operación factory traslado', '1', ?, ?)
                    ON CONFLICT (codigo) DO NOTHING
                    """, FACTORY_USER_ID, FACTORY_USER_ID);
            rows += jdbc.update("""
                    INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo, tasa,
                        metodo_calculo, afecta_contabilidad, modulo_contable, tipo_operacion_contable, observaciones,
                        flag_estado, created_by, updated_by)
                    VALUES ('FACTORY-UO', 'Depreciación UOP factory', 'DEBITO', 'VARIABLE', 0,
                        'UNIDADES_PRODUCIDAS', TRUE, 'AF', 'DEPRECIACION', 'Tipo operación factory UOP', '1', ?, ?)
                    ON CONFLICT (codigo) DO NOTHING
                    """, FACTORY_USER_ID, FACTORY_USER_ID);
            return rows;
        }
        rows += jdbc.update("""
                INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo,
                    modulo_contable, tipo_operacion_contable, flag_estado)
                VALUES ('FACTORY-AF', 'Depreciación activo factory', 'DEBITO', 'FIJO', 'AF', 'DEPRECIACION', '1')
                ON CONFLICT (codigo) DO NOTHING
                """);
        rows += jdbc.update("""
                INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo,
                    modulo_contable, tipo_operacion_contable, flag_estado)
                VALUES ('FACTORY-TR', 'Traslado activo factory', 'DEBITO', 'FIJO', 'AF', 'TRASLADO', '1')
                ON CONFLICT (codigo) DO NOTHING
                """);
        rows += jdbc.update("""
                INSERT INTO activos.af_tipo_operacion (codigo, descripcion, naturaleza, tipo_calculo,
                    modulo_contable, tipo_operacion_contable, flag_estado)
                VALUES ('FACTORY-UO', 'Depreciación UOP factory', 'DEBITO', 'VARIABLE', 'AF', 'DEPRECIACION', '1')
                ON CONFLICT (codigo) DO NOTHING
                """);
        return rows;
    }

    private static Long resolveTipoOperacionId(JdbcTemplate jdbc, String codigo) {
        if (!tableExists(jdbc, "activos", "af_tipo_operacion")) {
            return null;
        }
        return jdbc.query(
                "SELECT id FROM activos.af_tipo_operacion WHERE codigo = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                codigo);
    }

    private static Long resolveUnidadMedidaId(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "unidad_medida")) {
            return null;
        }
        return jdbc.query(
                "SELECT id FROM core.unidad_medida WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }

    private static int ensureAfNumeracionConfig(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_numeracion_config")) {
            return 0;
        }
        int rows;
        if (columnExists(jdbc, "activos", "af_numeracion_config", "created_by")) {
            rows = jdbc.update("""
                    INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero, flag_estado, created_by)
                    VALUES ('MAESTRO', 'FACTORY', 100, 6, '1', ?)
                    ON CONFLICT (tipo) DO NOTHING
                    """, FACTORY_USER_ID);
            rows += jdbc.update("""
                    INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero, flag_estado, created_by)
                    VALUES ('TRASLADO', 'FACTORY-TR', 50, 6, '1', ?)
                    ON CONFLICT (tipo) DO NOTHING
                    """, FACTORY_USER_ID);
        } else {
            rows = jdbc.update("""
                    INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero, flag_estado)
                    VALUES ('MAESTRO', 'FACTORY', 100, 6, '1')
                    ON CONFLICT (tipo) DO NOTHING
                    """);
            rows += jdbc.update("""
                    INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero, flag_estado)
                    VALUES ('TRASLADO', 'FACTORY-TR', 50, 6, '1')
                    ON CONFLICT (tipo) DO NOTHING
                    """);
        }
        return rows;
    }

    private static int ensurePrimaDevengoExtra(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_prima_devengo")) {
            return 0;
        }
        Long polizaId = jdbc.query(
                "SELECT id FROM activos.af_poliza_seguro WHERE numero_poliza = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_POLIZA);
        if (polizaId == null) {
            return 0;
        }
        int rows = 0;
        for (int mes = 1; mes <= 12; mes++) {
            rows += jdbc.update("""
                    INSERT INTO activos.af_prima_devengo (af_poliza_seguro_id, anio, mes, importe_devengado,
                        meses_vigencia_poliza, flag_estado, created_by)
                    VALUES (?, 2025, ?, 50.0000, 24, '1', ?)
                    ON CONFLICT (af_poliza_seguro_id, anio, mes) DO NOTHING
                    """, polizaId, mes, FACTORY_USER_ID);
        }
        return rows;
    }

    private static int ensureAfAccesorios(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_accesorios")) {
            return 0;
        }
        int rows = 0;
        rows += insertAccesorio(jdbc, CODIGO_MAESTRO, "Monitor LED 27 factory", 450.0000, "2023-02-01");
        rows += insertAccesorio(jdbc, CODIGO_MAESTRO, "Teclado ergonómico factory", 85.5000, "2023-02-05");
        rows += insertAccesorio(jdbc, CODIGO_MAESTRO_2, "Kit herramientas factory M2", 320.0000, "2024-07-10");
        rows += insertAccesorio(jdbc, CODIGO_MAESTRO_2, "Protector industrial factory M2", 180.0000, "2024-07-15");
        rows += insertAccesorio(jdbc, CODIGO_MAESTRO_3, "Sensor UOP factory M3", 950.0000, "2024-04-01");
        return rows;
    }

    private static int insertAccesorio(
            JdbcTemplate jdbc, String codigoMaestro, String descripcion, double costo, String fechaInstalacion) {
        if (columnExists(jdbc, "activos", "af_accesorios", "updated_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_accesorios (af_maestro_id, descripcion, costo, fecha_instalacion,
                        flag_estado, created_by, updated_by)
                    SELECT m.id, ?, ?, CAST(? AS DATE), '1', ?, ?
                    FROM activos.af_maestro m
                    WHERE m.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM activos.af_accesorios a
                          WHERE a.af_maestro_id = m.id AND a.descripcion = ?
                      )
                    """, descripcion, costo, fechaInstalacion, FACTORY_USER_ID, FACTORY_USER_ID,
                    codigoMaestro, descripcion);
        }
        return jdbc.update("""
                INSERT INTO activos.af_accesorios (af_maestro_id, descripcion, costo, fecha_instalacion, flag_estado, created_by)
                SELECT m.id, ?, ?, CAST(? AS DATE), '1', ?
                FROM activos.af_maestro m
                WHERE m.codigo = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_accesorios a
                      WHERE a.af_maestro_id = m.id AND a.descripcion = ?
                  )
                """, descripcion, costo, fechaInstalacion, FACTORY_USER_ID, codigoMaestro, descripcion);
    }

    private static int ensureAfSoftware(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_software")) {
            return 0;
        }
        int rows = 0;
        rows += insertSoftware(jdbc, CODIGO_MAESTRO, "LIC-FACTORY-M-ERP", "SAP Factory Peru", "2025-01-01", "2026-12-31", "soporte@factory.test");
        rows += insertSoftware(jdbc, CODIGO_MAESTRO_2, "LIC-FACTORY-M2-CAD", "Autodesk Factory", "2024-06-01", "2027-05-31", "cad@factory.test");
        rows += insertSoftware(jdbc, CODIGO_MAESTRO_3, "LIC-FACTORY-M3-SCADA", "Siemens Factory SCADA", "2024-03-15", "2028-03-14", "scada@factory.test");
        return rows;
    }

    private static int insertSoftware(
            JdbcTemplate jdbc,
            String codigoMaestro,
            String licencia,
            String proveedor,
            String vigenciaIni,
            String vigenciaFin,
            String soporte) {
        if (columnExists(jdbc, "activos", "af_software", "updated_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_software (af_maestro_id, licencia, proveedor_software, fecha_vigencia_ini,
                        fecha_vigencia_fin, soporte, flag_estado, created_by, updated_by)
                    SELECT m.id, ?, ?, CAST(? AS DATE), CAST(? AS DATE), ?, '1', ?, ?
                    FROM activos.af_maestro m
                    WHERE m.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM activos.af_software s
                          WHERE s.af_maestro_id = m.id AND s.licencia = ?
                      )
                    """, licencia, proveedor, vigenciaIni, vigenciaFin, soporte,
                    FACTORY_USER_ID, FACTORY_USER_ID, codigoMaestro, licencia);
        }
        return jdbc.update("""
                INSERT INTO activos.af_software (af_maestro_id, licencia, proveedor_software, fecha_vigencia_ini,
                    fecha_vigencia_fin, soporte, flag_estado, created_by)
                SELECT m.id, ?, ?, CAST(? AS DATE), CAST(? AS DATE), ?, '1', ?
                FROM activos.af_maestro m
                WHERE m.codigo = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_software s
                      WHERE s.af_maestro_id = m.id AND s.licencia = ?
                  )
                """, licencia, proveedor, vigenciaIni, vigenciaFin, soporte,
                FACTORY_USER_ID, codigoMaestro, licencia);
    }

    private static int ensureAfRevaluacionLegacy(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_revaluacion")) {
            return 0;
        }
        int rows = insertRevaluacionLegacy(jdbc, CODIGO_MAESTRO, "2025-04-01", 12000.0000, 12200.0000,
                "Informe pericial factory M", FACTORY_USER_ID);
        rows += insertRevaluacionLegacy(jdbc, CODIGO_MAESTRO_2, "2025-08-01", 18500.0000, 19200.0000,
                "Informe mercado factory M2", FACTORY_USER_ID);
        return rows;
    }

    private static int insertRevaluacionLegacy(
            JdbcTemplate jdbc,
            String codigoMaestro,
            String fecha,
            double valorAnterior,
            double valorNuevo,
            String sustento,
            Long peritoId) {
        if (columnExists(jdbc, "activos", "af_revaluacion", "updated_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_revaluacion (af_maestro_id, fecha, valor_anterior, valor_nuevo, sustento,
                        perito_id, flag_estado, created_by, updated_by)
                    SELECT m.id, CAST(? AS DATE), ?, ?, ?, ?, '1', ?, ?
                    FROM activos.af_maestro m
                    WHERE m.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM activos.af_revaluacion r
                          WHERE r.af_maestro_id = m.id AND r.fecha = CAST(? AS DATE)
                      )
                    """, fecha, valorAnterior, valorNuevo, sustento, peritoId,
                    FACTORY_USER_ID, FACTORY_USER_ID, codigoMaestro, fecha);
        }
        return jdbc.update("""
                INSERT INTO activos.af_revaluacion (af_maestro_id, fecha, valor_anterior, valor_nuevo, sustento,
                    perito_id, flag_estado, created_by)
                SELECT m.id, CAST(? AS DATE), ?, ?, ?, ?, '1', ?
                FROM activos.af_maestro m
                WHERE m.codigo = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_revaluacion r
                      WHERE r.af_maestro_id = m.id AND r.fecha = CAST(? AS DATE)
                  )
                """, fecha, valorAnterior, valorNuevo, sustento, peritoId,
                FACTORY_USER_ID, codigoMaestro, fecha);
    }

    private static int ensureAfOperaciones(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_operaciones")) {
            return 0;
        }
        int rows = 0;
        rows += insertOperacion(jdbc, CODIGO_MAESTRO, "MANTENIMIENTO", "2025-09-01", "2025-09-05", 250.0000, "Servicios Factory SAC");
        rows += insertOperacion(jdbc, CODIGO_MAESTRO, "CALIBRACION", "2025-10-15", "2025-10-16", 180.0000, "Metrología Factory SAC");
        rows += insertOperacion(jdbc, CODIGO_MAESTRO_2, "MANTENIMIENTO", "2025-11-01", "2025-11-03", 420.0000, "Taller Factory Norte");
        rows += insertOperacion(jdbc, CODIGO_MAESTRO_3, "INSPECCION", "2025-05-01", "2025-05-02", 310.0000, "Inspección Factory UOP");
        return rows;
    }

    private static int insertOperacion(
            JdbcTemplate jdbc,
            String codigoMaestro,
            String tipo,
            String fechaProgramada,
            String fechaEjecucion,
            double costo,
            String proveedorServicio) {
        if (columnExists(jdbc, "activos", "af_operaciones", "updated_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_operaciones (af_maestro_id, tipo, fecha_programada, fecha_ejecucion, costo,
                        proveedor_servicio, flag_estado, created_by, updated_by)
                    SELECT m.id, ?, CAST(? AS DATE), CAST(? AS DATE), ?, ?, '1', ?, ?
                    FROM activos.af_maestro m
                    WHERE m.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM activos.af_operaciones o
                          WHERE o.af_maestro_id = m.id AND o.tipo = ? AND o.fecha_programada = CAST(? AS DATE)
                      )
                    """, tipo, fechaProgramada, fechaEjecucion, costo, proveedorServicio,
                    FACTORY_USER_ID, FACTORY_USER_ID, codigoMaestro, tipo, fechaProgramada);
        }
        return jdbc.update("""
                INSERT INTO activos.af_operaciones (af_maestro_id, tipo, fecha_programada, fecha_ejecucion, costo,
                    proveedor_servicio, flag_estado, created_by)
                SELECT m.id, ?, CAST(? AS DATE), CAST(? AS DATE), ?, ?, '1', ?
                FROM activos.af_maestro m
                WHERE m.codigo = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM activos.af_operaciones o
                      WHERE o.af_maestro_id = m.id AND o.tipo = ? AND o.fecha_programada = CAST(? AS DATE)
                  )
                """, tipo, fechaProgramada, fechaEjecucion, costo, proveedorServicio,
                FACTORY_USER_ID, codigoMaestro, tipo, fechaProgramada);
    }

    private static int ensureAfAdaptacionesAdicionales(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_adaptacion")) {
            return 0;
        }
        int rows = insertAdaptacionExtra(jdbc, CODIGO_MAESTRO, "Adaptación mejora eléctrica factory", "2025-06-15", 750.0000);
        rows += insertAdaptacionExtra(jdbc, CODIGO_MAESTRO_2, "Adaptación refuerzo estructural factory M2", "2025-08-20", 1200.0000);
        return rows;
    }

    private static int insertAdaptacionExtra(
            JdbcTemplate jdbc, String codigoMaestro, String descripcion, String fecha, double monto) {
        boolean conEstado = columnExists(jdbc, "activos", "af_adaptacion", "estado");
        Long maestroId = resolveMaestroIdByCodigoSafe(jdbc, codigoMaestro);
        if (maestroId == null) {
            return 0;
        }
        Long existente = jdbc.query(
                "SELECT id FROM activos.af_adaptacion WHERE af_maestro_id = ? AND descripcion = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                maestroId, descripcion);
        if (existente != null) {
            return 0;
        }
        int cab;
        if (conEstado && columnExists(jdbc, "activos", "af_adaptacion", "updated_by")) {
            cab = jdbc.update("""
                    INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, estado,
                        flag_estado, created_by, updated_by)
                    VALUES (?, CAST(? AS DATE), ?, ?, 'REGISTRADO', '1', ?, ?)
                    """, maestroId, fecha, descripcion, monto, FACTORY_USER_ID, FACTORY_USER_ID);
        } else if (conEstado) {
            cab = jdbc.update("""
                    INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, estado,
                        flag_estado, created_by)
                    VALUES (?, CAST(? AS DATE), ?, ?, 'REGISTRADO', '1', ?)
                    """, maestroId, fecha, descripcion, monto, FACTORY_USER_ID);
        } else {
            cab = jdbc.update("""
                    INSERT INTO activos.af_adaptacion (af_maestro_id, fecha, descripcion, monto_total, flag_estado, created_by)
                    VALUES (?, CAST(? AS DATE), ?, ?, '1', ?)
                    """, maestroId, fecha, descripcion, monto, FACTORY_USER_ID);
        }
        Long adaptId = jdbc.queryForObject(
                "SELECT id FROM activos.af_adaptacion WHERE af_maestro_id = ? AND descripcion = ? ORDER BY id DESC LIMIT 1",
                Long.class, maestroId, descripcion);
        int det = 0;
        if (tableExists(jdbc, "activos", "af_adaptacion_det")) {
            det = jdbc.update("""
                    INSERT INTO activos.af_adaptacion_det (af_adaptacion_id, descripcion, monto, flag_estado, created_by)
                    VALUES (?, ?, ?, '1', ?)
                    """, adaptId, descripcion + " - detalle único", monto, FACTORY_USER_ID);
        }
        if (tableExists(jdbc, "activos", "af_adaptacion_dep")) {
            jdbc.update("""
                    INSERT INTO activos.af_adaptacion_dep (af_adaptacion_id, anio, mes, depreciacion_periodo,
                        depreciacion_acumulada, flag_estado, created_by)
                    VALUES (?, 2025, 6, 15.0000, 15.0000, '1', ?)
                    ON CONFLICT (af_adaptacion_id, anio, mes) DO NOTHING
                    """, adaptId, FACTORY_USER_ID);
        }
        return cab + det;
    }

    private static Long resolveMaestroIdByCodigoSafe(JdbcTemplate jdbc, String codigo) {
        return jdbc.query(
                "SELECT id FROM activos.af_maestro WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                codigo);
    }

    private static int ensureAfTrasladosAdicionales(JdbcTemplate jdbc, Long ubiA, Long ubiB) {
        if (!tableExists(jdbc, "activos", "af_traslado")
                || !columnExists(jdbc, "activos", "af_traslado", "estado")) {
            return 0;
        }
        Long m2 = resolveMaestroIdByCodigoSafe(jdbc, CODIGO_MAESTRO_2);
        if (m2 == null) {
            return 0;
        }
        int rows = 0;
        rows += insertTrasladoWorkflow(jdbc, m2, ubiB, ubiA, "Traslado factory M2 APROBADO", "APROBADO",
                "2025-07-01", "2025-07-02", FACTORY_USER_ID);
        rows += insertTrasladoWorkflow(jdbc, m2, ubiA, ubiB, "Traslado factory M2 RECHAZADO", "RECHAZADO",
                "2025-07-10", null, FACTORY_USER_ID);
        return rows;
    }

    private static int insertTrasladoWorkflow(
            JdbcTemplate jdbc,
            Long maestroId,
            Long ubiOrigen,
            Long ubiDestino,
            String motivo,
            String estado,
            String fechaSolicitud,
            String fechaEjecucion,
            Long aprobadorId) {
        Long cc1 = jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CC_1);
        Long cc2 = jdbc.query(
                "SELECT id FROM contabilidad.centros_costo WHERE cencos = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_CC_2);
        boolean conCc = columnExists(jdbc, "activos", "af_traslado", "centro_costo_origen_id")
                && cc1 != null && cc2 != null;
        if (conCc && columnExists(jdbc, "activos", "af_traslado", "aprobador_id")) {
            return jdbc.update("""
                    INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                        solicitante_id, aprobador_id, fecha_solicitud, fecha_ejecucion, motivo, estado,
                        centro_costo_origen_id, centro_costo_destino_id, flag_estado, created_by, updated_by)
                    SELECT ?, ?, ?, ?, ?, CAST(? AS DATE), CAST(? AS DATE), ?, ?, ?, ?, '1', ?, ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_traslado t WHERE t.af_maestro_id = ? AND t.motivo = ?
                    )
                    """, maestroId, ubiOrigen, ubiDestino, FACTORY_USER_ID, aprobadorId,
                    fechaSolicitud, fechaEjecucion, motivo, estado, cc1, cc2,
                    FACTORY_USER_ID, FACTORY_USER_ID, maestroId, motivo);
        }
        return jdbc.update("""
                INSERT INTO activos.af_traslado (af_maestro_id, ubicacion_origen_id, ubicacion_destino_id,
                    solicitante_id, aprobador_id, fecha_solicitud, fecha_ejecucion, motivo, estado, flag_estado, created_by)
                SELECT ?, ?, ?, ?, ?, CAST(? AS DATE), CAST(? AS DATE), ?, ?, '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_traslado t WHERE t.af_maestro_id = ? AND t.motivo = ?
                )
                """, maestroId, ubiOrigen, ubiDestino, FACTORY_USER_ID, aprobadorId,
                fechaSolicitud, fechaEjecucion, motivo, estado, FACTORY_USER_ID, maestroId, motivo);
    }

    private static int ensureAfPolizaSeguroM2(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_poliza_seguro") || !tableExists(jdbc, "activos", "af_aseguradora")) {
            return 0;
        }
        Long asegId = jdbc.queryForObject(
                "SELECT id FROM activos.af_aseguradora WHERE ruc = ?", Long.class, RUC_ASEGURADORA);
        int pol;
        if (columnExists(jdbc, "activos", "af_poliza_seguro", "updated_by")) {
            pol = jdbc.update("""
                    INSERT INTO activos.af_poliza_seguro (af_aseguradora_id, numero_poliza, fecha_inicio, fecha_fin,
                        prima, cobertura, flag_estado, created_by, updated_by)
                    VALUES (?, ?, DATE '2025-02-01', DATE '2027-01-31', 850.0000, 20000.0000, '1', ?, ?)
                    ON CONFLICT (numero_poliza) DO NOTHING
                    """, asegId, CODIGO_POLIZA_M2, FACTORY_USER_ID, FACTORY_USER_ID);
        } else {
            pol = jdbc.update("""
                    INSERT INTO activos.af_poliza_seguro (af_aseguradora_id, numero_poliza, fecha_inicio, fecha_fin,
                        prima, cobertura, flag_estado, created_by)
                    VALUES (?, ?, DATE '2025-02-01', DATE '2027-01-31', 850.0000, 20000.0000, '1', ?)
                    ON CONFLICT (numero_poliza) DO NOTHING
                    """, asegId, CODIGO_POLIZA_M2, FACTORY_USER_ID);
        }

        Long polizaId = jdbc.queryForObject(
                "SELECT id FROM activos.af_poliza_seguro WHERE numero_poliza = ?", Long.class, CODIGO_POLIZA_M2);
        Long maestro2 = resolveMaestroIdByCodigoSafe(jdbc, CODIGO_MAESTRO_2);
        int polAct = 0;
        if (maestro2 != null && tableExists(jdbc, "activos", "af_poliza_activo")) {
            polAct = jdbc.update("""
                    INSERT INTO activos.af_poliza_activo (af_poliza_seguro_id, af_maestro_id, valor_asegurado, flag_estado, created_by)
                    SELECT ?, ?, 19500.0000, '1', ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_poliza_activo pa
                        WHERE pa.af_poliza_seguro_id = ? AND pa.af_maestro_id = ?
                    )
                    """, polizaId, maestro2, FACTORY_USER_ID, polizaId, maestro2);
        }
        return pol + polAct;
    }

    private static int ensureAfDocumentosAdicionales(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_documento")) {
            return 0;
        }
        Long maestro3 = resolveMaestroIdByCodigoSafe(jdbc, CODIGO_MAESTRO_3);
        if (maestro3 == null) {
            return 0;
        }
        if (columnExists(jdbc, "activos", "af_documento", "updated_by")) {
            return jdbc.update("""
                    INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo,
                        descripcion, fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by, updated_by)
                    SELECT ?, 'ACTA_BAJA', 'factory-acta-baja-m3.pdf', '/factory/docs/acta-baja-m3.pdf',
                        'Acta baja factory M3', DATE '2025-11-28', 204800, 'pdf', ?, '1', ?, ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM activos.af_documento d
                        WHERE d.af_maestro_id = ? AND d.nombre_archivo = 'factory-acta-baja-m3.pdf'
                    )
                    """, maestro3, FACTORY_USER_ID, FACTORY_USER_ID, FACTORY_USER_ID, maestro3);
        }
        return jdbc.update("""
                INSERT INTO activos.af_documento (af_maestro_id, tipo_documento, nombre_archivo, ruta_archivo,
                    descripcion, fecha_carga, tamanio_bytes, extension, usuario_carga_id, flag_estado, created_by)
                SELECT ?, 'ACTA_BAJA', 'factory-acta-baja-m3.pdf', '/factory/docs/acta-baja-m3.pdf',
                    'Acta baja factory M3', DATE '2025-11-28', 204800, 'pdf', ?, '1', ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM activos.af_documento d
                    WHERE d.af_maestro_id = ? AND d.nombre_archivo = 'factory-acta-baja-m3.pdf'
                )
                """, maestro3, FACTORY_USER_ID, FACTORY_USER_ID, maestro3);
    }

    private static int ensureEnriquecimientoSinNulos(JdbcTemplate jdbc) {
        int rows = 0;
        rows += completarMaestrosFactory(jdbc);
        rows += completarCalculosSinTipoOperacion(jdbc);
        rows += completarHistorialTodosMaestros(jdbc);
        rows += completarEntidadContribuyente(jdbc);
        rows += completarCentrosCosto(jdbc);
        rows += completarAseguradora(jdbc);
        rows += completarMaestroCcDistribUpdated(jdbc);
        return rows;
    }

    private static int completarMaestrosFactory(JdbcTemplate jdbc) {
        int rows = 0;
        if (columnExists(jdbc, "activos", "af_maestro", "factura_proveedor_serie")) {
            rows += jdbc.update("""
                    UPDATE activos.af_maestro SET
                        factura_proveedor_serie = COALESCE(factura_proveedor_serie, 'F001'),
                        factura_proveedor_numero = COALESCE(factura_proveedor_numero,
                            CASE codigo
                                WHEN ? THEN '00010001'
                                WHEN ? THEN '00020002'
                                WHEN ? THEN '00030003'
                                ELSE '00099999'
                            END),
                        factura_proveedor_fecha = COALESCE(factura_proveedor_fecha, fecha_adquisicion),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE codigo IN (?, ?, ?)
                    """, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                    FACTORY_USER_ID, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3);
        }
        if (columnExists(jdbc, "activos", "af_maestro", "orden_compra_id")
                && columnExists(jdbc, "activos", "af_maestro", "orden_compra_linea_id")
                && columnExists(jdbc, "activos", "af_maestro", "recepcion_compra_id")) {
            if (columnExists(jdbc, "activos", "af_maestro", "updated_by")) {
                rows += jdbc.update("""
                        UPDATE activos.af_maestro SET
                            orden_compra_id = COALESCE(orden_compra_id,
                                CASE codigo WHEN ? THEN 90001 WHEN ? THEN 90002 WHEN ? THEN 90003 ELSE 90099 END),
                            orden_compra_linea_id = COALESCE(orden_compra_linea_id, 1),
                            recepcion_compra_id = COALESCE(recepcion_compra_id,
                                CASE codigo WHEN ? THEN 80001 WHEN ? THEN 80002 WHEN ? THEN 80003 ELSE 80099 END),
                            updated_by = COALESCE(updated_by, ?)
                        WHERE codigo IN (?, ?, ?)
                        """, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        FACTORY_USER_ID, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3);
            } else {
                rows += jdbc.update("""
                        UPDATE activos.af_maestro SET
                            orden_compra_id = COALESCE(orden_compra_id,
                                CASE codigo WHEN ? THEN 90001 WHEN ? THEN 90002 WHEN ? THEN 90003 ELSE 90099 END),
                            orden_compra_linea_id = COALESCE(orden_compra_linea_id, 1),
                            recepcion_compra_id = COALESCE(recepcion_compra_id,
                                CASE codigo WHEN ? THEN 80001 WHEN ? THEN 80002 WHEN ? THEN 80003 ELSE 80099 END)
                        WHERE codigo IN (?, ?, ?)
                        """, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3);
            }
        } else if (columnExists(jdbc, "activos", "af_maestro", "orden_compra_id")) {
            if (columnExists(jdbc, "activos", "af_maestro", "updated_by")) {
                rows += jdbc.update("""
                        UPDATE activos.af_maestro SET
                            orden_compra_id = COALESCE(orden_compra_id,
                                CASE codigo WHEN ? THEN 90001 WHEN ? THEN 90002 WHEN ? THEN 90003 ELSE 90099 END),
                            updated_by = COALESCE(updated_by, ?)
                        WHERE codigo IN (?, ?, ?)
                        """, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        FACTORY_USER_ID, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3);
            } else {
                rows += jdbc.update("""
                        UPDATE activos.af_maestro SET
                            orden_compra_id = COALESCE(orden_compra_id,
                                CASE codigo WHEN ? THEN 90001 WHEN ? THEN 90002 WHEN ? THEN 90003 ELSE 90099 END)
                        WHERE codigo IN (?, ?, ?)
                        """, CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3,
                        CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3);
            }
        }
        if (columnExists(jdbc, "activos", "af_maestro", "unidades_produccion_totales")) {
            rows += jdbc.update("""
                    UPDATE activos.af_maestro SET
                        unidades_produccion_totales = COALESCE(unidades_produccion_totales, 0),
                        unidades_produccion_periodo = COALESCE(unidades_produccion_periodo, 0),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE codigo IN (?, ?) AND unidades_produccion_totales IS NULL
                    """, FACTORY_USER_ID, CODIGO_MAESTRO, CODIGO_MAESTRO_2);
        }
        if (columnExists(jdbc, "activos", "af_maestro", "estado_activo")) {
            rows += jdbc.update("""
                    UPDATE activos.af_maestro SET estado_activo = COALESCE(estado_activo, 'ACTIVO'),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE codigo LIKE 'FACTORY-AF-M%' AND estado_activo IS NULL
                    """, FACTORY_USER_ID);
        }
        return rows;
    }

    private static int completarCalculosSinTipoOperacion(JdbcTemplate jdbc) {
        if (!columnExists(jdbc, "activos", "af_calculo_cntbl", "af_tipo_operacion_id")) {
            return 0;
        }
        Long tipoDep = resolveTipoOperacionId(jdbc, "FACTORY-AF");
        Long tipoUop = resolveTipoOperacionId(jdbc, "FACTORY-UO");
        int rows = 0;
        boolean conUpdatedBy = columnExists(jdbc, "activos", "af_calculo_cntbl", "updated_by");
        if (tipoDep != null) {
            if (conUpdatedBy) {
                rows += jdbc.update("""
                        UPDATE activos.af_calculo_cntbl c SET af_tipo_operacion_id = ?,
                            updated_by = COALESCE(c.updated_by, ?)
                        FROM activos.af_maestro m
                        WHERE m.id = c.af_maestro_id AND m.codigo IN (?, ?)
                          AND c.af_tipo_operacion_id IS NULL
                        """, tipoDep, FACTORY_USER_ID, CODIGO_MAESTRO, CODIGO_MAESTRO_2);
            } else {
                rows += jdbc.update("""
                        UPDATE activos.af_calculo_cntbl c SET af_tipo_operacion_id = ?
                        FROM activos.af_maestro m
                        WHERE m.id = c.af_maestro_id AND m.codigo IN (?, ?)
                          AND c.af_tipo_operacion_id IS NULL
                        """, tipoDep, CODIGO_MAESTRO, CODIGO_MAESTRO_2);
            }
        }
        if (tipoUop != null) {
            if (conUpdatedBy) {
                rows += jdbc.update("""
                        UPDATE activos.af_calculo_cntbl c SET af_tipo_operacion_id = ?,
                            updated_by = COALESCE(c.updated_by, ?)
                        FROM activos.af_maestro m
                        WHERE m.id = c.af_maestro_id AND m.codigo = ?
                          AND c.af_tipo_operacion_id IS NULL
                        """, tipoUop, FACTORY_USER_ID, CODIGO_MAESTRO_3);
            } else {
                rows += jdbc.update("""
                        UPDATE activos.af_calculo_cntbl c SET af_tipo_operacion_id = ?
                        FROM activos.af_maestro m
                        WHERE m.id = c.af_maestro_id AND m.codigo = ?
                          AND c.af_tipo_operacion_id IS NULL
                        """, tipoUop, CODIGO_MAESTRO_3);
            }
        }
        if (columnExists(jdbc, "activos", "af_calculo_cntbl", "updated_by")) {
            rows += jdbc.update("""
                    UPDATE activos.af_calculo_cntbl c SET updated_by = ?
                    FROM activos.af_maestro m
                    WHERE m.id = c.af_maestro_id AND m.codigo LIKE 'FACTORY-AF-M%' AND c.updated_by IS NULL
                    """, FACTORY_USER_ID);
        }
        return rows;
    }

    private static int completarHistorialTodosMaestros(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_historial")) {
            return 0;
        }
        int rows = 0;
        for (String codigo : new String[]{CODIGO_MAESTRO, CODIGO_MAESTRO_2, CODIGO_MAESTRO_3}) {
            Long id = resolveMaestroIdByCodigoSafe(jdbc, codigo);
            if (id == null) {
                continue;
            }
            rows += insertHistorialIfMissing(jdbc, id, "ALTA", "Alta activo factory " + codigo, "0", "ACTIVO");
            rows += insertHistorialIfMissing(jdbc, id, "MODIFICACION", "Actualización datos factory " + codigo,
                    "valor_anterior", "valor_nuevo");
        }
        return rows;
    }

    private static int completarEntidadContribuyente(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "entidad_contribuyente")) {
            return 0;
        }
        int rows = jdbc.update("""
                INSERT INTO core.entidad_contribuyente (
                    id, tipo_persona, tipo_documento, nro_documento, razon_social,
                    es_proveedor, es_cliente, es_empleado, flag_estado
                ) VALUES
                (2, 'JURIDICA', 'RUC', '20987654321', 'PROVEEDOR SECUNDARIO FACTORY AF S.A.C.', TRUE, FALSE, FALSE, '1')
                ON CONFLICT (id) DO UPDATE SET razon_social = EXCLUDED.razon_social, es_proveedor = EXCLUDED.es_proveedor
                """);
        if (columnExists(jdbc, "core", "entidad_contribuyente", "nombre_comercial")) {
            rows += jdbc.update("""
                    UPDATE core.entidad_contribuyente SET
                        nombre_comercial = COALESCE(nombre_comercial, razon_social),
                        direccion = COALESCE(direccion, 'Av. Factory 123, Lima'),
                        telefono = COALESCE(telefono, '014445556'),
                        email = COALESCE(email, 'contacto@factory-af.test')
                    WHERE nro_documento IN ('20123456789', '20987654321')
                    """);
        }
        return rows;
    }

    private static int completarCentrosCosto(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "contabilidad", "centros_costo")) {
            return 0;
        }
        if (columnExists(jdbc, "contabilidad", "centros_costo", "created_by")) {
            return jdbc.update("""
                    UPDATE contabilidad.centros_costo SET
                        desc_cencos = COALESCE(NULLIF(desc_cencos, ''), desc_cencos),
                        created_by = COALESCE(created_by, ?),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE cencos IN (?, ?)
                    """, FACTORY_USER_ID, FACTORY_USER_ID, CODIGO_CC_1, CODIGO_CC_2);
        }
        return 0;
    }

    private static int completarAseguradora(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_aseguradora")) {
            return 0;
        }
        if (columnExists(jdbc, "activos", "af_aseguradora", "updated_by")) {
            return jdbc.update("""
                    UPDATE activos.af_aseguradora SET
                        contacto = COALESCE(contacto, 'contacto@factory.test'),
                        updated_by = COALESCE(updated_by, ?)
                    WHERE ruc = ?
                    """, FACTORY_USER_ID, RUC_ASEGURADORA);
        }
        return jdbc.update("""
                UPDATE activos.af_aseguradora SET contacto = COALESCE(contacto, 'contacto@factory.test')
                WHERE ruc = ?
                """, RUC_ASEGURADORA);
    }

    private static int completarMaestroCcDistribUpdated(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "activos", "af_maestro_cc_distrib")
                || !columnExists(jdbc, "activos", "af_maestro_cc_distrib", "updated_by")) {
            return 0;
        }
        return jdbc.update("""
                UPDATE activos.af_maestro_cc_distrib d SET updated_by = COALESCE(d.updated_by, ?)
                FROM activos.af_maestro m
                WHERE m.id = d.af_maestro_id AND m.codigo LIKE 'FACTORY-AF-M%' AND d.updated_by IS NULL
                """, FACTORY_USER_ID);
    }

    static boolean columnExists(JdbcTemplate jdbc, String schema, String table, String column) {
        Integer n = jdbc.queryForObject("""
                        SELECT COUNT(*)::int FROM information_schema.columns
                        WHERE table_schema = ? AND table_name = ? AND column_name = ?
                        """,
                Integer.class, schema, table, column);
        return n != null && n > 0;
    }

    private static boolean isActivosIntegracionDdlComplete(JdbcTemplate jdbc) {
        return columnExists(jdbc, "activos", "af_maestro", "cntbl_asiento_id")
                && columnExists(jdbc, "activos", "af_maestro", "estado_activo")
                && columnExists(jdbc, "activos", "af_calculo_cntbl", "cntbl_asiento_id");
    }

    static boolean tableExists(JdbcTemplate jdbc, String schema, String tableName) {
        Integer n = jdbc.queryForObject("""
                        SELECT COUNT(*)::int FROM information_schema.tables
                        WHERE table_schema = ? AND table_name = ?
                        """,
                Integer.class, schema, tableName);
        return n != null && n > 0;
    }
}
