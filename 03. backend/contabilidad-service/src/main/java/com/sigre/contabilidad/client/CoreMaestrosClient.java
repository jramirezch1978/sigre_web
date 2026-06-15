package com.sigre.contabilidad.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.sigre.common.dto.ApiResponse;
import com.sigre.contabilidad.dto.response.PlanContableDetResponse;

@FeignClient(
    name = "core-service",
    url = "${feign.client.config.core-service.url:http://localhost:9002}",
    path = "/api/core",
    configuration = com.sigre.contabilidad.config.FeignConfig.class
)
public interface CoreMaestrosClient {
    
    @GetMapping("/plan-contable-det/{id}")
    ApiResponse<PlanContableDetResponse> obtenerPlanContableDetPorId(@PathVariable("id") Long id);
}
