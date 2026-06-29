package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;

/**
 * Get/Set genérico de un parámetro de texto de core.configuracion (por clave).
 * Usado, p.ej., para persistir el ordenamiento de tablas por usuario+ventana
 * (clave ORDER_[USERID]_[CODIGO_VENTANA]). La configuración es por empresa (BD tenant).
 */
@RestController
@RequestMapping("/api/core/config")
@RequiredArgsConstructor
public class ConfigParamController {

    private final JdbcTemplate jdbcTemplate;

    public record ParamSaveRequest(String clave, String valor) {}

    /** Devuelve el value_text del parámetro (null si no existe / vacío). */
    @GetMapping("/param")
    public ApiResponse<String> getParam(@RequestParam String clave) {
        String valor = jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_txt(?, NULL)", String.class, clave);
        return ApiResponse.ok(valor, "Parametro");
    }

    /** Upsert del value_text del parámetro. */
    @PutMapping("/param")
    public ApiResponse<String> saveParam(@RequestBody ParamSaveRequest req) {
        int updated = jdbcTemplate.update(
                "UPDATE core.configuracion SET value_text = ?, fec_modificacion = NOW() WHERE parameter = ?",
                req.valor(), req.clave());
        if (updated == 0) {
            jdbcTemplate.update(
                    "INSERT INTO core.configuracion (parameter, data_type, value_text, fec_creacion) VALUES (?, 'TEXT', ?, NOW())",
                    req.clave(), req.valor());
        }
        return ApiResponse.ok(req.valor(), "Parametro guardado");
    }
}
