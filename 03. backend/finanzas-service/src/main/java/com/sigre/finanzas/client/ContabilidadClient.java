package com.sigre.finanzas.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.request.CajaBancosAsientoRequest;
import com.sigre.finanzas.dto.request.CntasPagarAsientoRequest;
import com.sigre.finanzas.dto.request.LiquidacionAsientoRequest;
import com.sigre.finanzas.dto.response.AsientoContableResponse;
import com.sigre.finanzas.dto.response.GenerarAsientoResponse;

@FeignClient(
    name = "contabilidad-service",
    url = "${client.contabilidad-service.url:${api.gateway.url}}",
    path = "/api/contabilidad",
    configuration = com.sigre.finanzas.config.FeignConfig.class
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
