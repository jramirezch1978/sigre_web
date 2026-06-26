package pe.restaurant.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.client.dto.ProcesoCosteoAlmacenResponse;
import pe.restaurant.produccion.config.FeignConfig;
import pe.restaurant.produccion.event.CosteoPeriodoProcesadoEvent;

@FeignClient(
        name = "ms-almacen-costeo",
        url = "${client.ms-almacen.url:${api.gateway.url}}",
        path = "/api/almacen",
        configuration = FeignConfig.class
)
public interface AlmacenCosteoIntegracionClient {

    @PostMapping("/integraciones/produccion/aplicar-costeo")
    ApiResponse<ProcesoCosteoAlmacenResponse> aplicarCosteo(@RequestBody CosteoPeriodoProcesadoEvent request);
}
