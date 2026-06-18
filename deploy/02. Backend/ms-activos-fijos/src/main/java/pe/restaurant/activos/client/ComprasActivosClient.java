package pe.restaurant.activos.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.restaurant.activos.client.dto.compras.OrdenCompraDetalleResponse;
import pe.restaurant.activos.client.dto.compras.RecepcionResumenResponse;
import pe.restaurant.activos.config.FeignConfig;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

/**
 * Cliente saliente hacia {@code ms-compras} para validar orden de compra y líneas
 * al dar de alta un activo desde compras.
 */
@FeignClient(
        name = "ms-compras",
        url = "${feign.client.config.ms-compras.url:http://localhost:9005}",
        path = "/api/compras",
        configuration = FeignConfig.class
)
public interface ComprasActivosClient {

    @GetMapping("/ordenes-compra/{id}")
    ApiResponse<OrdenCompraDetalleResponse> obtenerOrdenCompra(@PathVariable("id") Long id);

    @GetMapping("/ordenes-compra/{id}/recepciones")
    ApiResponse<List<RecepcionResumenResponse>> listarRecepciones(@PathVariable("id") Long id);
}
