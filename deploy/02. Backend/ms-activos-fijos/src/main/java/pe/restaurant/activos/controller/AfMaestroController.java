package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfMaestroRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfMaestroMapper;
import pe.restaurant.activos.service.AfMaestroService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/maestro")
@RequiredArgsConstructor
public class AfMaestroController {

    private final AfMaestroService service;
    private final AfMaestroMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfMaestroResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfMaestroResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfMaestroResponse> crear(@Valid @RequestBody AfMaestroRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfMaestroResponse> actualizar(@PathVariable Long id,
                                                      @Valid @RequestBody AfMaestroRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AfMaestroResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AfMaestroResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/por-subclase/{id}")
    public ApiResponse<PageData<AfMaestroResponse>> listarPorSubClase(@PathVariable Long id, Pageable pageable) {
        var page = service.findByAfSubClaseId(id, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/por-ubicacion/{id}")
    public ApiResponse<PageData<AfMaestroResponse>> listarPorUbicacion(@PathVariable Long id, Pageable pageable) {
        var page = service.findByAfUbicacionId(id, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

}
