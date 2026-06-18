package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.CerrarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionRequest;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.ValidacionCierreResponse;
import pe.restaurant.finanzas.service.LiquidacionService;

import java.util.Map;

@RestController
@RequestMapping("/api/finanzas/liquidaciones")
@RequiredArgsConstructor
@Tag(name = "Liquidaciones", description = "FI323/FI324 - Gestión de liquidaciones de órdenes de giro")
public class LiquidacionController {

    private final LiquidacionService service;

    @GetMapping
    @Operation(summary = "Listar liquidaciones",
               description = "FI323 - Obtiene un listado paginado de liquidaciones")
    public ApiResponse<PageData<LiquidacionResponse>> listar(Pageable pageable) {
        Page<LiquidacionResponse> page = service.listarLiquidaciones(pageable);
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
