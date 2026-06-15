package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.event.CosteoPeriodoProcesadoEvent;
import com.sigre.almacen.service.IntegracionAlmacenService;
import com.sigre.almacen.service.ProduccionCosteoAlmacenService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.security.TenantContext;
import com.sigre.common.util.Constants;

/**
 * Bloque F — integraciones que delegan en movimientos de vale ({@code ValeMovService.crear}).
 */
@RestController
@RequestMapping("/api/almacen/integraciones")
@RequiredArgsConstructor
public class IntegracionAlmacenController {

    private final IntegracionAlmacenService integracionAlmacenService;
    private final ProduccionCosteoAlmacenService produccionCosteoAlmacenService;

    @PostMapping("/recepcion-orden-compra")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MovimientoDetalleResponse> recepcionOrdenCompra(
            @Valid @RequestBody IntegracionRecepcionOcRequest request) {
        return ApiResponse.ok(integracionAlmacenService.recepcionarOrdenCompra(request), "Ingreso por OC generado");
    }

    @PostMapping("/salida-orden-venta")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MovimientoDetalleResponse> salidaOrdenVenta(
            @Valid @RequestBody IntegracionSalidaOvRequest request) {
        return ApiResponse.ok(integracionAlmacenService.despacharOrdenVenta(request), "Salida por OV generada");
    }

    @PostMapping("/traslado-ejecutar")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<IntegracionTrasladoResultadoResponse> ejecutarTraslado(
            @Valid @RequestBody IntegracionTrasladoEjecutarRequest request) {
        return ApiResponse.ok(integracionAlmacenService.ejecutarTraslado(request), "Traslado ejecutado");
    }

    @PostMapping("/produccion/aplicar-costeo")
    @ResponseStatus(HttpStatus.OK)
    public ApiResponse<ProcesoCosteoAlmacenResponse> aplicarCosteoProduccion(
            @Valid @RequestBody IntegracionProduccionCosteoRequest request) {
        CosteoPeriodoProcesadoEvent evento = CosteoPeriodoProcesadoEvent.builder()
                .eventType("produccion.costeo.completado")
                .empresaId(TenantContext.getEmpresaId())
                .sucursalId(TenantContext.getSucursalId())
                .usuarioId(TenantContext.getUsuarioId())
                .moduloOrigen(Constants.MODULO_PRODUCCION)
                .anio(request.getAnio())
                .mes(request.getMes())
                .sucursalFiltroId(request.getSucursalFiltroId())
                .almacenFiltroId(request.getAlmacenFiltroId())
                .totalOtsProcesadas(request.getTotalOtsProcesadas())
                .totalCreadas(request.getTotalCreadas())
                .totalActualizadas(request.getTotalActualizadas())
                .build();
        return ApiResponse.ok(
                produccionCosteoAlmacenService.aplicarCosteoEnAlmacen(evento),
                "Costeo aplicado en almacén");
    }
}
