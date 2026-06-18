package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.ventas.dto.request.CanalDistribucionRequest;
import pe.restaurant.ventas.dto.response.CanalDistribucionResponse;
import pe.restaurant.ventas.entity.CanalDistribucion;
import pe.restaurant.ventas.mapper.CanalDistribucionMapper;
import pe.restaurant.ventas.service.CanalDistribucionService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/canales-distribucion")
@RequiredArgsConstructor
@Tag(name = "Canales de Distribución", description = "Gestión de canales de distribución")
public class CanalDistribucionController {

    private final CanalDistribucionService service;
    private final CanalDistribucionMapper mapper;

    @GetMapping
    @Operation(summary = "Listar canales de distribución", description = "Obtiene un listado paginado de canales de distribución con filtros opcionales")
    public ApiResponse<PageData<CanalDistribucionResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado) {
        Page<CanalDistribucion> page = service.findAllWithFilters(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener canal de distribución por ID")
    public ApiResponse<CanalDistribucionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear canal de distribución", description = "Crea un nuevo canal de distribución")
    public ApiResponse<CanalDistribucionResponse> create(@Valid @RequestBody CanalDistribucionRequest request) {
        CanalDistribucion entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Canal de distribución creado exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar canal de distribución")
    public ApiResponse<CanalDistribucionResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody CanalDistribucionRequest request) {
        CanalDistribucion existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Canal de distribución actualizado exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar canal de distribución")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Canal de distribución eliminado exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar canal de distribución")
    public ApiResponse<CanalDistribucionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Canal de distribución activado exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar canal de distribución")
    public ApiResponse<CanalDistribucionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Canal de distribución desactivado exitosamente");
    }
}
