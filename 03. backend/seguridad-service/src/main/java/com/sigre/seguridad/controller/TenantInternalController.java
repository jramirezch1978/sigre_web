package com.sigre.seguridad.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.seguridad.dto.TenantConnectionInfoResponse;
import com.sigre.seguridad.service.TenantConnectionService;
import com.sigre.seguridad.service.TenantHealthService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/internal/tenants")
@RequiredArgsConstructor
public class TenantInternalController {

    private final TenantConnectionService tenantConnectionService;
    private final TenantHealthService tenantHealthService;

    @GetMapping("/{empresaId}")
    public ApiResponse<TenantConnectionInfoResponse> getTenantConnection(@PathVariable Long empresaId) {
        TenantConnectionInfoResponse data = tenantConnectionService.getTenantConnection(empresaId);
        return ApiResponse.ok(data, "Datos de conexión del tenant obtenidos correctamente");
    }

    /**
     * Revisa la disponibilidad de todas las BDs tenant y avisa por correo a los admins de
     * las que acaban de volver en línea. Lo llama worker-service de forma agendada (ver
     * TenantHealthWorker) — endpoint interno, sin autenticación (red interna Docker).
     */
    @PostMapping("/verificar-disponibilidad")
    public ApiResponse<Void> verificarDisponibilidad() {
        tenantHealthService.verificarYNotificar();
        return ApiResponse.ok(null, "Verificación de disponibilidad completada");
    }
}
