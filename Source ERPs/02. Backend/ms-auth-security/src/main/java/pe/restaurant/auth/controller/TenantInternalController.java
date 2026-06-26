package pe.restaurant.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.auth.dto.TenantConnectionInfoResponse;
import pe.restaurant.auth.service.TenantConnectionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/internal/tenants")
@RequiredArgsConstructor
public class TenantInternalController {

    private final TenantConnectionService tenantConnectionService;

    @GetMapping("/{empresaId}")
    public ApiResponse<TenantConnectionInfoResponse> getTenantConnection(@PathVariable Long empresaId) {
        TenantConnectionInfoResponse data = tenantConnectionService.getTenantConnection(empresaId);
        return ApiResponse.ok(data, "Datos de conexión del tenant obtenidos correctamente");
    }
}
