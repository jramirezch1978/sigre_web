package com.sigre.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.sigre.finanzas.dto.response.UsuarioResponse;
import com.sigre.common.dto.ApiResponse;

@FeignClient(
    name = "seguridad-service",
    url = "${api.gateway.url}",
    path = "/api/auth",
    configuration = com.sigre.finanzas.config.FeignConfig.class
)
public interface AuthSecurityClient {
    
    @GetMapping("/usuarios/{id}")
    ApiResponse<UsuarioResponse> obtenerUsuarioPorId(@PathVariable("id") Long id);
}
