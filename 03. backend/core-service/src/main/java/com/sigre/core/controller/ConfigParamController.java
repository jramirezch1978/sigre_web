package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

/**
 * Get/Set genérico de un parámetro de texto en config.configuracion (esquema config del tenant).
 * Usado, p.ej., para persistir preferencias de UI por usuario+ventana (orden de columnas, tamaño
 * de página). Clave = parámetro; el módulo agrupa estas preferencias bajo 'UI'.
 * La configuración es por empresa (cada BD tenant tiene su propio esquema config).
 */
@RestController
@RequestMapping("/api/core/config")
@RequiredArgsConstructor
public class ConfigParamController {

    /** Módulo bajo el que se agrupan las preferencias de interfaz en config.configuracion. */
    private static final String MODULO_UI = "UI";

    private final JdbcTemplate jdbcTemplate;

    public record ParamSaveRequest(String clave, String valor) {}

    /** Devuelve el valor_texto del parámetro (null si no existe / vacío). */
    @GetMapping("/param")
    public ApiResponse<String> getParam(@RequestParam String clave) {
        String valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_txt(?, ?, NULL)", String.class, MODULO_UI, clave);
        return ApiResponse.ok(valor, "Parametro");
    }

    /** Upsert del valor_texto del parámetro en config.configuracion (clave única modulo+parametro). */
    @PutMapping("/param")
    public ApiResponse<String> saveParam(@RequestBody ParamSaveRequest req) {
        jdbcTemplate.update(
                """
                INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable, activo, modificado_en)
                VALUES (?, ?, 'TEXT', ?, TRUE, TRUE, NOW())
                ON CONFLICT (modulo, parametro)
                DO UPDATE SET valor_texto = EXCLUDED.valor_texto, activo = TRUE, modificado_en = NOW()
                """,
                MODULO_UI, req.clave(), req.valor());
        return ApiResponse.ok(req.valor(), "Parametro guardado");
    }
}
