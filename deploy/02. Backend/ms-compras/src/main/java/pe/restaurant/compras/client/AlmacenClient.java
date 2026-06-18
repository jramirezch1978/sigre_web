package pe.restaurant.compras.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.IntegracionRecepcionOcRequest;
import pe.restaurant.compras.dto.MovimientoDetalleResponse;

@FeignClient(
        name = "ms-almacen",
        url = "${feign.client.config.ms-almacen.url:http://localhost:9003}",
        path = "/api/almacen",
        configuration = pe.restaurant.compras.config.FeignConfig.class
)
public interface AlmacenClient {

    @PostMapping("/integraciones/recepcion-orden-compra")
    ApiResponse<MovimientoDetalleResponse> recepcionOrdenCompra(@RequestBody IntegracionRecepcionOcRequest request);
}
