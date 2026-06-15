package com.sigre.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.client.dto.ValeMovResponse;
import com.sigre.produccion.config.FeignConfig;

@FeignClient(
    name = "almacen-service",
    url = "${client.almacen-service.url:${api.gateway.url}}",
    path = "/api/almacen",
    configuration = FeignConfig.class
)
public interface AlmacenValeMovClient {

    @GetMapping("/movimientos/{id}")
    ApiResponse<ValeMovResponse> obtenerPorId(@PathVariable("id") Long id);
}
