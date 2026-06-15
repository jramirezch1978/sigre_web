package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.TipoDocIdentidadRequest;
import com.sigre.core.dto.TipoDocIdentidadResponse;
import com.sigre.core.mapper.TipoDocIdentidadMapper;
import com.sigre.core.service.TipoDocIdentidadService;

import java.util.List;

@RestController
@RequestMapping("/api/core/tipos-documento-identidad")
@RequiredArgsConstructor
public class TipoDocIdentidadController {

    private final TipoDocIdentidadService service;
    private final TipoDocIdentidadMapper mapper;

    @GetMapping
    public ApiResponse<List<TipoDocIdentidadResponse>> findAll(@RequestParam(required = false) String flagEstado) {
        return ApiResponse.ok(mapper.toResponseList(service.findAll(flagEstado)));
    }

    @GetMapping("/{id}")
    public ApiResponse<TipoDocIdentidadResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoDocIdentidadResponse> create(@Valid @RequestBody TipoDocIdentidadRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<TipoDocIdentidadResponse> update(@PathVariable Long id,
                                                         @Valid @RequestBody TipoDocIdentidadRequest request) {
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
    public ApiResponse<TipoDocIdentidadResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoDocIdentidadResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
