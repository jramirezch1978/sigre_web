package pe.restaurant.ventas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.client.dto.IntegracionSalidaOvRequest;
import pe.restaurant.ventas.client.dto.MovimientoDetalleResponse;
import pe.restaurant.ventas.config.FeignConfig;

@FeignClient(
        name = "ms-almacen",
        url = "${feign.client.config.ms-almacen.url:http://localhost:9003}",
        path = "/api/almacen",
        configuration = FeignConfig.class
)
public interface AlmacenClient {

    @PostMapping("/integraciones/salida-orden-venta")
    ApiResponse<MovimientoDetalleResponse> salidaOrdenVenta(@RequestBody IntegracionSalidaOvRequest request);
}
