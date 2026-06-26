package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.activos.dto.AfMaestroDesdeCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeFacturaCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeRecepcionRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.mapper.AfMaestroMapper;
import pe.restaurant.activos.service.ComprasIntegracionService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/integracion")
@RequiredArgsConstructor
public class AfIntegracionController {

    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ComprasIntegracionService comprasIntegracionService;
    private final AfMaestroMapper maestroMapper;

    @PostMapping("/contabilidad/depreciacion/{calculoId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarDepreciacion(@PathVariable Long calculoId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarDepreciacion(calculoId),
                "Depreciación contabilizada");
    }

    @PostMapping("/contabilidad/devengo/{devengoId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarDevengo(@PathVariable Long devengoId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarDevengoPrima(devengoId),
                "Devengo de prima contabilizado");
    }

    @PostMapping("/contabilidad/venta/{ventaId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarVenta(@PathVariable Long ventaId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarVenta(ventaId),
                "Venta/baja contabilizada");
    }

    @PostMapping("/contabilidad/valuacion/{valuacionId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarValuacion(@PathVariable Long valuacionId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarValuacion(valuacionId),
                "Valuación contabilizada");
    }

    @PostMapping("/contabilidad/alta/{maestroId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarAlta(@PathVariable Long maestroId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarAltaActivo(maestroId),
                "Alta de activo contabilizada");
    }

    @PostMapping("/contabilidad/adaptacion/{adaptacionId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarAdaptacion(@PathVariable Long adaptacionId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarAdaptacion(adaptacionId),
                "Adaptación contabilizada");
    }

    @PostMapping("/contabilidad/baja/{maestroId}")
    public ApiResponse<IntegracionContabilidadResult> contabilizarBaja(@PathVariable Long maestroId) {
        return ApiResponse.ok(contabilidadIntegracionService.contabilizarBajaActivo(maestroId),
                "Baja de activo contabilizada");
    }

    @GetMapping("/contabilidad/trazabilidad")
    public ApiResponse<IntegracionContabilidadResult> trazabilidad(
            @RequestParam String moduloOrigen,
            @RequestParam Long documentoOrigenId) {
        return ApiResponse.ok(contabilidadIntegracionService.consultarTrazabilidad(moduloOrigen, documentoOrigenId));
    }

    @PostMapping("/compras/maestro-desde-orden-compra")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfMaestroResponse> crearMaestroDesdeOrdenCompra(
            @Valid @RequestBody AfMaestroDesdeCompraRequest request) {
        var entity = comprasIntegracionService.crearMaestroDesdeOrdenCompra(request);
        return ApiResponse.ok(maestroMapper.toResponse(entity), "Activo creado desde orden de compra");
    }

    @PostMapping("/compras/maestro-desde-recepcion")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfMaestroResponse> crearMaestroDesdeRecepcion(
            @Valid @RequestBody AfMaestroDesdeRecepcionRequest request) {
        var entity = comprasIntegracionService.crearMaestroDesdeRecepcion(request);
        return ApiResponse.ok(maestroMapper.toResponse(entity), "Activo creado desde recepción de compra");
    }

    @PostMapping("/compras/maestro-desde-factura")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfMaestroResponse> crearMaestroDesdeFactura(
            @Valid @RequestBody AfMaestroDesdeFacturaCompraRequest request) {
        var entity = comprasIntegracionService.crearMaestroDesdeFacturaCompra(request);
        return ApiResponse.ok(maestroMapper.toResponse(entity), "Activo creado desde factura de compra");
    }
}
