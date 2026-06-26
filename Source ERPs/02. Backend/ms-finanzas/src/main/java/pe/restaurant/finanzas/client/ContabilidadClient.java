package pe.restaurant.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.request.CajaBancosAsientoRequest;
import pe.restaurant.finanzas.dto.request.CntasPagarAsientoRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionAsientoRequest;
import pe.restaurant.finanzas.dto.response.AsientoContableResponse;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;

@FeignClient(
    name = "ms-contabilidad",
    url = "${client.ms-contabilidad.url:${api.gateway.url}}",
    path = "/api/contabilidad",
    configuration = pe.restaurant.finanzas.config.FeignConfig.class
)
public interface ContabilidadClient {

    @PostMapping("/asientos/generar/cartera-pagos")
    ApiResponse<GenerarAsientoResponse> generarAsientoCarteraPagos(@RequestBody CajaBancosAsientoRequest request);

    @PostMapping("/asientos/generar/cartera-cobros")
    ApiResponse<GenerarAsientoResponse> generarAsientoCarteraCobros(@RequestBody CajaBancosAsientoRequest request);

    @PostMapping("/asientos/generar/transferencias")
    ApiResponse<GenerarAsientoResponse> generarAsientoTransferencias(@RequestBody CajaBancosAsientoRequest request);

    @PostMapping("/asientos/generar/aplicacion-documentos")
    ApiResponse<GenerarAsientoResponse> generarAsientoAplicacionDocumentos(@RequestBody CajaBancosAsientoRequest request);

    @PostMapping("/asientos/generar/registro-cntas-pagar")
    ApiResponse<GenerarAsientoResponse> generarAsientoRegistroCntasPagar(@RequestBody CntasPagarAsientoRequest request);

    @PostMapping("/asientos/generar/canje-documentos")
    ApiResponse<GenerarAsientoResponse> generarAsientoCanjeDocumentos(@RequestBody CntasPagarAsientoRequest request);

    @PostMapping("/asientos/generar/liquidacion-giro")
    ApiResponse<GenerarAsientoResponse> generarAsientoLiquidacionGiro(@RequestBody LiquidacionAsientoRequest request);

    @PostMapping("/asientos/{id}/anular")
    ApiResponse<AsientoContableResponse> anularAsiento(@PathVariable("id") Long id);
}
