package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.ConversionUnidadMapper;
import pe.restaurant.core.service.ConversionUnidadService;

@RestController
@RequestMapping("/api/core/conversiones-unidad")
@RequiredArgsConstructor
public class ConversionUnidadController {
    private final ConversionUnidadService service;
    private final ConversionUnidadMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ConversionUnidadResponse>> list(
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) Long umOrigenId,
            @RequestParam(required = false) Long umDestinoId,
            Pageable pageable
    ) {
        var page = service.list(articuloId, umOrigenId, umDestinoId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(mapper::toResponse).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<ConversionUnidadResponse> getById(@PathVariable Long id) {
        return ApiResponse.ok(service.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ConversionUnidadResponse> create(@Valid @RequestBody ConversionUnidadRequest request) {
        return ApiResponse.ok(service.create(request), "Conversion de unidad creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<ConversionUnidadResponse> update(@PathVariable Long id, @Valid @RequestBody ConversionUnidadRequest request) {
        return ApiResponse.ok(service.update(id, request), "Conversion de unidad actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ConversionUnidadResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ConversionUnidadResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
