package pe.restaurant.activos.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import pe.restaurant.activos.client.dto.contabilidad.AsientoRequest;
import pe.restaurant.activos.client.dto.contabilidad.AsientoResponse;
import pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest;
import pe.restaurant.activos.client.dto.contabilidad.GenerarPreasientoResponse;
import pe.restaurant.activos.config.FeignConfig;
import pe.restaurant.common.dto.ApiResponse;

/**
 * Cliente saliente hacia {@code ms-contabilidad} para crear y consultar asientos
 * originados en activos fijos (depreciación, devengo, venta, valuación).
 * <p>
 * Los 4 endpoints de AF generan <b>pre-asientos</b> (libro PA). Para convertirlos
 * en asientos definitivos, usar el endpoint {@code POST /generar/importar} directamente.
 */
@FeignClient(
        name = "ms-contabilidad",
        url = "${client.ms-contabilidad.url:${api.gateway.url}}",
        path = "/api/contabilidad/asientos",
        configuration = FeignConfig.class
)
public interface ContabilidadAsientosClient {

    @GetMapping("/{id}")
    ApiResponse<AsientoResponse> obtenerAsientoPorId(@PathVariable("id") Long id);

    @GetMapping("/buscar")
    ApiResponse<AsientoResponse> buscarPorOrigen(
            @RequestParam("moduloOrigen") String moduloOrigen,
            @RequestParam("documentoOrigenId") Long documentoOrigenId);

    @PostMapping
    ApiResponse<AsientoResponse> crear(@RequestBody AsientoRequest request);

    @PostMapping("/generar/af-depreciacion")
    ApiResponse<GenerarPreasientoResponse> generarDepreciacion(@RequestBody GenerarAsientoRequest request);

    @PostMapping("/generar/af-revaluacion")
    ApiResponse<GenerarPreasientoResponse> generarRevaluacion(@RequestBody GenerarAsientoRequest request);

    @PostMapping("/generar/af-indexacion")
    ApiResponse<GenerarPreasientoResponse> generarIndexacion(@RequestBody GenerarAsientoRequest request);

    @PostMapping("/generar/af-devengo-seguros")
    ApiResponse<GenerarPreasientoResponse> generarDevengoSeguros(@RequestBody GenerarAsientoRequest request);
}
