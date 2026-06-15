package com.sigre.produccion.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.testdata.ProduccionTestDataFactory;

import java.util.Map;

@RestController
@RequestMapping("/api/produccion/test")
@RequiredArgsConstructor
public class TestSeedController {

    private final ProduccionTestDataFactory factory;

    @PostMapping("/seed")
    public ApiResponse<Map<String, Object>> seed() {
        Map<String, Object> data = factory.ensurePlanificacionData();
        return ApiResponse.ok(data, "Datos de prueba generados");
    }

    @GetMapping("/seed/status")
    public ApiResponse<Map<String, Object>> status() {
        return ApiResponse.ok(factory.statusData());
    }
}
