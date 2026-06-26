package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfMatrizSubClaseRequest;
import pe.restaurant.activos.dto.AfMatrizSubClaseResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfMatrizSubClaseMapper;
import pe.restaurant.activos.service.AfMatrizSubClaseService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.ResourceNotFoundException;

@RestController
@RequestMapping("/api/activos/matrices-subclase")
@RequiredArgsConstructor
public class AfMatrizSubClaseController {

    private final AfMatrizSubClaseService service;
    private final AfMatrizSubClaseMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfMatrizSubClaseResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfMatrizSubClaseResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/por-subclase/{subClaseId}")
    public ApiResponse<AfMatrizSubClaseResponse> obtenerPorSubClase(@PathVariable Long subClaseId) {
        var matriz = service.findBySubClaseId(subClaseId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Matriz contable por subclase", "afSubClaseId", subClaseId.toString()));
        return ApiResponse.ok(mapper.toResponse(matriz));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfMatrizSubClaseResponse> crear(@Valid @RequestBody AfMatrizSubClaseRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Matriz creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfMatrizSubClaseResponse> actualizar(
            @PathVariable Long id, @Valid @RequestBody AfMatrizSubClaseRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Matriz actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Matriz eliminada");
    }
}
