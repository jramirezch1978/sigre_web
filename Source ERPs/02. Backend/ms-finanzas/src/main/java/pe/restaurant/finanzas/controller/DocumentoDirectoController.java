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
import pe.restaurant.finanzas.dto.request.DocumentoDirectoRequest;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.DocumentoDirectoResponse;
import pe.restaurant.finanzas.service.DocumentoDirectoService;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;

@RestController
@RequestMapping("/api/finanzas/cuentas-pagar/directos")
@RequiredArgsConstructor
@Tag(name = "Documentos Directos", description = "CXP-DIRECTO - Documentos por pagar directo sin asiento contable")
public class DocumentoDirectoController {

    private final DocumentoDirectoService service;

    @GetMapping
    @Operation(summary = "Listar documentos directos", 
               description = "Obtiene un listado paginado de documentos directos")
    public ApiResponse<PageData<DocumentoDirectoResponse>> listar(Pageable pageable) {
        Page<DocumentoDirectoResponse> page = service.listarDirectos(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener documento directo por ID", 
               description = "Obtiene el detalle completo de un documento directo")
    public ApiResponse<DocumentoDirectoResponse> obtenerPorId(@PathVariable Long id) {
        DocumentoDirectoResponse response = service.obtenerDirectoPorId(id);
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear documento directo", 
               description = "Registra un nuevo documento directo sin asiento contable")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Documento directo creado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Recurso no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Documento duplicado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Regla de negocio incumplida")
    })
    public ApiResponse<DocumentoDirectoResponse> crear(@Valid @RequestBody DocumentoDirectoRequest request) {
        DocumentoDirectoResponse response = service.crearDirecto(request);
        return ApiResponse.ok(response, "Documento directo registrado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar documento directo", 
               description = "Actualiza un documento directo activo (flagEstado=1)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Documento directo actualizado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Documento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "No se puede modificar el documento")
    })
    public ApiResponse<DocumentoDirectoResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody DocumentoDirectoRequest request) {
        DocumentoDirectoResponse response = service.actualizarDirecto(id, request);
        return ApiResponse.ok(response, "Documento directo actualizado");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular documento directo", 
               description = "Anula un documento directo activo (flagEstado=1)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Documento directo anulado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Documento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "No se puede anular el documento")
    })
    public ApiResponse<DocumentoDirectoResponse> anular(@PathVariable Long id) {
        DocumentoDirectoResponse response = service.anularDirecto(id);
        return ApiResponse.ok(response, "Documento directo anulado");
    }

    @ExceptionHandler(pe.restaurant.common.exception.ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(pe.restaurant.common.exception.ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.error(ex.getMessage(), FinanzasErrorCodes.PROVEEDOR_NO_ENCONTRADO));
    }

    @ExceptionHandler(pe.restaurant.common.exception.BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(pe.restaurant.common.exception.BusinessException ex) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }
}
