package pe.restaurant.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.ProcesoAlmacenFiltroRequest;
import pe.restaurant.almacen.dto.ProcesoAlmacenResponse;
import pe.restaurant.almacen.service.AlmacenProcesoService;
import pe.restaurant.common.dto.ApiResponse;

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
