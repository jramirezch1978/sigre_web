package com.sigre.finanzas.controller;

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
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.request.NotaRequest;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.dto.response.NotaResponse;
import com.sigre.finanzas.service.NotaService;
import com.sigre.finanzas.service.FinanzasErrorCodes;

@RestController
@RequestMapping("/api/finanzas/cuentas-pagar/notas")
@RequiredArgsConstructor
@Tag(name = "Notas Débito/Crédito", description = "FI320 - Notas débito/crédito con impacto contable")
public class NotaController {

    private final NotaService service;

    @GetMapping
    @Operation(summary = "Listar notas débito/crédito", 
               description = "Obtiene un listado paginado de notas débito/crédito")
    public ApiResponse<PageData<NotaResponse>> listar(Pageable pageable) {
        Page<NotaResponse> page = service.listarNotas(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener nota por ID", 
               description = "Obtiene el detalle completo de una nota débito/crédito")
    public ApiResponse<NotaResponse> obtenerPorId(@PathVariable Long id) {
        NotaResponse response = service.obtenerNotaPorId(id);
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear nota débito/crédito", 
               description = "Registra una nueva nota débito/crédito con asiento contable")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Nota creada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Recurso no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Documento duplicado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Regla de negocio incumplida")
    })
    public ApiResponse<NotaResponse> crear(@Valid @RequestBody NotaRequest request) {
        NotaResponse response = service.crearNota(request);
        return ApiResponse.ok(response, "Nota registrada");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular nota", 
               description = "Anula una nota activa (flagEstado=1) sin aplicación")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Nota anulada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Nota no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "No se puede anular la nota")
    })
    public ApiResponse<NotaResponse> anular(@PathVariable Long id) {
        NotaResponse response = service.anularNota(id);
        return ApiResponse.ok(response, "Nota anulada");
    }

    @ExceptionHandler(com.sigre.common.exception.ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(com.sigre.common.exception.ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.error(ex.getMessage(), FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO));
    }

    @ExceptionHandler(com.sigre.common.exception.BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(com.sigre.common.exception.BusinessException ex) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }
}
