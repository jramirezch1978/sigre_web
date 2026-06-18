package pe.restaurant.compras.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Reportes del módulo Compras consumidos por el frontend (módulo Reportes).
 *
 * Contrato: cada método devuelve una lista de filas planas cuyos nombres de campo
 * deben coincidir EXACTAMENTE con los esperados por el front (prefijos
 * {@code compra_transito_*}, {@code sugerencia_compra_*}, etc.). El reporte de
 * gestión (1.1) admite camelCase. El controller envuelve la lista en
 * {@code ApiResponse} y el front lee {@code .data} como array.
 *
 * Se usa SQL nativo (JdbcTemplate) por tratarse de consultas analíticas que
 * cruzan varios esquemas (compras, core, almacen, finanzas, auth).
 */
@Service
@RequiredArgsConstructor
public class ReporteComprasService {

    private final JdbcTemplate jdbcTemplate;

    /** 1.1 Gestión de compras al detalle (ejecuta compras.sp_generar_reporte_compras). */
    public List<Map<String, Object>> gestionCompras(Long sucursalId, LocalDate desde, LocalDate hasta) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT * FROM compras.sp_generar_reporte_compras(CAST(? AS BIGINT), CAST(? AS DATE), CAST(? AS DATE))",
                sucursalId, desde, hasta);

        List<Map<String, Object>> out = new ArrayList<>(rows.size());
        for (Map<String, Object> r : rows) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("fechaCompra", r.get("fecha_compra"));
            m.put("nroOrden", r.get("nro_orden"));
            m.put("docFiscal", r.get("doc_fiscal"));
            m.put("razonSocial", r.get("razon_social"));
            m.put("producto", r.get("producto"));
            m.put("categoria", r.get("categoria"));
            m.put("unidadMedida", r.get("unidad_medida"));
            m.put("cantidad", r.get("cantidad"));
            m.put("precioVenta", r.get("precio_venta"));
            m.put("condicion", r.get("condicion"));
            m.put("estado", r.get("estado"));
            m.put("detalle", new ArrayList<>());
            out.add(m);
        }
        return out;
    }

    /** 1.2 Compras en tránsito (OC con saldo pendiente de recepción). */
    public List<Map<String, Object>> comprasTransito(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                SELECT oc.nro_orden_compra                                  AS compra_transito_nro_orden,
                       oc.fecha_emision                                     AS compra_transito_fecha_emision,
                       ec.razon_social                                      AS compra_transito_proveedor,
                       ec.nro_documento                                     AS compra_transito_ruc_nit,
                       COALESCE(m.sigla_moneda, m.codigo)                   AS compra_transito_moneda,
                       oc.total                                             AS compra_transito_monto_total,
                       s.nombre                                             AS compra_transito_sucursal,
                       'OC'                                                 AS compra_transito_tipo_doc,
                       COALESCE(SUM(d.cant_proyectada), 0)                  AS compra_transito_solicitado,
                       COALESCE(SUM(d.cant_proyectada), 0)                  AS compra_transito_cantidad,
                       COALESCE(SUM(d.cant_procesada), 0)                   AS compra_transito_recepcionado,
                       COALESCE(SUM(d.cant_proyectada - d.cant_procesada), 0) AS compra_transito_pendiente,
                       oc.fecha_entrega                                     AS compra_transito_fecha_entrega,
                       CASE WHEN COALESCE(SUM(d.cant_proyectada), 0) = 0 THEN 0
                            ELSE ROUND(COALESCE(SUM(d.cant_procesada), 0) * 100.0 / SUM(d.cant_proyectada), 2) END
                                                                            AS compra_transito_porcentaje_total,
                       (CURRENT_DATE - oc.fecha_emision)                    AS compra_transito_dias,
                       CASE oc.flag_estado WHEN '1' THEN 'Activo' WHEN '2' THEN 'Cerrado' WHEN '3' THEN 'Pendiente' ELSE oc.flag_estado END
                                                                            AS compra_transito_estado
                FROM        compras.orden_compra      oc
                JOIN        compras.orden_compra_det  d  ON d.orden_compra_id = oc.id AND d.flag_estado = '1'
                LEFT JOIN   core.entidad_contribuyente ec ON ec.id = oc.proveedor_id
                LEFT JOIN   core.moneda               m  ON m.id = oc.moneda_id
                LEFT JOIN   auth.sucursal             s  ON s.id = oc.sucursal_id
                WHERE       oc.flag_estado = '1'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "oc.sucursal_id");
        sql.append("""
                GROUP BY oc.id, ec.razon_social, ec.nro_documento, m.sigla_moneda, m.codigo, s.nombre
                HAVING COALESCE(SUM(d.cant_proyectada - d.cant_procesada), 0) > 0
                ORDER BY oc.fecha_emision DESC
                """);
        return jdbcTemplate.queryForList(sql.toString(), args.toArray());
    }

    /** 1.3 Compras por ingresar (OC con recepción pendiente de ingreso a almacén). */
    public List<Map<String, Object>> comprasPorIngresar(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                SELECT oc.nro_orden_compra                                  AS compra_ingresar_nro_orden,
                       oc.fecha_emision                                     AS compra_ingresar_fecha_emision,
                       (SELECT MAX(vm.fecha_mov) FROM almacen.vale_mov vm
                          WHERE vm.orden_compra_id = oc.id AND vm.flag_estado = '1')
                                                                            AS compra_ingresar_fecha_recepcion,
                       NULL::varchar                                        AS compra_ingresar_doc_fiscal,
                       ec.razon_social                                      AS compra_ingresar_proveedor,
                       COALESCE(m.sigla_moneda, m.codigo)                   AS compra_ingresar_moneda,
                       s.nombre                                             AS compra_ingresar_sucursal,
                       oc.total                                             AS compra_ingresar_monto_total,
                       COALESCE(SUM(d.cant_procesada), 0)                   AS compra_ingresar_recepcionado,
                       COALESCE(SUM(d.cant_proyectada), 0)                  AS compra_ingresar_cantidad,
                       COALESCE(SUM(d.cant_procesada), 0)                   AS compra_ingresar_ingresado,
                       COALESCE(SUM(d.cant_proyectada - d.cant_procesada), 0) AS compra_ingresar_diferencia,
                       NULL::varchar                                        AS compra_ingresar_usuario_receptor,
                       CASE oc.flag_estado WHEN '1' THEN 'Activo' WHEN '2' THEN 'Cerrado' WHEN '3' THEN 'Pendiente' ELSE oc.flag_estado END
                                                                            AS compra_ingresar_estado
                FROM        compras.orden_compra      oc
                JOIN        compras.orden_compra_det  d  ON d.orden_compra_id = oc.id AND d.flag_estado = '1'
                LEFT JOIN   core.entidad_contribuyente ec ON ec.id = oc.proveedor_id
                LEFT JOIN   core.moneda               m  ON m.id = oc.moneda_id
                LEFT JOIN   auth.sucursal             s  ON s.id = oc.sucursal_id
                WHERE       oc.flag_estado = '1'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "oc.sucursal_id");
        sql.append("""
                GROUP BY oc.id, ec.razon_social, m.sigla_moneda, m.codigo, s.nombre
                HAVING COALESCE(SUM(d.cant_proyectada - d.cant_procesada), 0) > 0
                ORDER BY oc.fecha_emision DESC
                """);
        return jdbcTemplate.queryForList(sql.toString(), args.toArray());
    }

    /** 1.4 Compras sugeridas (a partir del stock por almacén). */
    public List<Map<String, Object>> comprasSugeridas(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                SELECT a.codigo                                             AS sugerencia_compra_codigo,
                       a.nombre                                             AS sugerencia_compra_producto,
                       cat.desc_categ                                       AS sugerencia_compra_categoria,
                       alm.nombre                                           AS sugerencia_compra_almacen,
                       COALESCE(um.abreviatura, um.nombre)                  AS sugerencia_compra_medida,
                       COALESCE(aa.cantidad_disponible, 0)                  AS sugerencia_compra_stock_actual,
                       0                                                    AS sugerencia_compra_prom_consumo,
                       0                                                    AS sugerencia_compra_pt_reposicion,
                       aa.ultima_actualizacion::date                        AS sugerencia_compra_fecha_registro,
                       CASE WHEN COALESCE(aa.cantidad_disponible, 0) <= 0 THEN 'CRITICO' ELSE 'OK' END
                                                                            AS sugerencia_compra_estado
                FROM        almacen.articulo_almacen aa
                JOIN        core.articulo            a   ON a.id = aa.articulo_id
                JOIN        almacen.almacen          alm ON alm.id = aa.almacen_id
                LEFT JOIN   core.articulo_categ      cat ON cat.id = a.articulo_categ_id
                LEFT JOIN   core.unidad_medida       um  ON um.id = a.unidad_medida_id
                WHERE       a.flag_estado = '1'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "alm.sucursal_id");
        sql.append("ORDER BY COALESCE(aa.cantidad_disponible, 0) ASC, a.nombre\n");
        return jdbcTemplate.queryForList(sql.toString(), args.toArray());
    }

    /** 1.5 Compras por categoría (agrupado por artículo/proveedor). */
    public List<Map<String, Object>> comprasCategoria(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                WITH base AS (
                    SELECT a.articulo_categ_id, a.articulo_sub_categ_id, a.codigo, a.nombre,
                           a.unidad_medida_id, oc.proveedor_id, oc.moneda_id, oc.sucursal_id,
                           d.cant_proyectada, d.subtotal, oc.fecha_emision
                    FROM        compras.orden_compra      oc
                    JOIN        compras.orden_compra_det  d ON d.orden_compra_id = oc.id AND d.flag_estado = '1'
                    JOIN        core.articulo             a ON a.id = d.articulo_id
                    WHERE       oc.flag_estado <> '0'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "oc.sucursal_id");
        sql.append("""
                )
                SELECT cat.desc_categ                                       AS compra_categoria_categoria,
                       sub.desc_subcateg                                    AS compra_categoria_subcategoria,
                       b.nombre                                             AS compra_categoria_producto,
                       b.codigo                                             AS compra_categoria_codigo,
                       NULL::varchar                                        AS compra_categoria_doc_fiscal,
                       ec.razon_social                                      AS compra_categoria_razon_social,
                       COALESCE(m.sigla_moneda, m.codigo)                   AS compra_categoria_moneda,
                       NULL::varchar                                        AS compra_categoria_centro_costo,
                       COALESCE(um.abreviatura, um.nombre)                  AS compra_categoria_medida,
                       SUM(b.cant_proyectada)                               AS compra_categoria_cantidad_comprada,
                       SUM(b.subtotal)                                      AS compra_categoria_monto_total,
                       CASE WHEN SUM(b.cant_proyectada) = 0 THEN 0
                            ELSE ROUND(SUM(b.subtotal) / SUM(b.cant_proyectada), 4) END
                                                                            AS compra_categoria_precio_promedio,
                       ROUND(SUM(b.subtotal) * 100.0 / NULLIF(SUM(SUM(b.subtotal)) OVER (), 0), 2)
                                                                            AS compra_categoria_participacion,
                       MAX(b.fecha_emision)                                 AS compra_categoria_ultima_compra,
                       MAX(s.nombre)                                        AS compra_categoria_sucursal,
                       'Activo'                                             AS compra_categoria_estado
                FROM        base b
                LEFT JOIN   core.articulo_categ        cat ON cat.id = b.articulo_categ_id
                LEFT JOIN   core.articulo_sub_categ    sub ON sub.id = b.articulo_sub_categ_id
                LEFT JOIN   core.entidad_contribuyente ec  ON ec.id = b.proveedor_id
                LEFT JOIN   core.moneda                m   ON m.id = b.moneda_id
                LEFT JOIN   core.unidad_medida         um  ON um.id = b.unidad_medida_id
                LEFT JOIN   auth.sucursal              s   ON s.id = b.sucursal_id
                GROUP BY cat.desc_categ, sub.desc_subcateg, b.nombre, b.codigo,
                         ec.razon_social, m.sigla_moneda, m.codigo, um.abreviatura, um.nombre
                ORDER BY SUM(b.subtotal) DESC
                """);
        return jdbcTemplate.queryForList(sql.toString(), args.toArray());
    }

    /** 1.6 Análisis de proveedores (agrupado por proveedor). */
    public List<Map<String, Object>> analisisProveedores(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                SELECT ec.id::varchar                                       AS analisis_proveedor_codigo,
                       ec.nro_documento                                     AS analisis_proveedor_doc_fiscal,
                       ec.razon_social                                      AS analisis_proveedor_razon_social,
                       ec.tipo_documento                                    AS analisis_proveedor_tipo_documento,
                       COUNT(DISTINCT oc.id)                                AS analisis_proveedor_doc_emitidos,
                       COALESCE(MAX(m.sigla_moneda), MAX(m.codigo))         AS analisis_proveedor_moneda,
                       MAX(oc.fecha_emision)                                AS analisis_proveedor_ultima_compra,
                       MAX(s.nombre)                                        AS analisis_proveedor_sucursal,
                       'Activo'                                             AS analisis_proveedor_estado_contable,
                       COALESCE(SUM(oc.subtotal), 0)                        AS analisis_proveedor_subtotal,
                       COALESCE(SUM(oc.igv_total), 0)                       AS analisis_proveedor_impuestos,
                       COALESCE(SUM(oc.total), 0)                           AS analisis_proveedor_monto_total,
                       ROUND(COALESCE(SUM(oc.total), 0) * 100.0 / NULLIF(SUM(SUM(oc.total)) OVER (), 0), 2)
                                                                            AS analisis_proveedor_porc_participacion,
                       NULL::varchar                                        AS analisis_proveedor_centro_costo
                FROM        compras.orden_compra      oc
                LEFT JOIN   core.entidad_contribuyente ec ON ec.id = oc.proveedor_id
                LEFT JOIN   core.moneda               m  ON m.id = oc.moneda_id
                LEFT JOIN   auth.sucursal             s  ON s.id = oc.sucursal_id
                WHERE       oc.flag_estado <> '0'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "oc.sucursal_id");
        sql.append("""
                GROUP BY ec.id, ec.nro_documento, ec.razon_social, ec.tipo_documento
                ORDER BY COALESCE(SUM(oc.total), 0) DESC
                """);
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql.toString(), args.toArray());
        for (Map<String, Object> r : rows) {
            r.put("analisis_proveedor_detalle", new ArrayList<>());
        }
        return rows;
    }

    /** 1.7 Compras procesadas (documentos de cuentas por pagar). */
    public List<Map<String, Object>> comprasProcesadas(Long sucursalId) {
        StringBuilder sql = new StringBuilder("""
                SELECT NULLIF(CONCAT_WS('-', cp.serie, cp.numero), '')      AS compra_procesada_nro_documento,
                       cp.fecha_emision                                     AS compra_procesada_fecha_emision,
                       ec.razon_social                                      AS compra_procesada_proveedor,
                       ec.nro_documento                                     AS compra_procesada_ruc_nit,
                       s.nombre                                             AS compra_procesada_sucursal,
                       NULL::varchar                                        AS compra_procesada_centro_costo,
                       dt.nombre                                            AS compra_procesada_tipo_documento,
                       NULLIF(CONCAT_WS('-', cp.serie, cp.numero), '')      AS compra_procesada_comprobante,
                       cp.fec_creacion::date                                AS compra_procesada_fecha_registro,
                       COALESCE(m.sigla_moneda, m.codigo)                   AS compra_procesada_moneda,
                       cp.total                                             AS compra_procesada_base_imponible,
                       0                                                    AS compra_procesada_valor_inafecto,
                       0                                                    AS compra_procesada_valor_adq_no_gravadas,
                       0                                                    AS compra_procesada_igv,
                       0                                                    AS compra_procesada_icbper,
                       cp.total                                             AS compra_procesada_monto_total,
                       1                                                    AS compra_procesada_tipo_cambio,
                       CASE cp.flag_estado WHEN '1' THEN 'Vigente' WHEN '0' THEN 'Anulado' ELSE cp.flag_estado END
                                                                            AS compra_procesada_estado
                FROM        finanzas.cntas_pagar      cp
                LEFT JOIN   core.entidad_contribuyente ec ON ec.id = cp.proveedor_id
                LEFT JOIN   core.moneda               m  ON m.id = cp.moneda_id
                LEFT JOIN   auth.sucursal             s  ON s.id = cp.sucursal_id
                LEFT JOIN   core.doc_tipo             dt ON dt.id = cp.doc_tipo_id
                WHERE       cp.flag_estado <> '0'
                """);
        List<Object> args = new ArrayList<>();
        appendSucursal(sql, args, sucursalId, "cp.sucursal_id");
        sql.append("ORDER BY cp.fecha_emision DESC\n");
        return jdbcTemplate.queryForList(sql.toString(), args.toArray());
    }

    private void appendSucursal(StringBuilder sql, List<Object> args, Long sucursalId, String column) {
        if (sucursalId != null) {
            sql.append("  AND ").append(column).append(" = ?\n");
            args.add(sucursalId);
        }
    }
}
