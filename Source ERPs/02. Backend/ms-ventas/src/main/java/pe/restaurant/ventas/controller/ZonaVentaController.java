package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.ZonaVentaRequest;
import pe.restaurant.ventas.dto.response.ZonaVentaResponse;
import pe.restaurant.ventas.entity.ZonaVenta;
import pe.restaurant.ventas.mapper.ZonaVentaMapper;
import pe.restaurant.ventas.service.ZonaVentaService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/zonas-venta")
@RequiredArgsConstructor
@Tag(name = "Zonas de Venta", description = "Gestión de zonas comerciales de venta")
public class ZonaVentaController {

    private final ZonaVentaService service;
    private final ZonaVentaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar zonas de venta", description = "Obtiene un listado paginado de zonas de venta con filtros opcionales")
    public ApiResponse<PageData<ZonaVentaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) String zonaVenta,
            @RequestParam(required = false) String descZonaVenta,
            @RequestParam(required = false) String ubigeo,
            @RequestParam(required = false) String flagEstado) {
        Page<ZonaVenta> page = service.findAllWithFilters(zonaVenta, descZonaVenta, ubigeo, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener zona de venta por ID")
    public ApiResponse<ZonaVentaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear zona de venta", description = "Crea una nueva zona de venta")
    public ApiResponse<ZonaVentaResponse> create(@Valid @RequestBody ZonaVentaRequest request) {
        ZonaVenta entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Zona de venta creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar zona de venta")
    public ApiResponse<ZonaVentaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ZonaVentaRequest request) {
        ZonaVenta existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Zona de venta actualizada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar zona de venta")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Zona de venta eliminada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar zona de venta")
    public ApiResponse<ZonaVentaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Zona de venta activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar zona de venta")
    public ApiResponse<ZonaVentaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Zona de venta desactivada exitosamente");
    }
}
