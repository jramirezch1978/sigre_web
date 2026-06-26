package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.ArtSuperGrupoRequest;
import pe.restaurant.core.dto.ArtSuperGrupoResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.ArtSuperGrupoMapper;
import pe.restaurant.core.service.ArtSuperGrupoService;

@RestController
@RequestMapping("/api/core/art-super-grupos")
@RequiredArgsConstructor
public class ArtSuperGrupoController {

    private final ArtSuperGrupoService service;
    private final ArtSuperGrupoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArtSuperGrupoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArtSuperGrupoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArtSuperGrupoResponse> create(@Valid @RequestBody ArtSuperGrupoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArtSuperGrupoResponse> update(@PathVariable Long id, @Valid @RequestBody ArtSuperGrupoRequest request) {
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
    public ApiResponse<ArtSuperGrupoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArtSuperGrupoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
