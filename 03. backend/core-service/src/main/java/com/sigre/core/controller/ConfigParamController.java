package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

/**
 * Get/Set genérico de un parámetro de texto en config.configuracion (esquema config del tenant),
 * usando las funciones config.fn_get_parametro_txt / config.fn_set_parametro_txt. Usado, p.ej.,
 * para persistir preferencias de UI por usuario+ventana (orden de columnas, tamaño de página).
 * Clave = parámetro; el módulo agrupa estas preferencias bajo 'UI'. Es por empresa (BD tenant).
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
    @Transactional
    public ApiResponse<String> getParam(@RequestParam String clave) {
        String valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_txt(?, ?, NULL)", String.class, MODULO_UI, clave);
        return ApiResponse.ok(valor, "Parametro");
    }

    /** Graba (upsert) el valor_texto del parámetro vía config.fn_set_parametro_txt. */
    @PutMapping("/param")
    @Transactional
    public ApiResponse<String> saveParam(@RequestBody ParamSaveRequest req) {
        String valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_set_parametro_txt(?, ?, ?)", String.class, MODULO_UI, req.clave(), req.valor());
        return ApiResponse.ok(valor, "Parametro guardado");
    }
}
