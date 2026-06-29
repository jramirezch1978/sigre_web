package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.util.List;

/**
 * Búsqueda de artículos para el buscador del detalle de documentos (ventana AL "Artículos").
 * Filtra por cualquier campo (código, nombre, SKU, categoría, subcategoría). Incluye equivalencias.
 * Solo artículos activos.
 */
@RestController
@RequestMapping("/api/core/articulos")
@RequiredArgsConstructor
public class ArticuloLookupController {

    private final JdbcTemplate jdbcTemplate;

    public record ArticuloItem(Long id, String codigo, String nombre) {}

    public record ArticuloBuscarItem(
            Long id, String codigo, String sku, String descripcion,
            String categoria, String subCategoria, String unidad, BigDecimal precioVenta) {}

    @GetMapping("/buscar")
    public ApiResponse<List<ArticuloBuscarItem>> buscar(@RequestParam(required = false) String q) {
        String term = q == null ? "" : q.trim();
        String like = "%" + term + "%";
        List<ArticuloBuscarItem> data = jdbcTemplate.query(
                """
                SELECT a.id, a.codigo, a.codigo_barras AS sku, a.nombre,
                       cat.desc_categ, sub.desc_subcateg, um.abreviatura AS und, a.precio_venta
                FROM core.articulo a
                LEFT JOIN core.articulo_categ cat ON cat.id = a.articulo_categ_id
                LEFT JOIN core.articulo_sub_categ sub ON sub.id = a.articulo_sub_categ_id
                LEFT JOIN core.unidad_medida um ON um.id = a.unidad_medida_id
                WHERE a.flag_estado = '1'
                  AND (? = ''
                       OR a.codigo ILIKE ? OR a.nombre ILIKE ? OR a.codigo_barras ILIKE ?
                       OR cat.desc_categ ILIKE ? OR sub.desc_subcateg ILIKE ?)
                ORDER BY a.codigo
                LIMIT 200
                """,
                (rs, i) -> new ArticuloBuscarItem(
                        rs.getLong("id"), rs.getString("codigo"), rs.getString("sku"), rs.getString("nombre"),
                        rs.getString("desc_categ"), rs.getString("desc_subcateg"),
                        rs.getString("und"), rs.getBigDecimal("precio_venta")),
                term, like, like, like, like, like);
        return ApiResponse.ok(data, "Articulos");
    }

    @GetMapping("/equivalencias/{id}")
    public ApiResponse<List<ArticuloBuscarItem>> equivalencias(@PathVariable Long id) {
        List<ArticuloBuscarItem> data = jdbcTemplate.query(
                """
                SELECT a.id, a.codigo, a.codigo_barras AS sku, a.nombre,
                       cat.desc_categ, sub.desc_subcateg, um.abreviatura AS und, a.precio_venta
                FROM core.articulo_equivalencias ae
                JOIN core.articulo a ON a.id = ae.articulo_equivalente_id
                LEFT JOIN core.articulo_categ cat ON cat.id = a.articulo_categ_id
                LEFT JOIN core.articulo_sub_categ sub ON sub.id = a.articulo_sub_categ_id
                LEFT JOIN core.unidad_medida um ON um.id = a.unidad_medida_id
                WHERE ae.articulo_id = ? AND ae.flag_estado = '1' AND a.flag_estado = '1'
                ORDER BY a.codigo
                """,
                (rs, i) -> new ArticuloBuscarItem(
                        rs.getLong("id"), rs.getString("codigo"), rs.getString("sku"), rs.getString("nombre"),
                        rs.getString("desc_categ"), rs.getString("desc_subcateg"),
                        rs.getString("und"), rs.getBigDecimal("precio_venta")),
                id);
        return ApiResponse.ok(data, "Equivalencias");
    }

    @GetMapping("/lookup/{id}")
    public ApiResponse<ArticuloItem> uno(@PathVariable Long id) {
        List<ArticuloItem> rows = jdbcTemplate.query(
                "SELECT id, codigo, nombre FROM core.articulo WHERE id = ?",
                (rs, i) -> new ArticuloItem(rs.getLong("id"), rs.getString("codigo"), rs.getString("nombre")),
                id);
        return ApiResponse.ok(rows.isEmpty() ? null : rows.get(0), "Articulo");
    }
}
