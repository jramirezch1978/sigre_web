package com.sigre.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

import java.util.List;

/**
 * Lookups de plan contable para el selector treeview de cuentas contables:
 * cabecera (planes activos) + árbol de cuentas (5 niveles por longitud de código) + resolución de una cuenta.
 */
@RestController
@RequestMapping("/api/contabilidad/plan-contable")
@RequiredArgsConstructor
@Tag(name = "Plan contable (lookup)", description = "Cabecera + árbol de cuentas contables para selects")
public class PlanContableLookupController {

    private final JdbcTemplate jdbcTemplate;

    public record PlanItem(Long id, String codigo, String nombre, Integer anio) {}

    public record CuentaArbolItem(
            Long id, String cntaCtbl, String descCnta,
            String codN1, String descN1, String codN2, String descN2,
            String codN3, String descN3, String codN4, String descN4) {}

    public record CuentaResumen(Long id, Long planContableId, String cntaCtbl, String descCnta) {}

    @GetMapping("/planes")
    @Operation(summary = "Planes contables activos (cabecera del selector)")
    public ApiResponse<List<PlanItem>> planes() {
        List<PlanItem> data = jdbcTemplate.query(
                """
                SELECT id, codigo, nombre, anio
                FROM contabilidad.plan_contable
                WHERE flag_estado = '1'
                ORDER BY anio DESC, codigo
                """,
                (rs, i) -> new PlanItem(rs.getLong("id"), rs.getString("codigo"),
                        rs.getString("nombre"), rs.getInt("anio")));
        return ApiResponse.ok(data, "Planes contables");
    }

    @GetMapping("/arbol")
    @Operation(summary = "Cuentas (hoja, 8 dígitos) activas del plan con su jerarquía de 5 niveles")
    public ApiResponse<List<CuentaArbolItem>> arbol(@RequestParam Long planContableId) {
        List<CuentaArbolItem> data = jdbcTemplate.query(
                """
                SELECT cc5.id, cc5.cnta_ctbl, cc5.desc_cnta,
                       cc1.cnta_ctbl AS cod_n1, cc1.desc_cnta AS desc_n1,
                       cc2.cnta_ctbl AS cod_n2, cc2.desc_cnta AS desc_n2,
                       cc3.cnta_ctbl AS cod_n3, cc3.desc_cnta AS desc_n3,
                       cc4.cnta_ctbl AS cod_n4, cc4.desc_cnta AS desc_n4
                FROM contabilidad.plan_contable_det cc5
                LEFT JOIN contabilidad.plan_contable_det cc1
                       ON cc1.plan_contable_id = cc5.plan_contable_id AND TRIM(cc1.cnta_ctbl) = SUBSTR(cc5.cnta_ctbl, 1, 2)
                LEFT JOIN contabilidad.plan_contable_det cc2
                       ON cc2.plan_contable_id = cc5.plan_contable_id AND TRIM(cc2.cnta_ctbl) = SUBSTR(cc5.cnta_ctbl, 1, 3)
                LEFT JOIN contabilidad.plan_contable_det cc3
                       ON cc3.plan_contable_id = cc5.plan_contable_id AND TRIM(cc3.cnta_ctbl) = SUBSTR(cc5.cnta_ctbl, 1, 5)
                LEFT JOIN contabilidad.plan_contable_det cc4
                       ON cc4.plan_contable_id = cc5.plan_contable_id AND TRIM(cc4.cnta_ctbl) = SUBSTR(cc5.cnta_ctbl, 1, 6)
                WHERE cc5.plan_contable_id = ?
                  AND LENGTH(TRIM(cc5.cnta_ctbl)) = 8
                  AND cc5.flag_estado = '1'
                ORDER BY cc5.cnta_ctbl
                """,
                (rs, i) -> new CuentaArbolItem(
                        rs.getLong("id"), rs.getString("cnta_ctbl"), rs.getString("desc_cnta"),
                        rs.getString("cod_n1"), rs.getString("desc_n1"),
                        rs.getString("cod_n2"), rs.getString("desc_n2"),
                        rs.getString("cod_n3"), rs.getString("desc_n3"),
                        rs.getString("cod_n4"), rs.getString("desc_n4")),
                planContableId);
        return ApiResponse.ok(data, "Árbol de cuentas contables");
    }

    @GetMapping("/det/{id}")
    @Operation(summary = "Resolver una cuenta contable por id (para mostrar el valor seleccionado al editar)")
    public ApiResponse<CuentaResumen> det(@PathVariable Long id) {
        List<CuentaResumen> rows = jdbcTemplate.query(
                """
                SELECT id, plan_contable_id, cnta_ctbl, desc_cnta
                FROM contabilidad.plan_contable_det WHERE id = ?
                """,
                (rs, i) -> new CuentaResumen(rs.getLong("id"), rs.getLong("plan_contable_id"),
                        rs.getString("cnta_ctbl"), rs.getString("desc_cnta")),
                id);
        return ApiResponse.ok(rows.isEmpty() ? null : rows.get(0), "Cuenta contable");
    }
}
