package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.request.GrupoCodigoFlujoCajaRequest;
import com.sigre.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.service.GrupoCodigoFlujoCajaService;

@RestController
@RequestMapping("/api/finanzas/grupos-flujo-caja")
@RequiredArgsConstructor
@Tag(name = "Grupos de Flujo de Caja", description = "API para gestión de grupos de códigos de flujo de caja")
public class GrupoCodigoFlujoCajaController {

    private final GrupoCodigoFlujoCajaService service;

    @Operation(summary = "Listar grupos de flujo de caja", description = "Obtiene lista paginada de grupos de códigos de flujo de caja")
    @GetMapping
    public ApiResponse<PageData<GrupoCodigoFlujoCajaResponse>> findAll(
            @PageableDefault(size = 20, sort = "orden", direction = Sort.Direction.ASC) Pageable pageable) {
        PageData<GrupoCodigoFlujoCajaResponse> result = service.findAll(pageable);
        return ApiResponse.ok(result, "Grupos de flujo de caja listados exitosamente");
    }

    @Operation(summary = "Obtener grupo de flujo de caja por ID", description = "Obtiene un grupo de código de flujo de caja específico")
    @GetMapping("/{id}")
    public ApiResponse<GrupoCodigoFlujoCajaResponse> findById(@PathVariable Long id) {
        GrupoCodigoFlujoCajaResponse result = service.findById(id);
        return ApiResponse.ok(result, "Grupo de flujo de caja encontrado exitosamente");
    }

    @Operation(summary = "Crear grupo de flujo de caja", description = "Crea un nuevo grupo de código de flujo de caja")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<GrupoCodigoFlujoCajaResponse> create(@Valid @RequestBody GrupoCodigoFlujoCajaRequest request) {
        GrupoCodigoFlujoCajaResponse result = service.create(request);
        return ApiResponse.ok(result, "Grupo de flujo de caja creado exitosamente");
    }

    @Operation(summary = "Actualizar grupo de flujo de caja", description = "Actualiza un grupo de código de flujo de caja existente")
    @PutMapping("/{id}")
    public ApiResponse<GrupoCodigoFlujoCajaResponse> update(
            @PathVariable Long id, 
            @Valid @RequestBody GrupoCodigoFlujoCajaRequest request) {
        GrupoCodigoFlujoCajaResponse result = service.update(id, request);
        return ApiResponse.ok(result, "Grupo de flujo de caja actualizado exitosamente");
    }

    @Operation(summary = "Eliminar grupo de flujo de caja", description = "Elimina un grupo de código de flujo de caja")
    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> deleteById(@PathVariable Long id) {
        service.deleteById(id);
        return ApiResponse.ok(true, "Grupo de flujo de caja eliminado exitosamente");
    }

    @Operation(summary = "Activar grupo de flujo de caja", description = "Activa un grupo de código de flujo de caja")
    @PatchMapping("/{id}/activar")
    public ApiResponse<GrupoCodigoFlujoCajaResponse> activate(@PathVariable Long id) {
        GrupoCodigoFlujoCajaResponse result = service.activate(id);
        return ApiResponse.ok(result, "Grupo de flujo de caja activado exitosamente");
    }

    @Operation(summary = "Desactivar grupo de flujo de caja", description = "Desactiva un grupo de código de flujo de caja")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<GrupoCodigoFlujoCajaResponse> deactivate(@PathVariable Long id) {
        GrupoCodigoFlujoCajaResponse result = service.deactivate(id);
        return ApiResponse.ok(result, "Grupo de flujo de caja desactivado exitosamente");
    }
}
