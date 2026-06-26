package pe.restaurant.contabilidad.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.response.PlanContableDetResponse;

@FeignClient(
    name = "ms-core-maestros",
    url = "${feign.client.config.ms-core-maestros.url:http://localhost:9002}",
    path = "/api/core",
    configuration = pe.restaurant.contabilidad.config.FeignConfig.class
)
public interface CoreMaestrosClient {
    
    @GetMapping("/plan-contable-det/{id}")
    ApiResponse<PlanContableDetResponse> obtenerPlanContableDetPorId(@PathVariable("id") Long id);
}
