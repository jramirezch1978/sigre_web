package com.sigre.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.auth.dto.TenantConnectionInfoResponse;
import com.sigre.auth.service.TenantConnectionService;
import com.sigre.common.dto.ApiResponse;

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
