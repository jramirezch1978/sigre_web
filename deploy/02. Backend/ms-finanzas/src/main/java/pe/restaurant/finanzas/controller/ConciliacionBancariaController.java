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
import pe.restaurant.finanzas.dto.request.ConciliacionBancariaRequest;
import pe.restaurant.finanzas.dto.request.ConciliarPartidasRequest;
import pe.restaurant.finanzas.dto.response.CerrarConciliacionResponse;
import pe.restaurant.finanzas.dto.response.ConciliacionBancariaResponse;
import pe.restaurant.finanzas.dto.response.ConciliarPartidasResponse;
import pe.restaurant.finanzas.service.ConciliacionBancariaService;

@RestController
@RequestMapping("/api/finanzas/conciliaciones-bancarias")
@RequiredArgsConstructor
@Tag(name = "Conciliación Bancaria", description = "FI347 - Conciliación bancaria mensual")
public class ConciliacionBancariaController {

    private final ConciliacionBancariaService service;

    @GetMapping
    @Operation(summary = "Listar conciliaciones bancarias", 
               description = "Lista conciliaciones con filtros opcionales por cuenta, periodo y estado")
    public ApiResponse<PageData<ConciliacionBancariaResponse>> listar(
            @RequestParam(required = false) Long bancoCntaId,
            @RequestParam(required = false) Integer periodoAnio,
            @RequestParam(required = false) Integer periodoMes,
            @RequestParam(required = false) String estado,
            Pageable pageable) {
        Page<ConciliacionBancariaResponse> page = service.listar(bancoCntaId, periodoAnio, periodoMes, estado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener conciliación por ID", 
               description = "Obtiene el detalle completo de una conciliación bancaria")
    public ApiResponse<ConciliacionBancariaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear conciliación bancaria", 
               description = "Crea una nueva conciliación para un periodo y cuenta bancaria")
    public ApiResponse<ConciliacionBancariaResponse> crear(@Valid @RequestBody ConciliacionBancariaRequest request) {
        return ApiResponse.ok(service.crear(request), "Conciliación bancaria creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar conciliación bancaria", 
               description = "Actualiza una conciliación existente activa (flagEstado=1)")
    public ApiResponse<ConciliacionBancariaResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ConciliacionBancariaRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Conciliación bancaria actualizada exitosamente");
    }

    @PostMapping("/{id}/conciliar")
    @Operation(summary = "Conciliar partidas", 
               description = "Marca partidas específicas como conciliadas")
    public ApiResponse<ConciliarPartidasResponse> conciliar(
            @PathVariable Long id,
            @Valid @RequestBody ConciliarPartidasRequest request) {
        return ApiResponse.ok(service.conciliar(id, request));
    }

    @PostMapping("/{id}/cerrar")
    @Operation(summary = "Cerrar conciliación", 
               description = "Cierra la conciliación si todas las partidas están conciliadas")
    public ApiResponse<CerrarConciliacionResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(service.cerrar(id));
    }
}
