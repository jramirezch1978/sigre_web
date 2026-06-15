package com.sigre.seguridad.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.seguridad.dto.seguridad.AdminDashboardTelemetryResponse;
import com.sigre.seguridad.service.AdminDashboardTelemetryService;
import com.sigre.seguridad.service.SeguridadService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import com.sigre.common.dto.ApiResponse;

/**
 * Métricas agregadas para el panel de administración (BD security, solo lectura).
 */
@RestController
@RequestMapping("/api/auth/seguridad")
@RequiredArgsConstructor
public class AdminDashboardController {

    private final SeguridadContextHelper contextHelper;
    private final SeguridadService seguridadService;
    private final AdminDashboardTelemetryService telemetryService;

    @GetMapping("/admin/dashboard-telemetry")
    public ApiResponse<AdminDashboardTelemetryResponse> dashboardTelemetry(
            @RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long emp = contextHelper.requireEmpresaIdFromToken(auth);
        seguridadService.requireAdmin(uid, emp);
        return ApiResponse.ok(telemetryService.cargar(), "Telemetría del panel");
    }
}
