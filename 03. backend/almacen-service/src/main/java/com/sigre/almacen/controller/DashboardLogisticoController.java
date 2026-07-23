package com.sigre.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.almacen.dto.DashboardLogisticoResponse;
import com.sigre.almacen.service.DashboardLogisticoService;
import com.sigre.common.dto.ApiResponse;

/**
 * Dashboard logístico (Hermes / móvil): valorización, ingresos/salidas activos y PT.
 */
@RestController
@RequestMapping("/api/almacen/dashboard")
@RequiredArgsConstructor
public class DashboardLogisticoController {

    private final DashboardLogisticoService dashboardLogisticoService;

    @GetMapping("/logistico")
    public ApiResponse<DashboardLogisticoResponse> logistico(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(dashboardLogisticoService.resumen(sucursalId), "Dashboard logístico");
    }
}
