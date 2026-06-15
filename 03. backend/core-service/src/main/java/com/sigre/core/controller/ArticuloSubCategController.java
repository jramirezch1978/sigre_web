package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.ArticuloSubCategRequest;
import com.sigre.core.dto.ArticuloSubCategResponse;
import com.sigre.core.mapper.ArticuloSubCategMapper;
import com.sigre.core.service.ArticuloSubCategService;

@RestController
@RequestMapping("/api/core/sub-categorias")
@RequiredArgsConstructor
public class ArticuloSubCategController {

    private final ArticuloSubCategService service;
    private final ArticuloSubCategMapper mapper;

    @PutMapping("/{id}")
    public ApiResponse<ArticuloSubCategResponse> update(@PathVariable Long id,
                                                        @Valid @RequestBody ArticuloSubCategRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloSubCategResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloSubCategResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
