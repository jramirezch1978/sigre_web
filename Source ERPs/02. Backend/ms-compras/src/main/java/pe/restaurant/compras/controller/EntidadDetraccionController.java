package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.EntidadDetraccionRequest;
import pe.restaurant.compras.dto.EntidadDetraccionResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.mapper.EntidadDetraccionMapper;
import pe.restaurant.compras.service.EntidadDetraccionService;

@RestController
@RequestMapping("/api/compras/entidad-detracciones")
@RequiredArgsConstructor
public class EntidadDetraccionController {

    private final EntidadDetraccionService service;
    private final EntidadDetraccionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<EntidadDetraccionResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<EntidadDetraccionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadDetraccionResponse> create(@Valid @RequestBody EntidadDetraccionRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<EntidadDetraccionResponse> update(@PathVariable Long id, @Valid @RequestBody EntidadDetraccionRequest request) {
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
    public ApiResponse<EntidadDetraccionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EntidadDetraccionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
