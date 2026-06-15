package com.sigre.comercializacion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.client.dto.IntegracionSalidaOvRequest;
import com.sigre.comercializacion.client.dto.MovimientoDetalleResponse;
import com.sigre.comercializacion.config.FeignConfig;

@FeignClient(
        name = "almacen-service",
        url = "${feign.client.config.almacen-service.url:http://almacen-service:9003}",
        path = "/api/almacen",
        configuration = FeignConfig.class
)
public interface AlmacenClient {

    @PostMapping("/integraciones/salida-orden-venta")
    ApiResponse<MovimientoDetalleResponse> salidaOrdenVenta(@RequestBody IntegracionSalidaOvRequest request);
}
