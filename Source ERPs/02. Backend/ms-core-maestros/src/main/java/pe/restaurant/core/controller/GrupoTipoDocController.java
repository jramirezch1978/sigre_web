package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.GrupoTipoDocRequest;
import pe.restaurant.core.dto.GrupoTipoDocResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.GrupoTipoDocMapper;
import pe.restaurant.core.service.GrupoTipoDocService;

@RestController
@RequestMapping("/api/core/grupos-tipo-doc")
@RequiredArgsConstructor
public class GrupoTipoDocController {

    private final GrupoTipoDocService service;
    private final GrupoTipoDocMapper mapper;

    @GetMapping
    public ApiResponse<PageData<GrupoTipoDocResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<GrupoTipoDocResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<GrupoTipoDocResponse> create(@Valid @RequestBody GrupoTipoDocRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<GrupoTipoDocResponse> update(@PathVariable Long id, @Valid @RequestBody GrupoTipoDocRequest request) {
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
    public ApiResponse<GrupoTipoDocResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<GrupoTipoDocResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
