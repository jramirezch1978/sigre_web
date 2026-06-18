package pe.restaurant.almacen.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.almacen.config.FeignConfig;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.event.PreAsientoEvent;

/**
 * Cliente HTTP ms-almacen → ms-contabilidad para registrar pre-asientos de inventario
 * (ingreso/consumo y costeo de producción). La emisión es best-effort: si ms-contabilidad
 * aún no expone el endpoint, el publisher captura la excepción y solo registra una advertencia.
 */
@FeignClient(
        name = "ms-contabilidad-pre-asiento",
        url = "${client.ms-contabilidad.url:${api.gateway.url}}",
        path = "/api/contabilidad",
        configuration = FeignConfig.class
)
public interface ContabilidadPreAsientoClient {

    @PostMapping("/integraciones/almacen/pre-asiento")
    ApiResponse<Void> registrarPreAsiento(@RequestBody PreAsientoEvent request);
}
