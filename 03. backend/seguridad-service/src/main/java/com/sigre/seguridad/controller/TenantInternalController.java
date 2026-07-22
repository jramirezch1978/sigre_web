package com.sigre.seguridad.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
     * Revisa disponibilidad de BDs tenant.
     * <ul>
     *   <li>{@code modo=arranque}: correos por tenant online + resumen a soporte si todos OK
     *       (o alerta de desconexión si alguno cayó).</li>
     *   <li>{@code modo=periodico} (default): recuperación → empresa; caída → soporte.</li>
     * </ul>
     * Lo invoca worker-service al arrancar y cada 30 minutos.
     */
    @PostMapping("/verificar-disponibilidad")
    public ApiResponse<Void> verificarDisponibilidad(
            @RequestParam(value = "modo", defaultValue = "periodico") String modo) {
        if ("arranque".equalsIgnoreCase(modo)) {
            tenantHealthService.verificarArranqueYNotificar();
            return ApiResponse.ok(null, "Verificación de arranque completada");
        }
        tenantHealthService.verificarYNotificar();
        return ApiResponse.ok(null, "Verificación periódica de disponibilidad completada");
    }
}
