package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.PuntoVentaRequest;
import pe.restaurant.ventas.dto.response.PuntoVentaResponse;
import pe.restaurant.ventas.entity.PuntoVenta;
import pe.restaurant.ventas.mapper.PuntoVentaMapper;
import pe.restaurant.ventas.service.PuntoVentaService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

import java.util.List;

@RestController
@RequestMapping("/api/ventas/puntos-venta")
@RequiredArgsConstructor
@Tag(name = "Puntos de Venta", description = "Gestión de puntos de venta (cajas, frentes de atención)")
public class PuntoVentaController {

    private final PuntoVentaService service;
    private final PuntoVentaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar puntos de venta", description = "Obtiene un listado paginado de puntos de venta con filtros opcionales")
    public ApiResponse<PageData<PuntoVentaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado) {
        Page<PuntoVenta> page = service.findAllWithFilters(sucursalId, codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener punto de venta por ID")
    public ApiResponse<PuntoVentaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/sucursal/{sucursalId}")
    @Operation(summary = "Listar puntos de venta por sucursal", description = "Obtiene puntos de venta activos de una sucursal")
    public ApiResponse<List<PuntoVentaResponse>> findBySucursalId(@PathVariable Long sucursalId) {
        List<PuntoVenta> puntosVenta = service.findBySucursalId(sucursalId);
        return ApiResponse.ok(mapper.toResponseList(puntosVenta));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear punto de venta", description = "Crea un nuevo punto de venta")
    public ApiResponse<PuntoVentaResponse> create(@Valid @RequestBody PuntoVentaRequest request) {
        PuntoVenta entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Punto de venta creado exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar punto de venta")
    public ApiResponse<PuntoVentaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody PuntoVentaRequest request) {
        PuntoVenta existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Punto de venta actualizado exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar punto de venta")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Punto de venta eliminado exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar punto de venta")
    public ApiResponse<PuntoVentaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Punto de venta activado exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar punto de venta")
    public ApiResponse<PuntoVentaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Punto de venta desactivado exitosamente");
    }
}
