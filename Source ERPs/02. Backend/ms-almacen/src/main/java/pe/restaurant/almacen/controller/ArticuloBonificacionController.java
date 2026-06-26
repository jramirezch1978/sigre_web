package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.ArticuloBonificacionRequest;
import pe.restaurant.almacen.dto.ArticuloBonificacionResponse;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.mapper.ArticuloBonificacionMapper;
import pe.restaurant.almacen.service.ArticuloBonificacionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/maestros/articulo-bonificaciones")
@RequiredArgsConstructor
public class ArticuloBonificacionController {

    private final ArticuloBonificacionService service;
    private final ArticuloBonificacionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloBonificacionResponse>> findAll(
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = service.findAll(articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloBonificacionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloBonificacionResponse> create(
            @Valid @RequestBody ArticuloBonificacionRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloBonificacionResponse> update(@PathVariable Long id,
            @Valid @RequestBody ArticuloBonificacionRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloBonificacionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloBonificacionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
