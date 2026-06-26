package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.DocTipoNumSerieRequest;
import pe.restaurant.core.dto.DocTipoNumSerieResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.DocTipoNumSerieMapper;
import pe.restaurant.core.service.DocTipoNumSerieService;

@RestController
@RequestMapping("/api/core/doc-tipo-num-series")
@RequiredArgsConstructor
public class DocTipoNumSerieController {

    private final DocTipoNumSerieService service;
    private final DocTipoNumSerieMapper mapper;

    @GetMapping
    public ApiResponse<PageData<DocTipoNumSerieResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<DocTipoNumSerieResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DocTipoNumSerieResponse> create(@Valid @RequestBody DocTipoNumSerieRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<DocTipoNumSerieResponse> update(@PathVariable Long id, @Valid @RequestBody DocTipoNumSerieRequest request) {
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
    public ApiResponse<DocTipoNumSerieResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<DocTipoNumSerieResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
