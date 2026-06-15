package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.request.LetraCanjeRequest;
import com.sigre.finanzas.dto.response.LetraCanjeDetalleResponse;
import com.sigre.finanzas.dto.response.LetraCanjeResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.LetraCanjeService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/finanzas/letras-canje")
@RequiredArgsConstructor
@Tag(name = "Letras y Canje", description = "CXP-LETRAS-CANJE - Canje de documentos por pagar")
public class LetraCanjeController {

    private final LetraCanjeService service;

    @GetMapping
    @Operation(summary = "Listar canjes de documentos", 
               description = "Obtiene un listado paginado de canjes con filtros opcionales")
    public ApiResponse<PageData<LetraCanjeResponse>> listar(
            @RequestParam(required = false) String referencia,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        Page<LetraCanjeResponse> page = service.listarCanjes(referencia, proveedorId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{referencia}")
    @Operation(summary = "Obtener detalle de canje", 
               description = "Obtiene el detalle completo de un canje incluyendo orígenes y destinos")
    public ApiResponse<LetraCanjeDetalleResponse> obtenerPorReferencia(@PathVariable String referencia) {
        LetraCanjeDetalleResponse detalle = service.obtenerCanjePorReferencia(referencia);
        return ApiResponse.ok(detalle);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Ejecutar canje de documentos", 
               description = "Ejecuta el canje de documentos por pagar creando nuevas letras")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Canje ejecutado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Referencia duplicada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<LetraCanjeDetalleResponse> ejecutarCanje(@Valid @RequestBody LetraCanjeRequest request) {
        LetraCanjeDetalleResponse resultado = service.ejecutarCanje(request);
        return ApiResponse.ok(resultado, "Canje registrado exitosamente");
    }

    @PostMapping("/{referencia}/anular")
    @Operation(summary = "Anular canje de documentos", 
               description = "Anula un canje revirtiendo los documentos origen y anulando los destinos")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Canje anulado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Canje no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Canje no reversible")
    })
    public ApiResponse<LetraCanjeDetalleResponse> anularCanje(@PathVariable String referencia) {
        LetraCanjeDetalleResponse resultado = service.anularCanje(referencia);
        return ApiResponse.ok(resultado, "Canje anulado exitosamente");
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

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        if (ex.getMessage() != null && ex.getMessage().contains("referencia")) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(ApiResponse.error(
                    "Referencia de canje duplicada", 
                    FinanzasErrorCodes.CANJE_REFERENCIA_DUPLICADA
                ));
        }
        throw ex;
    }
}
