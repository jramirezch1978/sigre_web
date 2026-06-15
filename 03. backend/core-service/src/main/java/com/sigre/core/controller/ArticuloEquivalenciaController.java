package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.ArticuloEquivalenciaRequest;
import com.sigre.core.dto.ArticuloEquivalenciaResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.mapper.ArticuloEquivalenciaMapper;
import com.sigre.core.service.ArticuloEquivalenciaService;

@RestController
@RequestMapping("/api/core/articulos-equivalencias")
@RequiredArgsConstructor
public class ArticuloEquivalenciaController {

    private final ArticuloEquivalenciaService service;
    private final ArticuloEquivalenciaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloEquivalenciaResponse>> findAll(
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = service.findAll(articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloEquivalenciaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloEquivalenciaResponse> create(@Valid @RequestBody ArticuloEquivalenciaRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Equivalencia creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloEquivalenciaResponse> update(@PathVariable Long id,
                                                             @Valid @RequestBody ArticuloEquivalenciaRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Equivalencia actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloEquivalenciaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloEquivalenciaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
