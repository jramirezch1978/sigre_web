package pe.restaurant.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.client.dto.ValeMovResponse;
import pe.restaurant.produccion.config.FeignConfig;

@FeignClient(
    name = "ms-almacen",
    url = "${client.ms-almacen.url:${api.gateway.url}}",
    path = "/api/almacen",
    configuration = FeignConfig.class
)
public interface AlmacenValeMovClient {

    @GetMapping("/movimientos/{id}")
    ApiResponse<ValeMovResponse> obtenerPorId(@PathVariable("id") Long id);
}
