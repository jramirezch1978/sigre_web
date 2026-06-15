package com.sigre.finanzas.controller;

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
import com.sigre.finanzas.service.TestDataSeedService;

import java.util.Map;

/**
 * Endpoint de administración para inicializar datos de prueba en entornos locales/testing.
 *
 * <p>La ruta siempre está registrada para evitar 404 confusos; si {@code app.testdata.enabled}
 * es falso, la petición responde 403 con código {@code TESTDATA_DISABLED}.</p>
 */
@RestController
@RequestMapping("/api/finanzas/admin/test-data")
@RequiredArgsConstructor
@Tag(name = "Admin — datos de prueba", description = "Seed masivo de tablas finanzas (por defecto activo; desactivar con app.testdata.enabled=false o APP_TESTDATA_ENABLED=false)")
public class TestDataAdminController {

    private final TestDataSeedService seedService;

    @Value("${app.testdata.enabled:true}")
    private boolean testDataEnabled;

    /**
     * Inicializa datos de prueba para el módulo de finanzas.
     * Inserta artículos, matriz contable, libro diario y series de documentos.
     * Si el seed está desactivado en configuración, responde 403 TESTDATA_DISABLED.
     *
     * @return Mapa con el conteo de registros insertados por tabla
     */
    @PostMapping("/seed")
    @Operation(
            summary = "Seed demo finanzas",
            description = "Inserta datos de demostración en tablas del esquema finanzas y dependencias mínimas. Si el seed está desactivado en configuración, responde 403 TESTDATA_DISABLED.")
    public ApiResponse<Map<String, Integer>> seed() {
        if (!testDataEnabled) {
            throw new BusinessException(
                    "Datos de prueba deshabilitados: establezca app.testdata.enabled=true o APP_TESTDATA_ENABLED=true y reinicie finanzas-service.",
                    HttpStatus.FORBIDDEN,
                    "TESTDATA_DISABLED");
        }
        return ApiResponse.ok(seedService.seedFinanzasDemoData(), "Datos de prueba creados");
    }
}
