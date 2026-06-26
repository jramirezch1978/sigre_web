package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.EntidadDireccionRequest;
import pe.restaurant.core.dto.EntidadDireccionResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.EntidadDireccionMapper;
import pe.restaurant.core.service.EntidadDireccionService;

@RestController
@RequestMapping("/api/core/entidad-direcciones")
@RequiredArgsConstructor
public class EntidadDireccionController {

    private final EntidadDireccionService service;
    private final EntidadDireccionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<EntidadDireccionResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<EntidadDireccionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadDireccionResponse> create(@Valid @RequestBody EntidadDireccionRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<EntidadDireccionResponse> update(@PathVariable Long id, @Valid @RequestBody EntidadDireccionRequest request) {
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
    public ApiResponse<EntidadDireccionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EntidadDireccionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
