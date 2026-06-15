package com.sigre.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.client.dto.UnidadMedidaResponse;
import com.sigre.produccion.config.FeignConfig;

@FeignClient(
    name = "ms-core-maestros",
    contextId = "coreUnidadMedidaClient",
    url = "${client.ms-core-maestros.url:${api.gateway.url}}",
    path = "/api/core",
    configuration = FeignConfig.class
)
public interface CoreUnidadMedidaClient {

    @GetMapping("/unidades-medida/{id}")
    ApiResponse<UnidadMedidaResponse> obtenerPorId(@PathVariable("id") Long id);
}
