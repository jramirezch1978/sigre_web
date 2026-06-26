package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.AprobarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.CerrarEnBloqueRequest;
import pe.restaurant.finanzas.dto.request.CerrarLiquidacionConFechaRequest;
import pe.restaurant.finanzas.dto.request.CerrarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.CierreContableRequest;
import pe.restaurant.finanzas.dto.request.CierreMasivoRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionRequest;
import pe.restaurant.finanzas.dto.request.ObservarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.RechazarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.RevertirCierreRequest;
import pe.restaurant.finanzas.dto.response.BatchResultItem;
import pe.restaurant.finanzas.dto.response.CierreMasivoResultadoResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.ValidacionCierreResponse;
import pe.restaurant.finanzas.service.LiquidacionAprobacionService;
import pe.restaurant.finanzas.service.LiquidacionCierreExportService;
import pe.restaurant.finanzas.service.LiquidacionCierreService;
import pe.restaurant.finanzas.service.LiquidacionService;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/finanzas/liquidaciones")
@RequiredArgsConstructor
@Tag(name = "Liquidaciones", description = "FI323/FI324 - Gestión de liquidaciones de órdenes de giro")
public class LiquidacionController {

    private final LiquidacionService service;
    private final LiquidacionCierreService cierreService;
    private final LiquidacionCierreExportService exportService;
    private final LiquidacionAprobacionService aprobacionService;

    @GetMapping
    @Operation(summary = "Listar liquidaciones",
               description = "FI323 - Listado paginado de liquidaciones con filtros opcionales del servidor")
    public ApiResponse<PageData<LiquidacionResponse>> listar(
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long solicitudGiroId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaRegistroDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaRegistroHasta,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaLiquidacionDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaLiquidacionHasta,
            Pageable pageable) {
        Page<LiquidacionResponse> page = cierreService.listarFiltrado(
                estado, solicitudGiroId, proveedorId, monedaId, sucursalId,
                fechaRegistroDesde, fechaRegistroHasta, fechaLiquidacionDesde, fechaLiquidacionHasta,
                pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle de liquidación",
               description = "FI323 - Obtiene el detalle completo de una liquidación incluyendo sus detalles")
    public ApiResponse<LiquidacionDetalleResponse> obtenerPorId(@PathVariable Long id) {
        LiquidacionDetalleResponse detalle = service.obtenerPorId(id);
        return ApiResponse.ok(detalle);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear liquidación",
               description = "FI323 - Registra una nueva liquidación con sus detalles")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Liquidación creada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<LiquidacionDetalleResponse> crear(@Valid @RequestBody LiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = service.crearLiquidacion(request);
        return ApiResponse.ok(resultado, "Liquidación registrada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar liquidación",
               description = "FI323 - Actualiza una liquidación activa (flagEstado=1)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación actualizada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite edición")
    })
    public ApiResponse<LiquidacionDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody LiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = service.actualizarLiquidacion(id, request);
        return ApiResponse.ok(resultado, "Liquidación actualizada");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular liquidación",
               description = "FI323 - Anula una liquidación que no ha sido cerrada")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación anulada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Liquidación no anulable")
    })
    public ApiResponse<Map<String, Object>> anular(@PathVariable Long id) {
        Map<String, Object> resultado = service.anularLiquidacion(id);
        return ApiResponse.ok(resultado, "Liquidación anulada");
    }

    @PostMapping("/{id}/aprobar")
    @Operation(summary = "Aprobar liquidación de rendición de gastos",
               description = "HU-FIN-OPE-004 (6.5) - Aprueba la liquidación: valida el cuadre, calcula el saldo a "
                       + "devolver/regularizar contra el monto del adelanto y bloquea la edición")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación aprobada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Sin permiso de aprobador"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite aprobación / detalles no cuadran")
    })
    public ApiResponse<LiquidacionDetalleResponse> aprobar(
            @PathVariable Long id,
            @Valid @RequestBody AprobarLiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = aprobacionService.aprobar(id, request.getObservacion());
        return ApiResponse.ok(resultado, "Liquidación aprobada");
    }

    @PostMapping("/{id}/rechazar")
    @Operation(summary = "Rechazar liquidación de rendición de gastos",
               description = "HU-FIN-OPE-004 (6.6) - Rechaza la liquidación con justificación obligatoria y bloquea la edición")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación rechazada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Justificación obligatoria"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Sin permiso de aprobador"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite rechazo")
    })
    public ApiResponse<LiquidacionDetalleResponse> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody RechazarLiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = aprobacionService.rechazar(id, request.getJustificacion());
        return ApiResponse.ok(resultado, "Liquidación rechazada");
    }

    @PostMapping("/{id}/observar")
    @Operation(summary = "Observar liquidación de rendición de gastos",
               description = "HU-FIN-OPE-004 (6.7) - Observa la liquidación con motivo obligatorio; "
                       + "vuelve a estado editable para que quien la registró la corrija")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación observada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Motivo obligatorio"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Sin permiso de aprobador"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite observación")
    })
    public ApiResponse<LiquidacionDetalleResponse> observar(
            @PathVariable Long id,
            @Valid @RequestBody ObservarLiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = aprobacionService.observar(id, request.getMotivo());
        return ApiResponse.ok(resultado, "Liquidación observada");
    }

    @GetMapping("/{id}/validacion-cierre")
    @Operation(summary = "Validar cierre de liquidación",
               description = "FI324 - Valida que la liquidación puede cerrarse sin realizar cambios")
    public ApiResponse<ValidacionCierreResponse> validarCierre(@PathVariable Long id) {
        ValidacionCierreResponse validacion = service.validarCierre(id);
        return ApiResponse.ok(validacion);
    }

    @PostMapping("/{id}/cerrar")
    @Operation(summary = "Cerrar liquidación",
               description = "FI324 - Cierra una liquidación y actualiza la orden de giro")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación cerrada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Liquidación no puede cerrarse")
    })
    public ApiResponse<LiquidacionDetalleResponse> cerrar(
            @PathVariable Long id,
            @Valid @RequestBody CerrarLiquidacionRequest request) {
        LiquidacionDetalleResponse resultado = service.cerrarLiquidacion(id, request.getObservacion());
        return ApiResponse.ok(resultado, "Liquidación cerrada");
    }

    @PostMapping("/cerrar-lote")
    @Operation(summary = "Cerrar liquidaciones en bloque",
               description = "Cierra múltiples liquidaciones en una sola operación. Retorna resultado por cada ID.")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Procesadas todas las liquidaciones"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación")
    })
    public ApiResponse<List<BatchResultItem>> cerrarEnBloque(
            @Valid @RequestBody CerrarEnBloqueRequest request) {
        List<BatchResultItem> resultados = service.cerrarEnBloque(request);
        return ApiResponse.ok(resultados, "Liquidaciones procesadas");
    }

    @PostMapping("/{id}/cerrar-con-fecha")
    @Operation(summary = "Cerrar liquidación con fecha de cierre",
               description = "FI324 - Cierra una liquidación estampando la fecha de cierre (fecha_liquidacion) además de la observación")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación cerrada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Liquidación no puede cerrarse")
    })
    public ApiResponse<LiquidacionDetalleResponse> cerrarConFecha(
            @PathVariable Long id,
            @Valid @RequestBody CerrarLiquidacionConFechaRequest request) {
        LiquidacionDetalleResponse resultado = service.cerrarLiquidacionConFecha(
            id, request.getFechaLiquidacion(), request.getObservacion());
        return ApiResponse.ok(resultado, "Liquidación cerrada");
    }

    @PostMapping("/{id}/cerrar-contable")
    @Operation(summary = "Cierre contable de liquidación",
               description = "FI324 / HU-FIN-ADL-004 - Cierra la liquidación, calcula el saldo a devolver/regularizar, "
                       + "genera el asiento contable de cierre y estampa la fecha de cierre")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación cerrada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Liquidación no puede cerrarse / asiento rechazado")
    })
    public ApiResponse<LiquidacionDetalleResponse> cerrarContable(
            @PathVariable Long id,
            @Valid @RequestBody CierreContableRequest request) {
        LiquidacionDetalleResponse resultado = cierreService.cerrarContable(id, request);
        return ApiResponse.ok(resultado, "Liquidación cerrada");
    }

    @PostMapping("/{id}/revertir-cierre")
    @Operation(summary = "Revertir cierre (reapertura controlada)",
               description = "HU-FIN-ADL-004 - Reabre una liquidación cerrada con motivo obligatorio y anula el asiento de cierre")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Cierre revertido exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "La liquidación no está cerrada")
    })
    public ApiResponse<LiquidacionDetalleResponse> revertirCierre(
            @PathVariable Long id,
            @Valid @RequestBody RevertirCierreRequest request) {
        LiquidacionDetalleResponse resultado = cierreService.revertirCierre(id, request);
        return ApiResponse.ok(resultado, "Cierre revertido");
    }

    @PostMapping("/cerrar-masivo")
    @Operation(summary = "Cierre masivo de liquidaciones",
               description = "HU-FIN-ADL-004 - Cierra varias liquidaciones; cada una se procesa de forma independiente")
    public ApiResponse<CierreMasivoResultadoResponse> cerrarMasivo(
            @Valid @RequestBody CierreMasivoRequest request) {
        CierreMasivoResultadoResponse resultado = cierreService.cerrarMasivo(request);
        return ApiResponse.ok(resultado, "Cierre masivo procesado");
    }

    @GetMapping(value = "/{id}/export", produces = {
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "text/csv",
            "application/pdf"
    })
    @Operation(summary = "Exportar detalle de cierre",
               description = "HU-FIN-ADL-004 - Exporta el detalle de cierre de la liquidación a xlsx, pdf o csv")
    public ResponseEntity<byte[]> exportar(
            @PathVariable Long id,
            @RequestParam(defaultValue = "xlsx") String formato) {
        byte[] bytes = exportService.exportarCierre(id, formato);
        String fmt = formato.toLowerCase();
        MediaType mediaType = switch (fmt) {
            case "csv" -> MediaType.parseMediaType("text/csv");
            case "pdf" -> MediaType.APPLICATION_PDF;
            default -> MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        };
        String ext = "pdf".equals(fmt) ? "pdf" : ("csv".equals(fmt) ? "csv" : "xlsx");
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=cierre-liquidacion-" + id + "." + ext)
                .contentType(mediaType)
                .body(bytes);
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.error(ex.getMessage(), "RESOURCE_NOT_FOUND"));
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException ex) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }
}
