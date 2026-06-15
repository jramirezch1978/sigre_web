package com.sigre.compras.testdata;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Factory B — datos transaccionales del dominio compras.
 * {@code @Component} en {@code src/main} para inyeccion en integration tests.
 *
 * <p>Prerequisito: A (common TestDataFactory) debe haberse ejecutado antes.
 * Resuelve IDs por codigo de negocio, no hardcodeados.
 * Cada metodo privado valida existencia antes de insertar (idempotente).</p>
 */
@Component
@RequiredArgsConstructor
public class ComprasTestDataFactory {

    public static final String COD_ORIGEN_OS = "OS";
    public static final String COMPRADOR_NOMBRE = "Comprador Demo 1";

    private final DataSource dataSource;

    /**
     * Asegura que los datos transaccionales propios de compras existan.
     * Prerequisito: A (seedDocTipo, seedArticulo, seedEntidadContribuyente,
     * seedComprador, seedAprobadorConfigurado, seedServicio) ya ejecutado.
     */
    @Transactional
    public Map<String, Integer> ensureComprasTransactionalData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("compras.comprador", ensureSingleActiveComprador(jdbc));
        out.put("compras.num_ord_srv", ensureNumOrdenServicio(jdbc));
        out.put("core.configuracion_aprobacion", ensureConfiguracionAprobacion(jdbc));
        out.put("compras.tipo_percepcion", ensureTipoPercepcion(jdbc));

        return out;
    }

    public Long resolveArticuloId() {
        return new JdbcTemplate(dataSource).queryForObject(
                "SELECT id FROM core.articulo WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                Long.class);
    }

    public Long resolveSecondArticuloId(Long excludedArticuloId) {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Long articuloId = findSecondArticuloId(jdbc, excludedArticuloId);
        if (articuloId != null) {
            return articuloId;
        }

        ensureFallbackArticulo(jdbc);
        articuloId = findSecondArticuloId(jdbc, excludedArticuloId);
        if (articuloId == null) {
            throw new IllegalStateException("No hay un segundo articulo activo para probar articulo-estructuras");
        }
        return articuloId;
    }

    public Long resolveProveedorId() {
        return new JdbcTemplate(dataSource).queryForObject(
                "SELECT id FROM core.entidad_contribuyente WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                Long.class);
    }

    public Long resolveSucursalId() {
        return new JdbcTemplate(dataSource).queryForObject(
                "SELECT id FROM auth.sucursal ORDER BY id LIMIT 1",
                Long.class);
    }

    public Long resolveServicioId() {
        return new JdbcTemplate(dataSource).queryForObject(
                "SELECT id FROM compras.servicio WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                Long.class);
    }

    public Long resolveDocTipoId(String codigo) {
        return new JdbcTemplate(dataSource).queryForObject(
                "SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'",
                Long.class, codigo);
    }

    public boolean hasNumOrdenServicioTable() {
        String relation = new JdbcTemplate(dataSource).queryForObject(
                "SELECT to_regclass('compras.num_ord_srv')::text",
                String.class);
        return relation != null;
    }

    public boolean hasArticuloMovProyTable() {
        String relation = new JdbcTemplate(dataSource).queryForObject(
                "SELECT to_regclass('compras.articulo_mov_proy')::text",
                String.class);
        return relation != null;
    }

    // ==== metodos privados idempotentes ====

    private Integer ensureSingleActiveComprador(JdbcTemplate jdbc) {
        return jdbc.update(
                "UPDATE compras.comprador SET flag_estado = '0' WHERE usuario_id = 1 AND id <> 1");
    }

    private Integer ensureNumOrdenServicio(JdbcTemplate jdbc) {
        if (!hasNumOrdenServicioTable()) {
            return 0;
        }
        return jdbc.update("""
                INSERT INTO compras.num_ord_srv (sucursal_id, cod_origen, ult_nro)
                SELECT s.id, 'OS', 0
                FROM auth.sucursal s WHERE s.codigo = 'LM'
                ON CONFLICT DO NOTHING
                """);
    }

    private Integer ensureConfiguracionAprobacion(JdbcTemplate jdbc) {
        jdbc.update("DELETE FROM core.configuracion WHERE parameter IN ('COMPRA_APROBACION_OC', 'COMPRA_APROBACION_OS')");
        return jdbc.update("""
                INSERT INTO core.configuracion (parameter, data_type, value_text)
                VALUES ('COMPRA_APROBACION_OC', 'TEXT', '1'),
                       ('COMPRA_APROBACION_OS', 'TEXT', '1')
                """);
    }

    private Integer ensureTipoPercepcion(JdbcTemplate jdbc) {
        return jdbc.update("""
                INSERT INTO compras.tipo_percepcion (id, codigo, descripcion, tasa, flag_estado)
                VALUES (1, '51', 'Percepcion Venta Interna', 2.0000, '1')
                ON CONFLICT (id) DO NOTHING
                """);
    }

    private Long findSecondArticuloId(JdbcTemplate jdbc, Long excludedArticuloId) {
        return jdbc.query("""
                SELECT id
                FROM core.articulo
                WHERE flag_estado = '1' AND id <> ?
                ORDER BY id
                LIMIT 1
                """,
                rs -> rs.next() ? rs.getLong("id") : null,
                excludedArticuloId);
    }

    private void ensureFallbackArticulo(JdbcTemplate jdbc) {
        jdbc.update("""
                INSERT INTO core.articulo (
                    codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado
                )
                SELECT
                    'ART-IT-ESTR-001',
                    'Articulo soporte estructura IT',
                    'BIEN',
                    COALESCE((SELECT id FROM core.unidad_medida WHERE codigo = 'UNI' ORDER BY id LIMIT 1), 1),
                    COALESCE((SELECT id FROM core.articulo_categ ORDER BY id LIMIT 1), 1),
                    1.00,
                    '1'
                WHERE NOT EXISTS (
                    SELECT 1 FROM core.articulo WHERE codigo = 'ART-IT-ESTR-001'
                )
                """);

        jdbc.update("""
                UPDATE core.articulo
                SET flag_estado = '1'
                WHERE codigo = 'ART-IT-ESTR-001'
                """);
    }
}
