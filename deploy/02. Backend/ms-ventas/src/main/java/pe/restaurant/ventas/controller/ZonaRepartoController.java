package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.ZonaRepartoRequest;
import pe.restaurant.ventas.dto.response.ZonaRepartoResponse;
import pe.restaurant.ventas.entity.ZonaReparto;
import pe.restaurant.ventas.mapper.ZonaRepartoMapper;
import pe.restaurant.ventas.service.ZonaRepartoService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/zonas-reparto")
@RequiredArgsConstructor
@Tag(name = "Zonas de Reparto", description = "Gestión de zonas de reparto")
public class ZonaRepartoController {

    private final ZonaRepartoService service;
    private final ZonaRepartoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar zonas de reparto", description = "Obtiene un listado paginado de zonas de reparto con filtros opcionales")
    public ApiResponse<PageData<ZonaRepartoResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) String zonaReparto,
            @RequestParam(required = false) String descZonaReparto,
            @RequestParam(required = false) String ubigeo,
            @RequestParam(required = false) String flagEstado) {
        Page<ZonaReparto> page = service.findAllWithFilters(zonaReparto, descZonaReparto, ubigeo, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener zona de reparto por ID")
    public ApiResponse<ZonaRepartoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear zona de reparto", description = "Crea una nueva zona de reparto")
    public ApiResponse<ZonaRepartoResponse> create(@Valid @RequestBody ZonaRepartoRequest request) {
        ZonaReparto entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Zona de reparto creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar zona de reparto")
    public ApiResponse<ZonaRepartoResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ZonaRepartoRequest request) {
        ZonaReparto existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Zona de reparto actualizada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar zona de reparto")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Zona de reparto eliminada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar zona de reparto")
    public ApiResponse<ZonaRepartoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Zona de reparto activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar zona de reparto")
    public ApiResponse<ZonaRepartoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Zona de reparto desactivada exitosamente");
    }
}
