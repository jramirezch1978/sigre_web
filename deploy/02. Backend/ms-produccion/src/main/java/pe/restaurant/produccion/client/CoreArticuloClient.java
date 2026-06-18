package pe.restaurant.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.client.dto.ArticuloResponse;
import pe.restaurant.produccion.config.FeignConfig;

@FeignClient(
    name = "ms-core-maestros",
    contextId = "coreArticuloClient",
    url = "${client.ms-core-maestros.url:${api.gateway.url}}",
    path = "/api/core",
    configuration = FeignConfig.class
)
public interface CoreArticuloClient {

    @GetMapping("/articulos/{id}")
    ApiResponse<ArticuloResponse> obtenerPorId(@PathVariable("id") Long id);
}
