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
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.request.ProgramacionPagoRequest;
import com.sigre.finanzas.dto.response.EjecucionProgramacionResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.dto.response.ProgramacionPagoListResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoResponse;
import com.sigre.finanzas.service.ProgramacionPagoService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/finanzas/programacion-pagos")
@RequiredArgsConstructor
@Tag(name = "Programación de Pagos", description = "FI356 - Gestión de programación de pagos a proveedores")
public class ProgramacionPagoController {

    private final ProgramacionPagoService service;

    @GetMapping
    @Operation(summary = "Listar programaciones de pago",
               description = "FI356 - Obtiene un listado paginado de programaciones de pago con filtros opcionales")
    public ApiResponse<PageData<ProgramacionPagoListResponse>> listar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            Pageable pageable) {
        Page<ProgramacionPagoListResponse> page = service.listar(fechaDesde, fechaHasta, estado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle de programación de pago",
               description = "FI356 - Obtiene el detalle completo de una programación de pago incluyendo las CxP programadas")
    public ApiResponse<ProgramacionPagoResponse> obtenerPorId(@PathVariable Long id) {
        ProgramacionPagoResponse detalle = service.obtenerPorId(id);
        return ApiResponse.ok(detalle);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear programación de pago",
               description = "FI356 - Registra una nueva programación de pago con detalle de CxP a pagar")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Programación creada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<ProgramacionPagoResponse> crear(@Valid @RequestBody ProgramacionPagoRequest request) {
        ProgramacionPagoResponse resultado = service.crear(request);
        return ApiResponse.ok(resultado, "Programacion de pago creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar programación de pago",
               description = "FI356 - Actualiza una programación de pago activa (flagEstado=1)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Programación actualizada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Programación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Estado no permite edición")
    })
    public ApiResponse<ProgramacionPagoResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ProgramacionPagoRequest request) {
        ProgramacionPagoResponse resultado = service.actualizar(id, request);
        return ApiResponse.ok(resultado, "Programacion de pago actualizada");
    }

    @PostMapping("/{id}/ejecutar")
    @Operation(summary = "Ejecutar programación de pago",
               description = "FI356 - Ejecuta la programación: genera pagos en finanzas.pago y actualiza saldos de CxP")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Programación ejecutada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Programación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Estado no permite ejecución"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error al ejecutar pagos")
    })
    public ApiResponse<EjecucionProgramacionResponse> ejecutar(@PathVariable Long id) {
        EjecucionProgramacionResponse resultado = service.ejecutar(id);
        return ApiResponse.ok(resultado, "Programacion ejecutada: pagos generados");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular programación de pago",
               description = "FI356 - Anula una programación de pago si no ha sido ejecutada")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Programación anulada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Programación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "No se puede anular una programación ejecutada")
    })
    public ApiResponse<ProgramacionPagoResponse> anular(@PathVariable Long id) {
        ProgramacionPagoResponse response = service.anular(id);
        return ApiResponse.<ProgramacionPagoResponse>builder()
                .data(response)
                .message("Programación de pago anulada exitosamente")
                .build();
    }
}
