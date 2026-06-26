package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.DocTipoUsuarioRequest;
import pe.restaurant.core.dto.DocTipoUsuarioResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.DocTipoUsuarioMapper;
import pe.restaurant.core.service.DocTipoUsuarioService;

@RestController
@RequestMapping("/api/core/doc-tipo-usuarios")
@RequiredArgsConstructor
public class DocTipoUsuarioController {

    private final DocTipoUsuarioService service;
    private final DocTipoUsuarioMapper mapper;

    @GetMapping
    public ApiResponse<PageData<DocTipoUsuarioResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<DocTipoUsuarioResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DocTipoUsuarioResponse> create(@Valid @RequestBody DocTipoUsuarioRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<DocTipoUsuarioResponse> update(@PathVariable Long id, @Valid @RequestBody DocTipoUsuarioRequest request) {
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
    public ApiResponse<DocTipoUsuarioResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<DocTipoUsuarioResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
