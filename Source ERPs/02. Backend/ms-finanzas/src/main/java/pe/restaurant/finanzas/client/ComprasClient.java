package pe.restaurant.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.request.ActualizarCantFacturadaRequest;
import pe.restaurant.finanzas.dto.request.AjusteStockRequest;

@FeignClient(
    name = "ms-compras",
    url = "${client.ms-compras.url:${api.gateway.url}}",
    path = "/api/compras",
    configuration = pe.restaurant.finanzas.config.FeignConfig.class
)
public interface ComprasClient {

    @PostMapping("/ordenes-compra/actualizar-cantidades-facturadas")
    ApiResponse<Void> actualizarCantFacturada(@RequestBody ActualizarCantFacturadaRequest request);

    @PostMapping("/ordenes-compra/ajustar-stock")
    ApiResponse<Void> ajustarStockPorNota(@RequestBody AjusteStockRequest request);
}
