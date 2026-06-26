package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfUbicacionRequest;
import pe.restaurant.activos.dto.AfUbicacionResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfUbicacionMapper;
import pe.restaurant.activos.service.AfUbicacionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/ubicaciones")
@RequiredArgsConstructor
public class AfUbicacionController {

    private final AfUbicacionService service;
    private final AfUbicacionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfUbicacionResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfUbicacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfUbicacionResponse> crear(@Valid @RequestBody AfUbicacionRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfUbicacionResponse> actualizar(@PathVariable Long id,
                                                    @Valid @RequestBody AfUbicacionRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AfUbicacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AfUbicacionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
