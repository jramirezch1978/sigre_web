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
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.service.AutorizadorGiroService;

import java.util.List;

@RestController
@RequestMapping("/api/finanzas/autorizadores-giro")
@RequiredArgsConstructor
@Tag(name = "Autorizadores de Giro", description = "API para gestión de autorizadores de giros por centro de costo")
public class AutorizadorGiroController {

    private final AutorizadorGiroService service;

    @Operation(summary = "Listar autorizadores de giro", description = "Obtiene lista paginada de autorizadores de giros")
    @GetMapping
    public ApiResponse<PageData<AutorizadorGiroResponse>> findAll(
            @PageableDefault(size = 20, sort = "id", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<AutorizadorGiroResponse> page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()), "Autorizadores de giro listados exitosamente");
    }

    @Operation(summary = "Obtener autorizador de giro por ID", description = "Obtiene un autorizador de giro específico")
    @GetMapping("/{id}")
    public ApiResponse<AutorizadorGiroResponse> findById(@PathVariable Long id) {
        AutorizadorGiroResponse result = service.findById(id);
        return ApiResponse.ok(result, "Autorizador de giro encontrado exitosamente");
    }

    @Operation(summary = "Crear autorizador de giro", description = "Crea un nuevo autorizador de giro")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AutorizadorGiroResponse> create(@Valid @RequestBody AutorizadorGiroRequest request) {
        AutorizadorGiroResponse result = service.create(request);
        return ApiResponse.ok(result, "Autorizador de giro creado exitosamente");
    }

    @Operation(summary = "Actualizar autorizador de giro", description = "Actualiza un autorizador de giro existente")
    @PutMapping("/{id}")
    public ApiResponse<AutorizadorGiroResponse> update(
            @PathVariable Long id, 
            @Valid @RequestBody AutorizadorGiroRequest request) {
        AutorizadorGiroResponse result = service.update(id, request);
        return ApiResponse.ok(result, "Autorizador de giro actualizado exitosamente");
    }

    @Operation(summary = "Eliminar autorizador de giro", description = "Elimina un autorizador de giro")
    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> deleteById(@PathVariable Long id) {
        service.deleteById(id);
        return ApiResponse.ok(true, "Autorizador de giro eliminado exitosamente");
    }

    @Operation(summary = "Activar autorizador de giro", description = "Activa un autorizador de giro")
    @PatchMapping("/{id}/activar")
    public ApiResponse<AutorizadorGiroResponse> activate(@PathVariable Long id) {
        AutorizadorGiroResponse result = service.activate(id);
        return ApiResponse.ok(result, "Autorizador de giro activado exitosamente");
    }

    @Operation(summary = "Desactivar autorizador de giro", description = "Desactiva un autorizador de giro")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AutorizadorGiroResponse> deactivate(@PathVariable Long id) {
        AutorizadorGiroResponse result = service.deactivate(id);
        return ApiResponse.ok(result, "Autorizador de giro desactivado exitosamente");
    }

    @Operation(summary = "Listar autorizadores por centro de costo", description = "Obtiene todos los autorizadores de un centro de costo específico")
    @GetMapping("/centro-costo/{centrosCostoId}")
    public ApiResponse<List<AutorizadorGiroResponse>> findByCentroCosto(@PathVariable Long centrosCostoId) {
        List<AutorizadorGiroResponse> result = service.findByCentroCosto(centrosCostoId);
        return ApiResponse.ok(result, "Autorizadores de giro del centro de costo listados exitosamente");
    }

    @Operation(summary = "Listar autorizadores activos por centro de costo", description = "Obtiene autorizadores activos de un centro de costo específico")
    @GetMapping("/centro-costo/{centrosCostoId}/activos")
    public ApiResponse<List<AutorizadorGiroResponse>> findActivosByCentroCosto(@PathVariable Long centrosCostoId) {
        List<AutorizadorGiroResponse> result = service.findActivosByCentroCosto(centrosCostoId);
        return ApiResponse.ok(result, "Autorizadores activos del centro de costo listados exitosamente");
    }
}
