package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.NaturalezaContableRequest;
import pe.restaurant.core.dto.NaturalezaContableResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.NaturalezaContableMapper;
import pe.restaurant.core.service.NaturalezaContableService;

@RestController
@RequestMapping("/api/core/naturalezas-contables")
@RequiredArgsConstructor
public class NaturalezaContableController {

    private final NaturalezaContableService service;
    private final NaturalezaContableMapper mapper;

    @GetMapping
    public ApiResponse<PageData<NaturalezaContableResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<NaturalezaContableResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NaturalezaContableResponse> create(@Valid @RequestBody NaturalezaContableRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<NaturalezaContableResponse> update(@PathVariable Long id,
                                                          @Valid @RequestBody NaturalezaContableRequest request) {
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
    public ApiResponse<NaturalezaContableResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<NaturalezaContableResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
