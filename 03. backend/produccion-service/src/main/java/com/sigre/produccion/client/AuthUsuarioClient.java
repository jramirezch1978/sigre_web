package com.sigre.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.client.dto.UsuarioResponse;
import com.sigre.produccion.config.FeignConfig;

@FeignClient(
    name = "seguridad-service",
    url = "${api.gateway.url}",
    path = "/api/auth",
    configuration = FeignConfig.class
)
public interface AuthUsuarioClient {

    @GetMapping("/seguridad/usuarios/{id}")
    ApiResponse<UsuarioResponse> obtenerPorId(@PathVariable("id") Long id);
}
