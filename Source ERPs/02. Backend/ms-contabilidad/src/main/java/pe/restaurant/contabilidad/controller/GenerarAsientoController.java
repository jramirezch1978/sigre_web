package pe.restaurant.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.request.*;
import pe.restaurant.contabilidad.dto.response.GenerarAsientoResponse;
import pe.restaurant.contabilidad.dto.response.GenerarPreasientoResponse;
import pe.restaurant.contabilidad.dto.response.ImportarPreasientoResponse;
import pe.restaurant.contabilidad.enums.TipoOperacionContable;
import pe.restaurant.contabilidad.service.GenerarAsientoService;
import pe.restaurant.contabilidad.service.GenerarPreasientoService;

@RestController
@RequestMapping("/api/contabilidad/asientos/generar")
@RequiredArgsConstructor
@Tag(name = "Generación de Asientos Contables",
     description = "Genera asientos contables automáticos a partir de documentos operativos")
public class GenerarAsientoController {

    private final GenerarAsientoService generarAsientoService;
    private final GenerarPreasientoService generarPreasientoService;

    // ── CAJA BANCOS (4 endpoints) ────────────────────────────────────────────────

    @PostMapping("/cartera-pagos")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por cartera de pagos",
               description = "Recibe cabecera caja_bancos + detalle caja_bancos_det")
    public ApiResponse<GenerarAsientoResponse> carteraPagos(
            @Valid @RequestBody CajaBancosAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCajaBancos(TipoOperacionContable.CARTERA_PAGOS, request),
                "Asiento generado por cartera de pagos");
    }

    @PostMapping("/cartera-cobros")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por cartera de cobros",
               description = "Recibe cabecera caja_bancos + detalle caja_bancos_det")
    public ApiResponse<GenerarAsientoResponse> carteraCobros(
            @Valid @RequestBody CajaBancosAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCajaBancos(TipoOperacionContable.CARTERA_COBROS, request),
                "Asiento generado por cartera de cobros");
    }

    @PostMapping("/transferencias")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por transferencia bancaria",
               description = "Recibe cabecera caja_bancos + detalle caja_bancos_det")
    public ApiResponse<GenerarAsientoResponse> transferencias(
            @Valid @RequestBody CajaBancosAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCajaBancos(TipoOperacionContable.TRANSFERENCIA, request),
                "Asiento generado por transferencia bancaria");
    }

    @PostMapping("/aplicacion-documentos")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por aplicación de documentos",
               description = "Recibe cabecera caja_bancos + detalle caja_bancos_det")
    public ApiResponse<GenerarAsientoResponse> aplicacionDocumentos(
            @Valid @RequestBody CajaBancosAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCajaBancos(TipoOperacionContable.APLICACION_DOCUMENTOS, request),
                "Asiento generado por aplicación de documentos");
    }

    // ── CNTAS PAGAR (2 endpoints) ────────────────────────────────────────────────

    @PostMapping("/registro-cntas-pagar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por registro de cuentas por pagar",
               description = "Recibe cabecera cntas_pagar + detalle cntas_pagar_det")
    public ApiResponse<GenerarAsientoResponse> registroCntasPagar(
            @Valid @RequestBody CntasPagarAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCntasPagar(TipoOperacionContable.REGISTRO_CNTAS_PAGAR, request),
                "Asiento generado por registro de cuentas por pagar");
    }

    @PostMapping("/canje-documentos")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por canje de documentos",
               description = "Recibe cabecera cntas_pagar + detalle cntas_pagar_det")
    public ApiResponse<GenerarAsientoResponse> canjeDocumentos(
            @Valid @RequestBody CntasPagarAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCntasPagar(TipoOperacionContable.CANJE_DOCUMENTOS, request),
                "Asiento generado por canje de documentos");
    }

    // ── CNTAS COBRAR (1 endpoint) ────────────────────────────────────────────────

    @PostMapping("/registro-cntas-cobrar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por registro de cuentas por cobrar",
               description = "Recibe cabecera cntas_cobrar + detalle cntas_cobrar_det")
    public ApiResponse<GenerarAsientoResponse> registroCntasCobrar(
            @Valid @RequestBody CntasCobrarAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoCntasCobrar(TipoOperacionContable.REGISTRO_CNTAS_COBRAR, request),
                "Asiento generado por registro de cuentas por cobrar");
    }

    // ── LIQUIDACION (1 endpoint) ─────────────────────────────────────────────────

    @PostMapping("/liquidacion-giro")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar asiento por liquidación de giro",
               description = "Recibe cabecera liquidacion + detalle liquidacion_det")
    public ApiResponse<GenerarAsientoResponse> liquidacionGiro(
            @Valid @RequestBody LiquidacionAsientoRequest request) {
        return ApiResponse.ok(
                generarAsientoService.generarAsientoLiquidacion(TipoOperacionContable.LIQUIDACION_GIRO, request),
                "Asiento generado por liquidación de giro");
    }

    // ── Activos Fijos (generan PRE-ASIENTOS, no asientos finales) ────────────────

    @PostMapping("/af-depreciacion")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por depreciación de activos fijos")
    public ApiResponse<GenerarPreasientoResponse> afDepreciacion(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.AF_DEPRECIACION, request),
                "Pre-asiento generado por depreciación de activos fijos");
    }

    @PostMapping("/af-revaluacion")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por revaluación de activos fijos")
    public ApiResponse<GenerarPreasientoResponse> afRevaluacion(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.AF_REVALUACION, request),
                "Pre-asiento generado por revaluación de activos fijos");
    }

    @PostMapping("/af-indexacion")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por ajuste por inflación de activos fijos")
    public ApiResponse<GenerarPreasientoResponse> afIndexacion(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.AF_INDEXACION, request),
                "Pre-asiento generado por ajuste por inflación de activos fijos");
    }

    @PostMapping("/af-devengo-seguros")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por devengamiento de seguros de activos fijos")
    public ApiResponse<GenerarPreasientoResponse> afDevengoSeguros(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.AF_DEVENGO_SEGUROS, request),
                "Pre-asiento generado por devengamiento de seguros de activos fijos");
    }

    // ── Almacén (genera PRE-ASIENTOS por concepto financiero) ────────────────────

    @PostMapping("/almacen-ingreso")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por ingreso de inventario",
               description = "Recibe el movimiento de almacén (vale_mov + vale_mov_det) con conceptoFinancieroId por línea")
    public ApiResponse<GenerarPreasientoResponse> almacenIngreso(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.ALMACEN_INGRESO, request),
                "Pre-asiento generado por ingreso de inventario");
    }

    @PostMapping("/almacen-consumo")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar pre-asiento por consumo de inventario",
               description = "Recibe el movimiento de almacén (vale_mov + vale_mov_det) con conceptoFinancieroId por línea")
    public ApiResponse<GenerarPreasientoResponse> almacenConsumo(
            @Valid @RequestBody GenerarAsientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.generarPreasiento(TipoOperacionContable.ALMACEN_CONSUMO, request),
                "Pre-asiento generado por consumo de inventario");
    }

    // ── Importación: Pre-asiento → Asiento definitivo ─────────────────────────

    @PostMapping("/importar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Importar pre-asientos a asientos contables definitivos")
    public ApiResponse<ImportarPreasientoResponse> importarPreasientos(
            @Valid @RequestBody ImportarPreasientoRequest request) {
        return ApiResponse.ok(
                generarPreasientoService.importarPreasientos(request),
                "Pre-asientos importados a asientos contables");
    }
}
