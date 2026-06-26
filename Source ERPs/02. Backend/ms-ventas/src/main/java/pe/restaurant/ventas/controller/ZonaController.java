package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.request.ZonaRequest;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.dto.response.PageData;
import pe.restaurant.ventas.entity.Zona;
import pe.restaurant.ventas.mapper.ZonaMapper;
import pe.restaurant.ventas.service.ZonaService;

import java.util.List;

@RestController
@RequestMapping("/api/ventas/zonas")
@RequiredArgsConstructor
@Tag(name = "Zonas", description = "API para la gestión de zonas del restaurante")
public class ZonaController {

    private final ZonaService service;
    private final ZonaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar zonas con filtros", description = "Obtiene todas las zonas paginadas con filtros opcionales")
    public ApiResponse<PageData<ZonaResponse>> findAll(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<Zona> page = service.findAllWithFilters(sucursalId, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener zona por ID", description = "Obtiene una zona específica por su ID")
    public ApiResponse<ZonaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(service.findById(id));
    }

    @GetMapping("/sucursal/{sucursalId}")
    @Operation(summary = "Listar zonas por sucursal", description = "Obtiene zonas activas de una sucursal")
    public ApiResponse<List<ZonaResponse>> findBySucursalId(@PathVariable Long sucursalId) {
        List<ZonaResponse> zonas = service.findBySucursalId(sucursalId);
        return ApiResponse.ok(zonas);
    }

    @GetMapping("/activas")
    @Operation(summary = "Listar zonas activas", description = "Obtiene todas las zonas activas del sistema")
    public ApiResponse<List<ZonaResponse>> findAllActivas() {
        List<ZonaResponse> zonas = service.findAllActivas();
        return ApiResponse.ok(zonas);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear zona", description = "Crea una nueva zona")
    public ApiResponse<ZonaResponse> create(@Valid @RequestBody ZonaRequest request) {
        Zona entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Zona creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar zona", description = "Actualiza una zona existente")
    public ApiResponse<ZonaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ZonaRequest request) {
        Zona entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.update(id, entity)), "Zona actualizada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar zona", description = "Activa una zona existente")
    public ApiResponse<ZonaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Zona activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar zona", description = "Desactiva una zona existente")
    public ApiResponse<ZonaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Zona desactivada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar zona", description = "Elimina una zona existente")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Zona eliminada exitosamente");
    }
}
