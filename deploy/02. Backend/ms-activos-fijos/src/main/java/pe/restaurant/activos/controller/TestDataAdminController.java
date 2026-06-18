package pe.restaurant.activos.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.activos.service.TestDataSeedService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.Map;

/**
 * Endpoint admin para cargar datos de demostración en el tenant actual (esquema {@code activos}).
 * Solo se registra si {@code app.testdata.enabled=true}. En producción usar {@code APP_TESTDATA_ENABLED=false}.
 */
@RestController
@RequestMapping("/api/activos/admin/test-data")
@RequiredArgsConstructor
@ConditionalOnProperty(name = "app.testdata.enabled", havingValue = "true")
public class TestDataAdminController {

    private final TestDataSeedService seedService;

    @PostMapping("/seed")
    public ApiResponse<Map<String, Integer>> seed() {
        return ApiResponse.ok(seedService.seedActivosDemoData(), "Datos de prueba activos fijos creados");
    }
}
