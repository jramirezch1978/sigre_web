package pe.restaurant.ventas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.client.dto.CntasCobrarAsientoRequest;
import pe.restaurant.ventas.client.dto.GenerarAsientoResponse;

@FeignClient(
        name = "ms-contabilidad",
        url = "${client.ms-contabilidad.url:${api.gateway.url}}",
        path = "/api/contabilidad",
        configuration = pe.restaurant.ventas.config.FeignConfig.class
)
public interface ContabilidadGenerarAsientoClient {

    @PostMapping("/asientos/generar/registro-cntas-cobrar")
    ApiResponse<GenerarAsientoResponse> generarRegistroCntasCobrar(@RequestBody CntasCobrarAsientoRequest request);
}

