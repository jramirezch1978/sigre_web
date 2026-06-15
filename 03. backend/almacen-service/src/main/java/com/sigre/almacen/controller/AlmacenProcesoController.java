package com.sigre.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.ProcesoAlmacenFiltroRequest;
import com.sigre.almacen.dto.ProcesoAlmacenResponse;
import com.sigre.almacen.service.AlmacenProcesoService;
import com.sigre.common.dto.ApiResponse;

/**
 * Procesos batch — códigos de menú {@code ALMACEN_PROC_*} (bloque D).
 */
@RestController
@RequestMapping("/api/almacen/procesos")
@RequiredArgsConstructor
public class AlmacenProcesoController {

    private final AlmacenProcesoService procesoService;

    @PostMapping("/recalculo-precios-promedio")
    public ApiResponse<ProcesoAlmacenResponse> recalculoPreciosPromedio(
            @RequestBody(required = false) ProcesoAlmacenFiltroRequest filtro) {
        return ApiResponse.ok(procesoService.recalcularPreciosPromedio(filtro));
    }

    @PostMapping("/cuadre-stock")
    public ApiResponse<ProcesoAlmacenResponse> cuadreStock(
            @RequestBody(required = false) ProcesoAlmacenFiltroRequest filtro) {
        return ApiResponse.ok(procesoService.cuadrarStockVsPosiciones(filtro));
    }

    @PostMapping("/actualizacion-automatica")
    public ApiResponse<ProcesoAlmacenResponse> actualizacionAutomatica(
            @RequestBody(required = false) ProcesoAlmacenFiltroRequest filtro) {
        return ApiResponse.ok(procesoService.actualizacionAutomatica(filtro));
    }
}
