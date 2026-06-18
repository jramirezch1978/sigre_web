package pe.restaurant.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.client.dto.UsuarioResponse;
import pe.restaurant.produccion.config.FeignConfig;

@FeignClient(
    name = "ms-auth-security",
    url = "${api.gateway.url}",
    path = "/api/auth",
    configuration = FeignConfig.class
)
public interface AuthUsuarioClient {

    @GetMapping("/seguridad/usuarios/{id}")
    ApiResponse<UsuarioResponse> obtenerPorId(@PathVariable("id") Long id);
}
