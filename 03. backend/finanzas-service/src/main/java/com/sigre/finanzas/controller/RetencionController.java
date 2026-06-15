package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.dto.request.RetencionRequest;
import com.sigre.finanzas.dto.response.RetencionResponse;
import com.sigre.finanzas.service.RetencionService;

@RestController
@RequestMapping("/api/finanzas/retenciones")
@RequiredArgsConstructor
@Tag(name = "Retención IGV", description = "FI331 - Gestión de retenciones IGV")
public class RetencionController {

    private final RetencionService service;

    @GetMapping
    @Operation(summary = "Listar retenciones", 
               description = "Lista retenciones con filtros opcionales")
    public ApiResponse<PageData<RetencionResponse>> listar(
            @RequestParam(required = false) String nroCertificado,
            @RequestParam(required = false) Long cntasPagarId,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<RetencionResponse> page = service.listar(nroCertificado, cntasPagarId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener retención por ID", 
               description = "Obtiene el detalle completo de una retención")
    public ApiResponse<RetencionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear retención", 
               description = "Registra una nueva retención IGV")
    public ApiResponse<RetencionResponse> crear(@Valid @RequestBody RetencionRequest request) {
        return ApiResponse.ok(service.crear(request), "Retención registrada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar retención", 
               description = "Actualiza una retención existente activa")
    public ApiResponse<RetencionResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody RetencionRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Retención actualizada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar retención", 
               description = "Activa una retención inactiva")
    public ApiResponse<RetencionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), "Retención activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar retención", 
               description = "Desactiva una retención activa")
    public ApiResponse<RetencionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), "Retención desactivada exitosamente");
    }
}
