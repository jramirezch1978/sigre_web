package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.request.ActividadFlujoCajaRequest;
import pe.restaurant.finanzas.dto.response.ActividadFlujoCajaResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.service.ActividadFlujoCajaService;

@RestController
@RequestMapping("/api/finanzas/actividades-flujo-caja")
@RequiredArgsConstructor
@Tag(name = "Actividades de Flujo de Caja", description = "API para gestión de actividades de flujo de caja")
public class ActividadFlujoCajaController {

    private final ActividadFlujoCajaService service;

    @Operation(summary = "Listar actividades de flujo de caja", description = "Obtiene lista paginada de actividades de flujo de caja con filtros opcionales por estado, código y nombre")
    @GetMapping
    public ApiResponse<PageData<ActividadFlujoCajaResponse>> listar(
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @PageableDefault(size = 20, sort = "orden", direction = Sort.Direction.ASC) Pageable pageable) {
        PageData<ActividadFlujoCajaResponse> result = service.listar(flagEstado, codigo, nombre, pageable);
        return ApiResponse.ok(result, "Actividades de flujo de caja listadas exitosamente");
    }

    @Operation(summary = "Obtener actividad de flujo de caja por ID", description = "Obtiene una actividad de flujo de caja específica")
    @GetMapping("/{id}")
    public ApiResponse<ActividadFlujoCajaResponse> findById(@PathVariable Long id) {
        ActividadFlujoCajaResponse result = service.findById(id);
        return ApiResponse.ok(result, "Actividad de flujo de caja encontrada exitosamente");
    }

    @Operation(summary = "Crear actividad de flujo de caja", description = "Crea una nueva actividad de flujo de caja")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ActividadFlujoCajaResponse> create(@Valid @RequestBody ActividadFlujoCajaRequest request) {
        ActividadFlujoCajaResponse result = service.create(request);
        return ApiResponse.ok(result, "Actividad de flujo de caja creada exitosamente");
    }

    @Operation(summary = "Actualizar actividad de flujo de caja", description = "Actualiza una actividad de flujo de caja existente")
    @PutMapping("/{id}")
    public ApiResponse<ActividadFlujoCajaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ActividadFlujoCajaRequest request) {
        ActividadFlujoCajaResponse result = service.update(id, request);
        return ApiResponse.ok(result, "Actividad de flujo de caja actualizada exitosamente");
    }

    @Operation(summary = "Activar actividad de flujo de caja", description = "Activa una actividad de flujo de caja")
    @PatchMapping("/{id}/activar")
    public ApiResponse<ActividadFlujoCajaResponse> activate(@PathVariable Long id) {
        ActividadFlujoCajaResponse result = service.activate(id);
        return ApiResponse.ok(result, "Actividad de flujo de caja activada exitosamente");
    }

    @Operation(summary = "Desactivar actividad de flujo de caja", description = "Desactiva una actividad de flujo de caja")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ActividadFlujoCajaResponse> deactivate(@PathVariable Long id) {
        ActividadFlujoCajaResponse result = service.deactivate(id);
        return ApiResponse.ok(result, "Actividad de flujo de caja desactivada exitosamente");
    }
}
