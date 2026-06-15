package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.comercializacion.service.TestDataSeedService;

import java.util.Map;

/**
 * Admin endpoint to seed demo data for local/testing environments.
 *
 * <p>La ruta siempre está registrada para evitar 404 confusos; si {@code app.testdata.enabled}
 * es falso, la petición responde 403 con código {@code TESTDATA_DISABLED}.</p>
 */
@RestController
@RequestMapping("/api/ventas/admin/test-data")
@RequiredArgsConstructor
@Tag(name = "Admin — datos de prueba", description = "Seed masivo de tablas ventas (por defecto activo; desactivar con app.testdata.enabled=false o APP_TESTDATA_ENABLED=false)")
public class TestDataAdminController {

    private final TestDataSeedService seedService;

    @Value("${app.testdata.enabled:true}")
    private boolean testDataEnabled;

    @PostMapping("/seed")
    @Operation(
            summary = "Seed demo ventas",
            description = "Inserta datos de demostración en tablas del esquema ventas. Si el seed está desactivado en configuración, responde 403 TESTDATA_DISABLED.")
    public ApiResponse<Map<String, Integer>> seed() {
        if (!testDataEnabled) {
            throw new BusinessException(
                    "Datos de prueba deshabilitados: establezca app.testdata.enabled=true o APP_TESTDATA_ENABLED=true y reinicie comercializacion-service.",
                    HttpStatus.FORBIDDEN,
                    "TESTDATA_DISABLED");
        }
        return ApiResponse.ok(seedService.seedVentasDemoData(), "Datos de prueba creados");
    }
}

