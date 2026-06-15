package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.request.CajaBancosRequest;
import com.sigre.finanzas.dto.response.CajaBancosDetalleResponse;
import com.sigre.finanzas.dto.response.CajaBancosResponse;
import com.sigre.finanzas.dto.response.EjecutarMovimientoResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.service.CajaBancosService;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/finanzas/caja-bancos")
@RequiredArgsConstructor
@Tag(name = "Caja y Bancos", description = "FI309/FI310/FI312/FI326 - Gestión unificada de movimientos de caja y bancos")
public class CajaBancosController {

    private final CajaBancosService service;

    @GetMapping
    @Operation(summary = "Listar movimientos de caja y bancos",
               description = "Obtiene un listado paginado de movimientos con filtros opcionales por tipo de transacción, cuenta bancaria, fechas, estado y entidad")
    public ApiResponse<PageData<CajaBancosResponse>> listar(
            @RequestParam(required = false) String flagTipoTransaccion,
            @RequestParam(required = false) Long bancoCntaId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long entidadContribuyenteId,
            Pageable pageable) {
        Page<CajaBancosResponse> page = service.listar(
            flagTipoTransaccion, bancoCntaId, fechaDesde, fechaHasta, 
            estado, entidadContribuyenteId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle de movimiento",
               description = "Obtiene el detalle completo de un movimiento de caja/bancos incluyendo sus detalles")
    public ApiResponse<CajaBancosDetalleResponse> obtenerPorId(@PathVariable Long id) {
        CajaBancosDetalleResponse detalle = service.obtenerPorId(id);
        return ApiResponse.ok(detalle);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear movimiento de caja/bancos",
               description = "Registra un nuevo movimiento de caja/bancos (cobro, pago, transferencia o aplicación de documentos)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Movimiento creado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<CajaBancosDetalleResponse> crear(@Valid @RequestBody CajaBancosRequest request) {
        CajaBancosDetalleResponse resultado = service.crear(request);
        return ApiResponse.ok(resultado, "Movimiento de caja/bancos registrado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar movimiento de caja/bancos",
               description = "Actualiza un movimiento activo (flagEstado=1, no ejecutado)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Movimiento actualizado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Movimiento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite edición")
    })
    public ApiResponse<CajaBancosDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody CajaBancosRequest request) {
        CajaBancosDetalleResponse resultado = service.actualizar(id, request);
        return ApiResponse.ok(resultado, "Movimiento de caja/bancos actualizado");
    }

    @PostMapping("/{id}/ejecutar")
    @Operation(summary = "Ejecutar movimiento",
               description = "Ejecuta el movimiento: afecta saldos de cuenta bancaria y genera asiento contable")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Movimiento ejecutado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Movimiento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Movimiento no puede ejecutarse")
    })
    public ApiResponse<EjecutarMovimientoResponse> ejecutar(@PathVariable Long id) {
        EjecutarMovimientoResponse resultado = service.ejecutar(id);
        return ApiResponse.ok(resultado, "Movimiento ejecutado");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular movimiento",
               description = "Anula un movimiento que no ha sido ejecutado")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Movimiento anulado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Movimiento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Movimiento no anulable")
    })
    public ApiResponse<Map<String, Object>> anular(@PathVariable Long id) {
        Map<String, Object> resultado = service.anular(id);
        return ApiResponse.ok(resultado, "Movimiento anulado");
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
