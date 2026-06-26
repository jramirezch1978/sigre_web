package pe.restaurant.core.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.client.dto.PlanContableDetResponse;

@FeignClient(
    name = "ms-contabilidad",
    url = "${feign.client.config.ms-contabilidad.url:http://localhost:9006}",
    path = "/api/contabilidad/plan-contable-det",
    configuration = pe.restaurant.core.config.FeignConfig.class
)
public interface ContabilidadClient {

    @GetMapping("/{id}")
    ApiResponse<PlanContableDetResponse> obtenerPlanContableDet(@PathVariable("id") Long id);
}
