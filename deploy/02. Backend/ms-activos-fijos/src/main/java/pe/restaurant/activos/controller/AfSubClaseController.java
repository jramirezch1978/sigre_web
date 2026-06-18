package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfSubClaseRequest;
import pe.restaurant.activos.dto.AfSubClaseResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfSubClaseMapper;
import pe.restaurant.activos.service.AfSubClaseService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/sub-clases")
@RequiredArgsConstructor
public class AfSubClaseController {

    private final AfSubClaseService service;
    private final AfSubClaseMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfSubClaseResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfSubClaseResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfSubClaseResponse> crear(@Valid @RequestBody AfSubClaseRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfSubClaseResponse> actualizar(@PathVariable Long id,
                                                    @Valid @RequestBody AfSubClaseRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AfSubClaseResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AfSubClaseResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
