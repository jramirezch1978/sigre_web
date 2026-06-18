package pe.restaurant.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.finanzas.dto.response.UsuarioResponse;
import pe.restaurant.common.dto.ApiResponse;

@FeignClient(
    name = "ms-auth-security",
    url = "${api.gateway.url}",
    path = "/api/auth",
    configuration = pe.restaurant.finanzas.config.FeignConfig.class
)
public interface AuthSecurityClient {
    
    @GetMapping("/usuarios/{id}")
    ApiResponse<UsuarioResponse> obtenerUsuarioPorId(@PathVariable("id") Long id);
}
