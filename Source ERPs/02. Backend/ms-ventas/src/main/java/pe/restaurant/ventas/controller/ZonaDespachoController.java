package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.ZonaDespachoRequest;
import pe.restaurant.ventas.dto.response.ZonaDespachoResponse;
import pe.restaurant.ventas.entity.ZonaDespacho;
import pe.restaurant.ventas.mapper.ZonaDespachoMapper;
import pe.restaurant.ventas.service.ZonaDespachoService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/zonas-despacho")
@RequiredArgsConstructor
@Tag(name = "Zonas de Despacho", description = "Gestión de zonas de despacho")
public class ZonaDespachoController {

    private final ZonaDespachoService service;
    private final ZonaDespachoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar zonas de despacho", description = "Obtiene un listado paginado de zonas de despacho con filtros opcionales")
    public ApiResponse<PageData<ZonaDespachoResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) String zonaDespacho,
            @RequestParam(required = false) String descZonaDespacho,
            @RequestParam(required = false) String ubigeo,
            @RequestParam(required = false) String flagEstado) {
        Page<ZonaDespacho> page = service.findAllWithFilters(zonaDespacho, descZonaDespacho, ubigeo, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener zona de despacho por ID")
    public ApiResponse<ZonaDespachoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear zona de despacho", description = "Crea una nueva zona de despacho")
    public ApiResponse<ZonaDespachoResponse> create(@Valid @RequestBody ZonaDespachoRequest request) {
        ZonaDespacho entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Zona de despacho creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar zona de despacho")
    public ApiResponse<ZonaDespachoResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody ZonaDespachoRequest request) {
        ZonaDespacho existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Zona de despacho actualizada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar zona de despacho")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Zona de despacho eliminada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar zona de despacho")
    public ApiResponse<ZonaDespachoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Zona de despacho activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar zona de despacho")
    public ApiResponse<ZonaDespachoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Zona de despacho desactivada exitosamente");
    }
}
