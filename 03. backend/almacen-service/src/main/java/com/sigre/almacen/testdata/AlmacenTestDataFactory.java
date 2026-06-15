package com.sigre.almacen.testdata;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Factory JDBC idempotente para tests de integración de ms-almacén.
 *
 * <p>Cubre las tablas del esquema {@code almacen} (DDL 02-almacen.sql) con datos
 * estables {@code FACTORY-AL-*} y columnas opcionales rellenadas cuando existen.</p>
 *
 * <p>Para demo masiva usar {@link com.sigre.almacen.service.TestDataSeedService}.</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AlmacenTestDataFactory {

    public static final String CODIGO_SUCURSAL = "AL";
    public static final String CODIGO_ALMACEN_TIPO = "FACTORY-AL-TIP";
    public static final String CODIGO_ALMACEN_1 = "FACTORY-AL-01";
    public static final String CODIGO_ALMACEN_2 = "FACTORY-AL-02";
    public static final String CODIGO_MOTIVO_TRASLADO = "FACTORY-MT-01";
    public static final String TIPO_MOV_FACTORY = "ING-FACT";
    public static final String NRO_VALE = "LM-TEST-0001";
    public static final String NRO_VALE_2 = "LM-TEST-0002";
    public static final String NRO_OT = "OT0000000001";
    public static final String NRO_SS = "SS0000000001";
    public static final String GUIA_SERIE = "F001";
    public static final String GUIA_NUMERO = "00001001";
    public static final String CODIGO_UBIC_1 = "FACTORY-PICK-01";
    public static final String CODIGO_UBIC_2 = "FACTORY-PICK-02";
    public static final String NRO_LOTE_1 = "FACTORY-LOTE-001";
    public static final String ART_LINEA_1 = "ART-001";
    public static final String ART_LINEA_2 = "ART-005";
    public static final String ART_LINEA_3 = "ART-002";

    /** Filas masivas por tabla almacén (ver {@link AlmacenTestDataFactoryBulk}). */
    public static final int BULK_ROWS_PER_TABLE = AlmacenTestDataFactoryBulk.BULK_ROWS;

    private static final long FACTORY_USER_ID = 1L;

    private final DataSource dataSource;

    @Transactional
    public Map<String, Integer> ensureAlmacenTransactionalData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("core.unidad_medida", ensureCoreUnidadMedida(jdbc));
        out.put("core.articulo_categ", ensureCoreArticuloCateg(jdbc));
        out.put("core.moneda", ensureCoreMoneda(jdbc));
        out.put("core.articulo", ensureCoreArticulo(jdbc));
        out.put("core.entidad_contribuyente", ensureEntidadContribuyente(jdbc));
        out.put("core.doc_tipo", ensureCoreDocTipo(jdbc));

        out.put("auth.sucursal", ensureAuthSucursal(jdbc));
        out.put("almacen.almacen_tipo", ensureAlmacenTipo(jdbc));
        out.put("almacen.almacen", ensureAlmacenes(jdbc));
        out.put("almacen.motivo_traslado", ensureMotivoTraslado(jdbc));
        out.put("almacen.articulo_mov_tipo", ensureArticuloMovTipo(jdbc));

        out.put("almacen.ubicacion_almacen", ensureUbicacionAlmacen(jdbc));
        out.put("almacen.lote_pallet", ensureLotePallet(jdbc));
        out.put("almacen.almacen_user", ensureAlmacenUser(jdbc));
        out.put("almacen.almacen_tipo_mov", ensureAlmacenTipoMov(jdbc));

        out.put("almacen.vale_mov + det", ensureValeMov(jdbc));
        out.put("almacen.vale_mov_2", ensureValeMovSecundario(jdbc));
        out.put("almacen.orden_traslado + det", ensureOrdenTraslado(jdbc));
        out.put("almacen.guia + det", ensureGuia(jdbc));
        out.put("almacen.sol_salida + det", ensureSolSalida(jdbc));
        out.put("almacen.inventario_conteo", ensureInventarioConteo(jdbc));
        out.put("almacen.articulo_bonificacion", ensureArticuloBonificacion(jdbc));
        out.put("almacen.articulo_almacen", ensureArticuloAlmacen(jdbc));
        out.put("almacen.articulo_almacen_posicion", ensureArticuloAlmacenPosicion(jdbc));
        out.put("almacen.articulo_almacen_lote", ensureArticuloAlmacenLote(jdbc));
        out.put("almacen.articulo_saldo_mensual", ensureArticuloSaldoMensual(jdbc));
        out.put("almacen.enriquecimiento_sin_nulos", ensureEnriquecimientoSinNulos(jdbc));

        Long sucursalId = resolveSucursalId(jdbc);
        Long proveedorId = jdbc.query(
                "SELECT id FROM core.entidad_contribuyente WHERE nro_documento = '20123456789' LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
        Map<String, Integer> bulk = AlmacenTestDataFactoryBulk.ensureBulkDataset(
                jdbc,
                new AlmacenTestDataFactoryBulk.BulkContext(
                        sucursalId, resolveArticuloMovTipoId(jdbc), proveedorId));
        bulk.forEach(out::put);

        return out;
    }

    public int countValesBulkEnBd() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "almacen", "vale_mov")) {
            return 0;
        }
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM almacen.vale_mov WHERE nro_vale LIKE ? || '%' AND LENGTH(nro_vale) = 12",
                Integer.class, AlmacenTestDataFactoryBulk.PREFIX_VALE);
        return n != null ? n : 0;
    }

    public int countTablaBulkAlmacen(String tabla, String columnPattern, String pattern) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "almacen", tabla)) {
            return 0;
        }
        if ("vale_mov".equals(tabla)) {
            return countValesBulkEnBd();
        }
        if ("almacen".equals(tabla)) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM almacen.almacen WHERE codigo LIKE ? || '%'",
                    Integer.class, AlmacenTestDataFactoryBulk.PREFIX_ALM);
            return n != null ? n : 0;
        }
        if (columnPattern != null && pattern != null) {
            Integer n = jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM almacen.%s WHERE %s LIKE ?".formatted(tabla, columnPattern),
                    Integer.class, pattern);
            return n != null ? n : 0;
        }
        return 0;
    }

    public boolean isAlmacenSchemaReady() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return tableExists(jdbc, "almacen", "almacen")
                && tableExists(jdbc, "almacen", "vale_mov");
    }

    public Long resolveValeMovId() {
        return resolveValeMovId(NRO_VALE);
    }

    public Long resolveValeMovId(String nroVale) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM almacen.vale_mov WHERE nro_vale = ?", Long.class, nroVale);
    }

    public Long resolveAlmacenId() {
        return resolveAlmacenIdByCodigo(CODIGO_ALMACEN_1);
    }

    public Long resolveAlmacenIdByCodigo(String codigo) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long id = resolveAlmacenId(jdbc, codigo);
        if (id == null) {
            throw new IllegalStateException("Almacén factory no encontrado: " + codigo);
        }
        return id;
    }

    public Long resolveAlmacenTipoId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM almacen.almacen_tipo WHERE codigo = ?", Long.class, CODIGO_ALMACEN_TIPO);
    }

    public Long resolveSucursalId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long id = resolveSucursalId(jdbc);
        if (id == null) {
            throw new IllegalStateException("Sucursal factory no encontrada: " + CODIGO_SUCURSAL);
        }
        return id;
    }

    public Long resolveOrdenTrasladoId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM almacen.orden_traslado WHERE nro_orden_traslado = ?",
                Long.class, NRO_OT);
    }

    public Long resolveSolSalidaId() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        return jdbc.queryForObject(
                "SELECT id FROM almacen.sol_salida WHERE nro_sol_salida = ?",
                Long.class, NRO_SS);
    }

    public int countValeMovDetalles() {
        return countValeMovDetalles(NRO_VALE);
    }

    public int countValeMovDetalles(String nroVale) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM almacen.vale_mov_det d
                JOIN almacen.vale_mov vm ON vm.id = d.vale_mov_id
                WHERE vm.nro_vale = ?
                """, Integer.class, nroVale);
        return n != null ? n : 0;
    }

    public int countArticuloAlmacenFactory() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "almacen", "articulo_almacen")) {
            return 0;
        }
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM almacen.articulo_almacen aa
                INNER JOIN almacen.almacen a ON a.id = aa.almacen_id
                WHERE a.codigo LIKE 'FACTORY-AL-%'
                """, Integer.class);
        return n != null ? n : 0;
    }

    public int countTablaFactory(String tabla) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        if (!tableExists(jdbc, "almacen", tabla)) {
            return 0;
        }
        return switch (tabla) {
            case "ubicacion_almacen" -> countByCodigoLike(jdbc, tabla, "FACTORY-%");
            case "lote_pallet" -> countByColumnLike(jdbc, tabla, "nro_lote", "FACTORY-%");
            case "orden_traslado" -> countByColumn(jdbc, tabla, "nro_orden_traslado", NRO_OT);
            case "sol_salida" -> countByColumn(jdbc, tabla, "nro_sol_salida", NRO_SS);
            case "guia" -> jdbc.queryForObject("""
                    SELECT COUNT(*)::int FROM almacen.guia WHERE serie = ? AND numero = ?
                    """, Integer.class, GUIA_SERIE, GUIA_NUMERO);
            default -> jdbc.queryForObject(
                    "SELECT COUNT(*)::int FROM almacen." + tabla, Integer.class);
        };
    }

    private static int countByCodigoLike(JdbcTemplate jdbc, String tabla, String pattern) {
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM almacen." + tabla + " WHERE codigo LIKE ?",
                Integer.class, pattern);
        return n != null ? n : 0;
    }

    private static int countByColumnLike(JdbcTemplate jdbc, String tabla, String col, String pattern) {
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM almacen." + tabla + " WHERE " + col + " LIKE ?",
                Integer.class, pattern);
        return n != null ? n : 0;
    }

    private static int countByColumn(JdbcTemplate jdbc, String tabla, String col, String value) {
        Integer n = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM almacen." + tabla + " WHERE " + col + " = ?",
                Integer.class, value);
        return n != null ? n : 0;
    }

    // ── Core / auth ───────────────────────────────────────────────────────────

    private static int ensureCoreUnidadMedida(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "unidad_medida")) {
            return 0;
        }
        int rows = 0;
        for (String[] u : new String[][]{{"KG", "Kilogramo"}, {"LT", "Litro"}, {"UND", "Unidad"}}) {
            rows += jdbc.update("""
                    INSERT INTO core.unidad_medida (codigo, nombre, flag_estado)
                    VALUES (?, ?, '1')
                    ON CONFLICT (codigo) DO NOTHING
                    """, u[0], u[1]);
        }
        return rows;
    }

    private static int ensureCoreArticuloCateg(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "articulo_categ")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO core.articulo_categ (cat_art, desc_categ, flag_estado)
                SELECT 'MP', 'Materia prima factory', '1'
                WHERE NOT EXISTS (SELECT 1 FROM core.articulo_categ WHERE cat_art = 'MP')
                """);
    }

    private static int ensureCoreMoneda(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "moneda")) {
            return 0;
        }
        int rows = jdbc.update("""
                INSERT INTO core.moneda (codigo, nombre, simbolo, flag_estado)
                SELECT 'PEN', 'Sol peruano', 'S/', '1'
                WHERE NOT EXISTS (SELECT 1 FROM core.moneda WHERE codigo = 'PEN')
                """);
        rows += jdbc.update("""
                INSERT INTO core.moneda (codigo, nombre, simbolo, flag_estado)
                SELECT 'SOL', 'Sol peruano SIGRE', 'S/', '1'
                WHERE NOT EXISTS (SELECT 1 FROM core.moneda WHERE codigo = 'SOL')
                """);
        return rows;
    }

    private static int ensureCoreArticulo(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "articulo")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                SELECT v.id, v.codigo, v.nombre, v.tipo, um.id, ac.id, v.precio, '1'
                FROM (VALUES
                    (1, 'ART-001', 'Arroz Extra factory', 'BIEN', 'KG', 'MP', 3.50),
                    (2, 'ART-002', 'Aceite Vegetal factory', 'BIEN', 'LT', 'MP', 8.90),
                    (5, 'ART-005', 'Pollo Entero factory', 'BIEN', 'KG', 'MP', 12.50)
                ) AS v(id, codigo, nombre, tipo, um_cod, cat_cod, precio)
                JOIN core.unidad_medida um ON um.codigo = v.um_cod
                JOIN core.articulo_categ ac ON ac.cat_art = v.cat_cod
                ON CONFLICT (id) DO UPDATE SET
                    codigo = EXCLUDED.codigo, nombre = EXCLUDED.nombre, precio_venta = EXCLUDED.precio_venta
                """);
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
                (1, 'JURIDICA', 'RUC', '20123456789', 'PROVEEDOR FACTORY ALMACEN S.A.C.', TRUE, FALSE, FALSE, '1'),
                (2, 'JURIDICA', 'RUC', '20987654321', 'CLIENTE FACTORY ALMACEN E.I.R.L.', FALSE, TRUE, FALSE, '1'),
                (3, 'JURIDICA', 'RUC', '20111222333', 'TRANSPORTES FACTORY ALMACEN S.A.', FALSE, FALSE, FALSE, '1')
                ON CONFLICT (id) DO UPDATE SET razon_social = EXCLUDED.razon_social, flag_estado = EXCLUDED.flag_estado
            """);
    }

    private static int ensureCoreDocTipo(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "core", "doc_tipo")) {
            return 0;
        }
        int rows = 0;
        if (columnExists(jdbc, "core", "doc_tipo", "codigo")) {
            rows += jdbc.update("""
                    INSERT INTO core.doc_tipo (codigo, nombre, flag_estado)
                    VALUES ('DI-FACT', 'Doc interno factory', '1')
                    ON CONFLICT (codigo) DO NOTHING
                    """);
            rows += jdbc.update("""
                    INSERT INTO core.doc_tipo (codigo, nombre, flag_estado)
                    VALUES ('DE-FACT', 'Doc externo factory', '1')
                    ON CONFLICT (codigo) DO NOTHING
                    """);
        }
        return rows;
    }

    private static int ensureAuthSucursal(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "auth", "sucursal")) {
            return 0;
        }
        Integer any = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM auth.sucursal WHERE flag_estado = '1'", Integer.class);
        if (any != null && any > 0) {
            return 0;
        }
        if (columnExists(jdbc, "auth", "sucursal", "created_by")) {
            return jdbc.update("""
                    INSERT INTO auth.sucursal (codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, 'Sucursal factory almacén', '1', ?, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, CODIGO_SUCURSAL, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO auth.sucursal (codigo, nombre, flag_estado)
                VALUES (?, 'Sucursal factory almacén', '1')
                ON CONFLICT (codigo) DO NOTHING
                """, CODIGO_SUCURSAL);
    }

    // ── Catálogos almacén ─────────────────────────────────────────────────────

    private static int ensureAlmacenTipo(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "almacen_tipo")) {
            return 0;
        }
        if (columnExists(jdbc, "almacen", "almacen_tipo", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.almacen_tipo (codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, 'Tipo almacén factory principal', '1', ?, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, CODIGO_ALMACEN_TIPO, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.almacen_tipo (codigo, nombre, flag_estado)
                VALUES (?, 'Tipo almacén factory principal', '1')
                ON CONFLICT (codigo) DO NOTHING
                """, CODIGO_ALMACEN_TIPO);
    }

    private static int ensureAlmacenes(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "almacen")) {
            return 0;
        }
        Long tipoId = jdbc.query(
                "SELECT id FROM almacen.almacen_tipo WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_ALMACEN_TIPO);
        Long sucursalId = resolveSucursalId(jdbc);
        if (sucursalId == null) {
            return 0;
        }
        int rows = insertAlmacen(jdbc, CODIGO_ALMACEN_1, "Almacén factory central", tipoId, sucursalId);
        rows += insertAlmacen(jdbc, CODIGO_ALMACEN_2, "Almacén factory secundario", tipoId, sucursalId);
        return rows;
    }

    private static int insertAlmacen(
            JdbcTemplate jdbc, String codigo, String nombre, Long tipoId, Long sucursalId) {
        if (columnExists(jdbc, "almacen", "almacen", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.almacen (sucursal_id, almacen_tipo_id, codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, ?, ?, ?, '1', ?, ?)
                    ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, almacen_tipo_id = EXCLUDED.almacen_tipo_id
                    """, sucursalId, tipoId, codigo, nombre, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.almacen (sucursal_id, almacen_tipo_id, codigo, nombre, flag_estado)
                VALUES (?, ?, ?, ?, '1')
                ON CONFLICT (sucursal_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, sucursalId, tipoId, codigo, nombre);
    }

    private static int ensureMotivoTraslado(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "motivo_traslado")) {
            return 0;
        }
        if (columnExists(jdbc, "almacen", "motivo_traslado", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.motivo_traslado (codigo, nombre, flag_estado, created_by, updated_by)
                    VALUES (?, 'Traslado entre almacenes factory', '1', ?, ?)
                    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, CODIGO_MOTIVO_TRASLADO, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.motivo_traslado (codigo, nombre, flag_estado)
                VALUES (?, 'Traslado entre almacenes factory', '1')
                ON CONFLICT (codigo) DO NOTHING
                """, CODIGO_MOTIVO_TRASLADO);
    }

    private static int ensureArticuloMovTipo(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_mov_tipo")) {
            return 0;
        }
        Integer exists = jdbc.queryForObject(
                "SELECT COUNT(*)::int FROM almacen.articulo_mov_tipo WHERE tipo_mov = ?",
                Integer.class, TIPO_MOV_FACTORY);
        if (exists != null && exists > 0) {
            return 0;
        }
        Long existingAny = jdbc.query(
                "SELECT id FROM almacen.articulo_mov_tipo WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
        if (existingAny != null) {
            return 0;
        }
        if (columnExists(jdbc, "almacen", "articulo_mov_tipo", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.articulo_mov_tipo (
                        tipo_mov, desc_tipo_mov, flag_contabiliza, flag_clase_mov, cod_sunat,
                        factor_sldo_total, flag_estado, created_by, updated_by
                    ) VALUES (?, 'Ingreso almacén factory IT', '1', 'I', '16', 1.00, '1', ?, ?)
                    """, TIPO_MOV_FACTORY, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.articulo_mov_tipo (tipo_mov, desc_tipo_mov, flag_contabiliza, flag_clase_mov, factor_sldo_total, flag_estado)
                VALUES (?, 'Ingreso almacén factory IT', '1', 'I', 1.00, '1')
                """, TIPO_MOV_FACTORY);
    }

    private static int ensureUbicacionAlmacen(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "ubicacion_almacen")) {
            return 0;
        }
        Long almacenId = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        if (almacenId == null) {
            return 0;
        }
        int rows = insertUbicacion(jdbc, almacenId, CODIGO_UBIC_1, "Picking factory pasillo A", "A", "01", "01");
        rows += insertUbicacion(jdbc, almacenId, CODIGO_UBIC_2, "Picking factory pasillo B", "B", "02", "01");
        return rows;
    }

    private static int insertUbicacion(
            JdbcTemplate jdbc, Long almacenId, String codigo, String nombre,
            String pasillo, String estante, String nivel) {
        if (columnExists(jdbc, "almacen", "ubicacion_almacen", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.ubicacion_almacen (almacen_id, codigo, nombre, pasillo, estante, nivel, created_by, updated_by)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    ON CONFLICT (almacen_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                    """, almacenId, codigo, nombre, pasillo, estante, nivel, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.ubicacion_almacen (almacen_id, codigo, nombre, pasillo, estante, nivel)
                VALUES (?, ?, ?, ?, ?, ?)
                ON CONFLICT (almacen_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre
                """, almacenId, codigo, nombre, pasillo, estante, nivel);
    }

    private static int ensureLotePallet(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "lote_pallet")) {
            return 0;
        }
        Long almacenId = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        Long artId = resolveArticuloId(jdbc, ART_LINEA_1);
        if (almacenId == null || artId == null) {
            return 0;
        }
        if (columnExists(jdbc, "almacen", "lote_pallet", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.lote_pallet (almacen_id, articulo_id, nro_lote, fecha_produccion, fecha_vencimiento,
                        observacion, flag_estado, created_by, updated_by)
                    VALUES (?, ?, ?, DATE '2025-01-10', DATE '2026-06-30', 'Lote factory IT', '1', ?, ?)
                    ON CONFLICT (almacen_id, articulo_id, nro_lote) DO UPDATE SET observacion = EXCLUDED.observacion
                    """, almacenId, artId, NRO_LOTE_1, FACTORY_USER_ID, FACTORY_USER_ID);
        }
        return jdbc.update("""
                INSERT INTO almacen.lote_pallet (almacen_id, articulo_id, nro_lote, fecha_produccion, fecha_vencimiento, observacion, flag_estado)
                VALUES (?, ?, ?, DATE '2025-01-10', DATE '2026-06-30', 'Lote factory IT', '1')
                ON CONFLICT (almacen_id, articulo_id, nro_lote) DO NOTHING
                """, almacenId, artId, NRO_LOTE_1);
    }

    private static int ensureAlmacenUser(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "almacen_user")) {
            return 0;
        }
        int rows = 0;
        for (String codigoAlm : new String[]{CODIGO_ALMACEN_1, CODIGO_ALMACEN_2}) {
            Long almacenId = resolveAlmacenId(jdbc, codigoAlm);
            if (almacenId == null) {
                continue;
            }
            if (columnExists(jdbc, "almacen", "almacen_user", "created_by")) {
                rows += jdbc.update("""
                        INSERT INTO almacen.almacen_user (almacen_id, usuario_id, flag_estado, created_by, updated_by)
                        SELECT ?, ?, '1', ?, ?
                        WHERE NOT EXISTS (
                            SELECT 1 FROM almacen.almacen_user au
                            WHERE au.almacen_id = ? AND au.usuario_id = ?
                        )
                        """, almacenId, FACTORY_USER_ID, FACTORY_USER_ID, FACTORY_USER_ID, almacenId, FACTORY_USER_ID);
            } else {
                rows += jdbc.update("""
            INSERT INTO almacen.almacen_user (almacen_id, usuario_id, flag_estado)
                        SELECT ?, ?, '1'
                        WHERE NOT EXISTS (
                            SELECT 1 FROM almacen.almacen_user au
                            WHERE au.almacen_id = ? AND au.usuario_id = ?
                        )
                        """, almacenId, FACTORY_USER_ID, almacenId, FACTORY_USER_ID);
            }
        }
        return rows;
    }

    private static int ensureAlmacenTipoMov(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "almacen_tipo_mov")) {
            return 0;
        }
        return jdbc.update("""
            INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado)
            SELECT a.id, t.id, '1'
            FROM almacen.almacen a
            CROSS JOIN almacen.articulo_mov_tipo t
                WHERE a.codigo LIKE 'FACTORY-AL-%' AND a.flag_estado = '1' AND t.flag_estado = '1'
            ON CONFLICT (almacen_id, articulo_mov_tipo_id) DO NOTHING
            """);
    }

    // ── Movimientos ───────────────────────────────────────────────────────────

    private int ensureValeMov(JdbcTemplate jdbc) {
        return ensureValeMovCab(jdbc, NRO_VALE, 'I', true);
    }

    private int ensureValeMovSecundario(JdbcTemplate jdbc) {
        return ensureValeMovCab(jdbc, NRO_VALE_2, 'T', false);
    }

    private int ensureValeMovCab(JdbcTemplate jdbc, String nroVale, char tipoRef, boolean tresLineas) {
        if (!tableExists(jdbc, "almacen", "vale_mov")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        Long sucursalId = resolveSucursalId(jdbc);
        Long almacenId = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        Long tipoMovId = resolveArticuloMovTipoId(jdbc);
        if (sucursalId == null || almacenId == null || tipoMovId == null) {
            return 0;
        }

        int cab;
        if (columnExists(jdbc, "almacen", "vale_mov", "tipo_referencia_origen")) {
            cab = jdbc.update("""
                    INSERT INTO almacen.vale_mov (sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale,
                        proveedor_id, nom_receptor, observaciones, tipo_referencia_origen, fec_produccion,
                        flag_estado, created_by, updated_by)
                    SELECT ?, ?, ?, ?::date, ?, 1, 'Receptor factory IT', 'Vale movimiento factory integración',
                        ?, ?::date, '1', ?, ?
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.vale_mov vm WHERE vm.nro_vale = ?)
                    """, sucursalId, almacenId, tipoMovId, today, nroVale, String.valueOf(tipoRef), today,
                    FACTORY_USER_ID, FACTORY_USER_ID, nroVale);
        } else {
            cab = jdbc.update("""
                    INSERT INTO almacen.vale_mov (sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale,
                        proveedor_id, flag_estado, created_by)
                    SELECT ?, ?, ?, ?::date, ?, 1, '1', ?
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.vale_mov vm WHERE vm.nro_vale = ?)
                    """, sucursalId, almacenId, tipoMovId, today, nroVale, FACTORY_USER_ID, nroVale);
        }

        int det = insertValeDetalle(jdbc, nroVale, ART_LINEA_1, 10.0000, 3.5000);
        det += insertValeDetalle(jdbc, nroVale, ART_LINEA_2, 5.0000, 12.5000);
        if (tresLineas) {
            det += insertValeDetalle(jdbc, nroVale, ART_LINEA_3, 8.0000, 8.9000);
        }
        return cab + det;
    }

    private int insertValeDetalle(
            JdbcTemplate jdbc, String nroVale, String artCodigo, double cant, double costo) {
        Long ubId = jdbc.query(
                "SELECT id FROM almacen.ubicacion_almacen WHERE codigo = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_UBIC_1);
        Long loteId = jdbc.query(
                "SELECT id FROM almacen.lote_pallet WHERE nro_lote = ? LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null,
                NRO_LOTE_1);

        if (columnExists(jdbc, "almacen", "vale_mov_det", "ubicacion_almacen_id")
                && ubId != null && loteId != null) {
            return jdbc.update("""
                    INSERT INTO almacen.vale_mov_det (vale_mov_id, articulo_id, cant_procesada, costo_unitario,
                        moneda_id, lote_pallet_id, ubicacion_almacen_id, peso_neto_tm, precio_unit_ant,
                        flag_estado, created_by, updated_by)
                    SELECT vm.id, art.id, ?, ?, m.id, ?, ?, 1.250, ? * 0.95, '1', ?, ?
                    FROM almacen.vale_mov vm
                    JOIN core.articulo art ON art.codigo = ?
                    CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                    WHERE vm.nro_vale = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM almacen.vale_mov_det d
                          WHERE d.vale_mov_id = vm.id AND d.articulo_id = art.id
                      )
                    """, cant, costo, loteId, ubId, costo, FACTORY_USER_ID, FACTORY_USER_ID,
                    artCodigo, nroVale);
        }
        return jdbc.update("""
                INSERT INTO almacen.vale_mov_det (vale_mov_id, articulo_id, cant_procesada, costo_unitario, moneda_id, flag_estado, created_by)
                SELECT vm.id, art.id, ?, ?, m.id, '1', ?
                FROM almacen.vale_mov vm
                JOIN core.articulo art ON art.codigo = ?
                CROSS JOIN (SELECT id FROM core.moneda WHERE flag_estado = '1' ORDER BY id LIMIT 1) m
                WHERE vm.nro_vale = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.vale_mov_det d
                      WHERE d.vale_mov_id = vm.id AND d.articulo_id = art.id
                  )
                """, cant, costo, FACTORY_USER_ID, artCodigo, nroVale);
    }

    // ── Orden traslado, guía, solicitud, inventario ───────────────────────────

    private static int ensureOrdenTraslado(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "orden_traslado")) {
            return 0;
        }
        Long origen = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        Long destino = resolveAlmacenId(jdbc, CODIGO_ALMACEN_2);
        if (origen == null || destino == null) {
            return 0;
        }
        String today = LocalDate.now().toString();
        int cab;
        if (columnExists(jdbc, "almacen", "orden_traslado", "created_by")) {
            cab = jdbc.update("""
                    INSERT INTO almacen.orden_traslado (almacen_origen_id, almacen_destino_id, nro_orden_traslado,
                        fecha, flag_estado, observacion, usuario_id, created_by, updated_by)
                    SELECT ?, ?, ?, ?::date, '1', 'Orden traslado factory IT', ?, ?, ?
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.orden_traslado ot WHERE ot.nro_orden_traslado = ?)
                    """, origen, destino, NRO_OT, today, FACTORY_USER_ID, FACTORY_USER_ID, FACTORY_USER_ID, NRO_OT);
        } else {
            cab = jdbc.update("""
                    INSERT INTO almacen.orden_traslado (almacen_origen_id, almacen_destino_id, nro_orden_traslado, fecha, flag_estado, observacion)
                    SELECT ?, ?, ?, ?::date, '1', 'Orden traslado factory IT'
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.orden_traslado ot WHERE ot.nro_orden_traslado = ?)
                    """, origen, destino, NRO_OT, today, NRO_OT);
        }

        int det = insertOrdenTrasladoDet(jdbc, ART_LINEA_1, 15.0000, 10.0000, 8.0000);
        det += insertOrdenTrasladoDet(jdbc, ART_LINEA_2, 6.0000, 0, 0);

        return cab + det;
    }

    private static int insertOrdenTrasladoDet(
            JdbcTemplate jdbc, String artCodigo, double cant, double desp, double rec) {
        if (columnExists(jdbc, "almacen", "orden_traslado_det", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.orden_traslado_det (orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida, created_by)
                    SELECT ot.id, art.id, ?, ?, ?, ?
                    FROM almacen.orden_traslado ot
                    JOIN core.articulo art ON art.codigo = ?
                    WHERE ot.nro_orden_traslado = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM almacen.orden_traslado_det d
                          WHERE d.orden_traslado_id = ot.id AND d.articulo_id = art.id
                      )
                    """, cant, desp, rec, FACTORY_USER_ID, artCodigo, NRO_OT);
        }
        return jdbc.update("""
                INSERT INTO almacen.orden_traslado_det (orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida)
                SELECT ot.id, art.id, ?, ?, ?
                FROM almacen.orden_traslado ot
                JOIN core.articulo art ON art.codigo = ?
                WHERE ot.nro_orden_traslado = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.orden_traslado_det d
                      WHERE d.orden_traslado_id = ot.id AND d.articulo_id = art.id
                  )
                """, cant, desp, rec, artCodigo, NRO_OT);
    }

    private static int ensureGuia(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "guia")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        Long sucursalId = resolveSucursalId(jdbc);
        if (sucursalId == null) {
            return 0;
        }
        int cab;
        if (columnExists(jdbc, "almacen", "guia", "created_by")) {
            cab = jdbc.update("""
                    INSERT INTO almacen.guia (sucursal_id, serie, numero, fecha_emision, fecha_traslado,
                        motivo_traslado_id, destinatario_id, direccion_partida, direccion_llegada,
                        transportista_id, vale_mov_id, flag_estado, created_by, updated_by)
                    SELECT ?, ?, ?, ?::date, ?::date, mt.id, 2, 'Av. Origen 100', 'Av. Destino 200', 3, vm.id, '1', ?, ?
                    FROM almacen.motivo_traslado mt
                    JOIN almacen.vale_mov vm ON vm.nro_vale = ?
                    WHERE mt.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM almacen.guia g WHERE g.serie = ? AND g.numero = ?
                      )
                    """, sucursalId, GUIA_SERIE, GUIA_NUMERO, today, today,
                    FACTORY_USER_ID, FACTORY_USER_ID, NRO_VALE, CODIGO_MOTIVO_TRASLADO, GUIA_SERIE, GUIA_NUMERO);
        } else {
            cab = jdbc.update("""
                    INSERT INTO almacen.guia (sucursal_id, serie, numero, fecha_emision, fecha_traslado,
                        motivo_traslado_id, destinatario_id, transportista_id, vale_mov_id, flag_estado)
                    SELECT ?, ?, ?, ?::date, ?::date, mt.id, 2, 3, vm.id, '1'
                    FROM almacen.motivo_traslado mt
                    JOIN almacen.vale_mov vm ON vm.nro_vale = ?
                    WHERE mt.codigo = ?
                      AND NOT EXISTS (
                          SELECT 1 FROM almacen.guia g WHERE g.serie = ? AND g.numero = ?
                      )
                    """, sucursalId, GUIA_SERIE, GUIA_NUMERO, today, today,
                    NRO_VALE, CODIGO_MOTIVO_TRASLADO, GUIA_SERIE, GUIA_NUMERO);
        }

        int det = jdbc.update("""
                INSERT INTO almacen.guia_det (guia_id, vale_mov_id, articulo_id, unidad_medida_id, cantidad, flag_estado, created_by)
                SELECT g.id, g.vale_mov_id, art.id, art.unidad_medida_id, 10.0000, '1', ?
                FROM almacen.guia g
                JOIN core.articulo art ON art.codigo = ?
                WHERE g.serie = ? AND g.numero = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.guia_det gd
                      WHERE gd.guia_id = g.id AND gd.articulo_id = art.id
                  )
                """, FACTORY_USER_ID, ART_LINEA_1, GUIA_SERIE, GUIA_NUMERO);

        det += jdbc.update("""
                INSERT INTO almacen.guia_det (guia_id, vale_mov_id, articulo_id, unidad_medida_id, cantidad, flag_estado, created_by)
                SELECT g.id, g.vale_mov_id, art.id, art.unidad_medida_id, 5.0000, '1', ?
                FROM almacen.guia g
                JOIN core.articulo art ON art.codigo = ?
                WHERE g.serie = ? AND g.numero = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.guia_det gd
                      WHERE gd.guia_id = g.id AND gd.articulo_id = art.id
                  )
                """, FACTORY_USER_ID, ART_LINEA_2, GUIA_SERIE, GUIA_NUMERO);

        return cab + det;
    }

    private static int ensureSolSalida(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "sol_salida")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        Long almacenId = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        if (almacenId == null) {
            return 0;
        }
        int cab;
        if (columnExists(jdbc, "almacen", "sol_salida", "solicitante_id")) {
            cab = jdbc.update("""
                    INSERT INTO almacen.sol_salida (almacen_id, nro_sol_salida, fecha, solicitante_id, flag_estado, observacion, created_by, updated_by)
                    SELECT ?, ?, ?::date, ?, '1', 'Solicitud salida factory IT', ?, ?
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.sol_salida ss WHERE ss.nro_sol_salida = ?)
                    """, almacenId, NRO_SS, today, FACTORY_USER_ID, FACTORY_USER_ID, FACTORY_USER_ID, NRO_SS);
        } else {
            cab = jdbc.update("""
                    INSERT INTO almacen.sol_salida (almacen_id, nro_sol_salida, fecha, flag_estado, observacion)
                    SELECT ?, ?, ?::date, '1', 'Solicitud salida factory IT'
                    WHERE NOT EXISTS (SELECT 1 FROM almacen.sol_salida ss WHERE ss.nro_sol_salida = ?)
                    """, almacenId, NRO_SS, today, NRO_SS);
        }

        int det = jdbc.update("""
                INSERT INTO almacen.sol_salida_det (sol_salida_id, articulo_id, cantidad, cantidad_despachada, created_by)
                SELECT ss.id, art.id, 12.0000, 6.0000, ?
                FROM almacen.sol_salida ss
                JOIN core.articulo art ON art.codigo = ?
                WHERE ss.nro_sol_salida = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.sol_salida_det sd
                      WHERE sd.sol_salida_id = ss.id AND sd.articulo_id = art.id
                  )
                """, FACTORY_USER_ID, ART_LINEA_1, NRO_SS);

        det += jdbc.update("""
                INSERT INTO almacen.sol_salida_det (sol_salida_id, articulo_id, cantidad, cantidad_despachada, created_by)
                SELECT ss.id, art.id, 4.0000, 0, ?
                FROM almacen.sol_salida ss
                JOIN core.articulo art ON art.codigo = ?
                WHERE ss.nro_sol_salida = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.sol_salida_det sd
                      WHERE sd.sol_salida_id = ss.id AND sd.articulo_id = art.id
                  )
                """, FACTORY_USER_ID, ART_LINEA_2, NRO_SS);

        return cab + det;
    }

    private static int ensureInventarioConteo(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "inventario_conteo")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        Long almacenId = resolveAlmacenId(jdbc, CODIGO_ALMACEN_1);
        Long artId = resolveArticuloId(jdbc, ART_LINEA_1);
        Long valeId = jdbc.query(
                "SELECT id FROM almacen.vale_mov WHERE nro_vale = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                NRO_VALE);
        Long ubId = jdbc.query(
                "SELECT id FROM almacen.ubicacion_almacen WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_UBIC_1);
        Long loteId = jdbc.query(
                "SELECT id FROM almacen.lote_pallet WHERE nro_lote = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                NRO_LOTE_1);
        if (almacenId == null || artId == null) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.inventario_conteo (
                    almacen_id, articulo_id, fecha_conteo, nro_conteo, saldo_sistema,
                    cantidad_conteo_1, auditor_conteo_1, nro_ficha_conteo_1,
                    cantidad_conteo_2, auditor_conteo_2, nro_ficha_conteo_2,
                    costo_unitario, diferencia, vale_mov_ajuste_id, ubicacion_id, lote_pallet_id,
                    usuario_id, flag_estado, created_by, updated_by
                )
                SELECT ?, ?, ?::date, 1, 100.0000,
                    98.0000, 'Auditor factory 1', 'FICHA-FACTORY-001',
                    97.5000, 'Auditor factory 2', 'FICHA-FACTORY-002',
                    3.5000, -2.5000, ?, ?, ?, ?, '1', ?, ?
                WHERE NOT EXISTS (
                    SELECT 1 FROM almacen.inventario_conteo ic
                    WHERE ic.almacen_id = ? AND ic.articulo_id = ? AND ic.nro_ficha_conteo_1 = 'FICHA-FACTORY-001'
                )
                """, almacenId, artId, today, valeId, ubId, loteId, FACTORY_USER_ID,
                FACTORY_USER_ID, FACTORY_USER_ID, almacenId, artId);
    }

    // ── Stock y bonificación ──────────────────────────────────────────────────

    private static int ensureArticuloBonificacion(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_bonificacion")) {
            return 0;
        }
        int rows = 0;
        for (String art : new String[]{ART_LINEA_1, ART_LINEA_2, ART_LINEA_3}) {
            if (columnExists(jdbc, "almacen", "articulo_bonificacion", "created_by")) {
                rows += jdbc.update("""
                        INSERT INTO almacen.articulo_bonificacion (articulo_id, cantidad_minima, cantidad_bonificacion,
                            fecha_inicio, fecha_fin, flag_estado, created_by, updated_by)
                        SELECT art.id, 10.0000, 1.0000, DATE '2025-01-01', DATE '2026-12-31', '1', ?, ?
                        FROM core.articulo art
                        WHERE art.codigo = ?
                          AND NOT EXISTS (
                              SELECT 1 FROM almacen.articulo_bonificacion b WHERE b.articulo_id = art.id
                          )
                        """, FACTORY_USER_ID, FACTORY_USER_ID, art);
            } else {
                rows += jdbc.update("""
                        INSERT INTO almacen.articulo_bonificacion (articulo_id, cantidad_minima, cantidad_bonificacion,
                            fecha_inicio, fecha_fin, flag_estado)
                        SELECT art.id, 10.0000, 1.0000, DATE '2025-01-01', DATE '2026-12-31', '1'
                        FROM core.articulo art
                        WHERE art.codigo = ?
                          AND NOT EXISTS (
                              SELECT 1 FROM almacen.articulo_bonificacion b WHERE b.articulo_id = art.id
                          )
                        """, art);
            }
        }
        return rows;
    }

    private static int ensureArticuloAlmacen(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_almacen")) {
            return 0;
        }
        int rows = upsertArticuloAlmacen(jdbc, CODIGO_ALMACEN_1, 120.0000, 5.0000);
        rows += upsertArticuloAlmacen(jdbc, CODIGO_ALMACEN_2, 80.0000, 3.0000);
        return rows;
    }

    private static int upsertArticuloAlmacen(
            JdbcTemplate jdbc, String codigoAlmacen, double disponible, double reservada) {
        if (columnExists(jdbc, "almacen", "articulo_almacen", "created_by")) {
            return jdbc.update("""
                    INSERT INTO almacen.articulo_almacen (almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio, created_by, updated_by)
                    SELECT a.id, art.id, ?, ?, ROUND(COALESCE(art.precio_venta, 3.5) * 0.82, 6), ?, ?
                    FROM almacen.almacen a
                    JOIN core.articulo art ON art.codigo IN (?, ?, ?)
                    WHERE a.codigo = ?
                    ON CONFLICT (almacen_id, articulo_id) DO UPDATE SET
                        cantidad_disponible = EXCLUDED.cantidad_disponible,
                        cantidad_reservada = EXCLUDED.cantidad_reservada,
                        costo_promedio = EXCLUDED.costo_promedio
                    """, disponible, reservada, FACTORY_USER_ID, FACTORY_USER_ID,
                    ART_LINEA_1, ART_LINEA_2, ART_LINEA_3, codigoAlmacen);
        }
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen (almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
                SELECT a.id, art.id, ?, ?, ROUND(COALESCE(art.precio_venta, 3.5) * 0.82, 6)
                FROM almacen.almacen a
                JOIN core.articulo art ON art.codigo IN (?, ?, ?)
                WHERE a.codigo = ?
                ON CONFLICT (almacen_id, articulo_id) DO UPDATE SET
                    cantidad_disponible = EXCLUDED.cantidad_disponible,
                    cantidad_reservada = EXCLUDED.cantidad_reservada
                """, disponible, reservada, ART_LINEA_1, ART_LINEA_2, ART_LINEA_3, codigoAlmacen);
    }

    private static int ensureArticuloAlmacenPosicion(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_almacen_posicion")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen_posicion (ubicacion_almacen_id, articulo_id,
                    cantidad_disponible, cantidad_reservada, costo_promedio, created_by, updated_by)
                SELECT ub.id, art.id, 45.0000, 2.0000, ROUND(COALESCE(art.precio_venta, 3.5) * 0.88, 6), ?, ?
                FROM almacen.ubicacion_almacen ub
                JOIN core.articulo art ON art.codigo = ?
                WHERE ub.codigo = ?
                ON CONFLICT (articulo_id, ubicacion_almacen_id) DO UPDATE SET
                    cantidad_disponible = EXCLUDED.cantidad_disponible
                """, FACTORY_USER_ID, FACTORY_USER_ID, ART_LINEA_1, CODIGO_UBIC_1);
    }

    private static int ensureArticuloAlmacenLote(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_almacen_lote")) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO almacen.articulo_almacen_lote (almacen_id, articulo_id, lote_pallet_id,
                    cantidad_total, saldo, costo_promedio, created_by, updated_by)
                SELECT lp.almacen_id, lp.articulo_id, lp.id, 50.0000, 48.0000, 3.5000, ?, ?
                FROM almacen.lote_pallet lp
                WHERE lp.nro_lote = ?
                ON CONFLICT (almacen_id, articulo_id, lote_pallet_id) DO UPDATE SET saldo = EXCLUDED.saldo
                """, FACTORY_USER_ID, FACTORY_USER_ID, NRO_LOTE_1);
    }

    private static int ensureArticuloSaldoMensual(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "almacen", "articulo_saldo_mensual")) {
            return 0;
        }
        String today = LocalDate.now().toString();
        return jdbc.update("""
                INSERT INTO almacen.articulo_saldo_mensual (
                    almacen_id, articulo_id, vale_mov_det_id, fecha, tipo,
                    cantidad, costo_unitario, costo_total, saldo_cantidad, saldo_costo_unitario, saldo_costo_total,
                    created_by, updated_by
                )
                SELECT vm.almacen_id, vmd.articulo_id, vmd.id, ?::date, 'INGRESO',
                    vmd.cant_procesada, COALESCE(vmd.costo_unitario, 0),
                    ROUND(vmd.cant_procesada * COALESCE(vmd.costo_unitario, 0), 4),
                    vmd.cant_procesada, COALESCE(vmd.costo_unitario, 0),
                    ROUND(vmd.cant_procesada * COALESCE(vmd.costo_unitario, 0), 4), ?, ?
                FROM almacen.vale_mov_det vmd
                JOIN almacen.vale_mov vm ON vm.id = vmd.vale_mov_id
                WHERE vm.nro_vale = ?
                  AND NOT EXISTS (
                      SELECT 1 FROM almacen.articulo_saldo_mensual s WHERE s.vale_mov_det_id = vmd.id
                  )
                LIMIT 5
                """, today, FACTORY_USER_ID, FACTORY_USER_ID, NRO_VALE);
    }

    private static int ensureEnriquecimientoSinNulos(JdbcTemplate jdbc) {
        int rows = 0;
        if (columnExists(jdbc, "almacen", "vale_mov", "nro_doc_int")) {
            Long docIntId = jdbc.query(
                    "SELECT id FROM core.doc_tipo WHERE codigo = 'DI-FACT' LIMIT 1",
                    rs -> rs.next() ? rs.getLong(1) : null);
            Long docExtId = jdbc.query(
                    "SELECT id FROM core.doc_tipo WHERE codigo = 'DE-FACT' LIMIT 1",
                    rs -> rs.next() ? rs.getLong(1) : null);
            if (docIntId != null) {
                rows += jdbc.update("""
                        UPDATE almacen.vale_mov SET
                            tipo_doc_int_id = COALESCE(tipo_doc_int_id, ?),
                            nro_doc_int = COALESCE(nro_doc_int, 'DOC-INT-001'),
                            tipo_doc_ext_id = COALESCE(tipo_doc_ext_id, ?),
                            nro_doc_ext = COALESCE(nro_doc_ext, 'DOC-EXT-001'),
                            nom_receptor = COALESCE(nom_receptor, 'Receptor factory'),
                            observaciones = COALESCE(observaciones, 'Observaciones factory vale'),
                            updated_by = COALESCE(updated_by, ?)
                        WHERE nro_vale LIKE 'LM-TEST-%'
                        """, docIntId, docExtId, FACTORY_USER_ID);
            }
        }
        Long otId = jdbc.query(
                "SELECT id FROM almacen.orden_traslado WHERE nro_orden_traslado = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                NRO_OT);
        if (otId != null && columnExists(jdbc, "almacen", "vale_mov", "orden_traslado_id")) {
            rows += jdbc.update("""
                    UPDATE almacen.vale_mov SET orden_traslado_id = ?
                    WHERE nro_vale = ? AND orden_traslado_id IS NULL
                    """, otId, NRO_VALE_2);
        }
        if (columnExists(jdbc, "almacen", "vale_mov_det", "orden_traslado_det_id")) {
            rows += jdbc.update("""
                    UPDATE almacen.vale_mov_det d SET orden_traslado_det_id = otd.id
                    FROM almacen.vale_mov vm, almacen.orden_traslado ot, almacen.orden_traslado_det otd
                    WHERE vm.id = d.vale_mov_id AND vm.nro_vale = ?
                      AND ot.nro_orden_traslado = ? AND otd.orden_traslado_id = ot.id
                      AND otd.articulo_id = d.articulo_id AND d.orden_traslado_det_id IS NULL
                    """, NRO_VALE_2, NRO_OT);
        }
        return rows;
    }

    // ── Resolvers / util ──────────────────────────────────────────────────────

    private static Long resolveSucursalId(JdbcTemplate jdbc) {
        if (!tableExists(jdbc, "auth", "sucursal")) {
            return null;
        }
        Long id = jdbc.query(
                "SELECT id FROM auth.sucursal WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                CODIGO_SUCURSAL);
        if (id != null) {
            return id;
        }
        return jdbc.query(
                "SELECT id FROM auth.sucursal WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }

    private static Long resolveAlmacenId(JdbcTemplate jdbc, String codigo) {
        return jdbc.query(
                "SELECT id FROM almacen.almacen WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                codigo);
    }

    private static Long resolveArticuloId(JdbcTemplate jdbc, String codigo) {
        return jdbc.query(
                "SELECT id FROM core.articulo WHERE codigo = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                codigo);
    }

    private static Long resolveArticuloMovTipoId(JdbcTemplate jdbc) {
        Long id = jdbc.query(
                "SELECT id FROM almacen.articulo_mov_tipo WHERE tipo_mov = ?",
                rs -> rs.next() ? rs.getLong(1) : null,
                TIPO_MOV_FACTORY);
        if (id != null) {
            return id;
        }
        return jdbc.query(
                "SELECT id FROM almacen.articulo_mov_tipo WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                rs -> rs.next() ? rs.getLong(1) : null);
    }

    static boolean tableExists(JdbcTemplate jdbc, String schema, String table) {
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM information_schema.tables
                WHERE table_schema = ? AND table_name = ?
                """, Integer.class, schema, table);
        return n != null && n > 0;
    }

    static boolean columnExists(JdbcTemplate jdbc, String schema, String table, String column) {
        Integer n = jdbc.queryForObject("""
                SELECT COUNT(*)::int FROM information_schema.columns
                WHERE table_schema = ? AND table_name = ? AND column_name = ?
                """, Integer.class, schema, table, column);
        return n != null && n > 0;
    }
}
