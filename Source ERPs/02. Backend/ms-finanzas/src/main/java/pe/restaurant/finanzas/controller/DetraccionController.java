package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.request.DetraccionRequest;
import pe.restaurant.finanzas.dto.response.DetraccionResponse;
import pe.restaurant.finanzas.service.DetraccionService;

@RestController
@RequestMapping("/api/finanzas/detracciones")
@RequiredArgsConstructor
@Tag(name = "Detracción", description = "FI334 - Gestión de detracciones SPOT")
public class DetraccionController {

    private final DetraccionService service;

    @GetMapping
    @Operation(summary = "Listar detracciones", 
               description = "Lista detracciones con filtros opcionales")
    public ApiResponse<PageData<DetraccionResponse>> listar(
            @RequestParam(required = false) String nroDetraccion,
            @RequestParam(required = false) Long cntasPagarId,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<DetraccionResponse> page = service.listar(nroDetraccion, cntasPagarId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detracción por ID", 
               description = "Obtiene el detalle completo de una detracción")
    public ApiResponse<DetraccionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear detracción", 
               description = "Registra una nueva detracción SPOT")
    public ApiResponse<DetraccionResponse> crear(@Valid @RequestBody DetraccionRequest request) {
        return ApiResponse.ok(service.crear(request), "Detracción registrada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar detracción", 
               description = "Actualiza una detracción existente activa")
    public ApiResponse<DetraccionResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody DetraccionRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Detracción actualizada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar detracción", 
               description = "Activa una detracción inactiva")
    public ApiResponse<DetraccionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), "Detracción activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar detracción", 
               description = "Desactiva una detracción activa")
    public ApiResponse<DetraccionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), "Detracción desactivada exitosamente");
    }
}
