package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;

import java.util.HashMap;
import java.util.Map;

/**
 * Hora del servidor de BASE DE DATOS (no del navegador ni del microservicio),
 * sin zona horaria. Para fijar la fecha de registro de los documentos.
 */
@RestController
@RequestMapping("/api/core/server-time")
@RequiredArgsConstructor
public class ServerTimeController {

    private final JdbcTemplate jdbcTemplate;

    @GetMapping
    public ApiResponse<Map<String, String>> now() {
        String fechaHora = jdbcTemplate.queryForObject(
                "SELECT to_char(now(), 'YYYY-MM-DD\"T\"HH24:MI:SS')", String.class);
        Map<String, String> data = new HashMap<>();
        data.put("fechaHora", fechaHora);
        data.put("fecha", fechaHora != null ? fechaHora.substring(0, 10) : null);
        return ApiResponse.ok(data);
    }
}
