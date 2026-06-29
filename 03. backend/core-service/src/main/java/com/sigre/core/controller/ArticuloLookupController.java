package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

/**
 * Búsqueda de artículos (código o nombre) para selects del detalle de documentos.
 * Solo artículos activos. Devuelve un máximo de 50 coincidencias.
 */
@RestController
@RequestMapping("/api/core/articulos")
@RequiredArgsConstructor
public class ArticuloLookupController {

    private final JdbcTemplate jdbcTemplate;

    public record ArticuloItem(Long id, String codigo, String nombre) {}

    @GetMapping("/buscar")
    public ApiResponse<List<ArticuloItem>> buscar(@RequestParam(required = false) String q) {
        String term = q == null ? "" : q.trim();
        String like = "%" + term + "%";
        List<ArticuloItem> data = jdbcTemplate.query(
                """
                SELECT id, codigo, nombre
                FROM core.articulo
                WHERE flag_estado = '1'
                  AND (? = '' OR codigo ILIKE ? OR nombre ILIKE ?)
                ORDER BY codigo
                LIMIT 50
                """,
                (rs, i) -> new ArticuloItem(rs.getLong("id"), rs.getString("codigo"), rs.getString("nombre")),
                term, like, like);
        return ApiResponse.ok(data, "Articulos");
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
