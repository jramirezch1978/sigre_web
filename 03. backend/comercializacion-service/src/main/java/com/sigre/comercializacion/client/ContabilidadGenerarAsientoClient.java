package com.sigre.comercializacion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.client.dto.CntasCobrarAsientoRequest;
import com.sigre.comercializacion.client.dto.GenerarAsientoResponse;

@FeignClient(
        name = "contabilidad-service",
        url = "${client.contabilidad-service.url:${api.gateway.url}}",
        path = "/api/contabilidad",
        configuration = com.sigre.comercializacion.config.FeignConfig.class
)
public interface ContabilidadGenerarAsientoClient {

    @PostMapping("/asientos/generar/registro-cntas-cobrar")
    ApiResponse<GenerarAsientoResponse> generarRegistroCntasCobrar(@RequestBody CntasCobrarAsientoRequest request);
}

