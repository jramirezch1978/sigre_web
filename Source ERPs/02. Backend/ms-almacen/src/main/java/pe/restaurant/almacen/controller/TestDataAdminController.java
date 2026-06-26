package pe.restaurant.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.almacen.service.TestDataSeedService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.Map;

/**
 * Admin endpoint to seed demo data for local/testing environments.
 *
 * Enabled only when {@code app.testdata.enabled=true}.
 */
@RestController
@RequestMapping("/api/almacen/admin/test-data")
@RequiredArgsConstructor
@ConditionalOnProperty(name = "app.testdata.enabled", havingValue = "true")
public class TestDataAdminController {

    private final TestDataSeedService seedService;

    @PostMapping("/seed")
    public ApiResponse<Map<String, Integer>> seed() {
        return ApiResponse.ok(seedService.seedAlmacenDemoData(), "Datos de prueba creados");
    }
}

