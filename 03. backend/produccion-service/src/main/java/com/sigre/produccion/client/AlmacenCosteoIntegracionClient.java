package com.sigre.produccion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.client.dto.ProcesoCosteoAlmacenResponse;
import com.sigre.produccion.config.FeignConfig;
import com.sigre.produccion.event.CosteoPeriodoProcesadoEvent;

@FeignClient(
        name = "almacen-service-costeo",
        url = "${client.almacen-service.url:${api.gateway.url}}",
        path = "/api/almacen",
        configuration = FeignConfig.class
)
public interface AlmacenCosteoIntegracionClient {

    @PostMapping("/integraciones/produccion/aplicar-costeo")
    ApiResponse<ProcesoCosteoAlmacenResponse> aplicarCosteo(@RequestBody CosteoPeriodoProcesadoEvent request);
}
