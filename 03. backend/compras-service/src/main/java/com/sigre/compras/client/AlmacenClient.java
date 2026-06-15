package com.sigre.compras.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.sigre.common.dto.ApiResponse;
import com.sigre.compras.dto.IntegracionRecepcionOcRequest;
import com.sigre.compras.dto.MovimientoDetalleResponse;

@FeignClient(
        name = "almacen-service",
        url = "${feign.client.config.almacen-service.url:http://almacen-service:9003}",
        path = "/api/almacen",
        configuration = com.sigre.compras.config.FeignConfig.class
)
public interface AlmacenClient {

    @PostMapping("/integraciones/recepcion-orden-compra")
    ApiResponse<MovimientoDetalleResponse> recepcionOrdenCompra(@RequestBody IntegracionRecepcionOcRequest request);
}
