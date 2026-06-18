package pe.restaurant.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.auth.dto.seguridad.AdminDashboardTelemetryResponse;
import pe.restaurant.auth.service.AdminDashboardTelemetryService;
import pe.restaurant.auth.service.SeguridadService;
import pe.restaurant.auth.support.SeguridadContextHelper;
import pe.restaurant.common.dto.ApiResponse;

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
