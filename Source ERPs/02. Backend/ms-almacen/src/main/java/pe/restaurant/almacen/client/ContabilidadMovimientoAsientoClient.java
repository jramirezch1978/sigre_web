package pe.restaurant.almacen.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.almacen.client.dto.contabilidad.GenerarAsientoRequest;
import pe.restaurant.almacen.client.dto.contabilidad.GenerarPreasientoResponse;
import pe.restaurant.almacen.config.FeignConfig;
import pe.restaurant.common.dto.ApiResponse;

/**
 * Cliente ms-almacen → ms-contabilidad para la integración contable por concepto financiero (Ruta B).
 * <p>
 * A diferencia de {@link ContabilidadPreAsientoClient} (evento ligero, best-effort), este cliente envía
 * el detalle completo del movimiento ({@code conceptoFinancieroId} + monto por línea) al endpoint que
 * genera el pre-asiento resolviendo la matriz contable por concepto. La invocación es síncrona: un fallo
 * propaga la excepción y revierte el movimiento de almacén.
 */
@FeignClient(
        name = "ms-contabilidad-movimiento-asiento",
        url = "${client.ms-contabilidad.url:${api.gateway.url}}",
        path = "/api/contabilidad/asientos/generar",
        configuration = FeignConfig.class
)
public interface ContabilidadMovimientoAsientoClient {

    @PostMapping("/almacen-ingreso")
    ApiResponse<GenerarPreasientoResponse> generarPreasientoIngreso(@RequestBody GenerarAsientoRequest request);

    @PostMapping("/almacen-consumo")
    ApiResponse<GenerarPreasientoResponse> generarPreasientoConsumo(@RequestBody GenerarAsientoRequest request);
}
