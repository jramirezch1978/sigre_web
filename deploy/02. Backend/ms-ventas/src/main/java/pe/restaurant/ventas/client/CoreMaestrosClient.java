package pe.restaurant.ventas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.client.dto.MonedaResponse;
import pe.restaurant.ventas.client.dto.TipoCambioResponse;
import pe.restaurant.ventas.config.FeignConfig;

import java.time.LocalDate;

@FeignClient(
    name = "ms-core-maestros",
    url = "${client.ms-core-maestros.url:${api.gateway.url}}",
    path = "/api/core",
    configuration = FeignConfig.class
)
public interface CoreMaestrosClient {

    @GetMapping("/monedas/{id}")
    ApiResponse<MonedaResponse> obtenerMonedaPorId(@PathVariable("id") Long id);

    @GetMapping("/tipos-cambio/ultimo-por-fecha")
    ApiResponse<TipoCambioResponse> obtenerUltimoTipoCambioPorFecha(
            @RequestParam("fecha") LocalDate fecha,
            @RequestParam("monedaId") Long monedaId);
}
