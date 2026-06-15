package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.TiposImpuestoRequest;
import com.sigre.core.dto.TiposImpuestoResponse;
import com.sigre.core.mapper.TiposImpuestoMapper;
import com.sigre.core.service.TiposImpuestoService;

import java.util.List;

@RestController
@RequestMapping("/api/core/impuestos")
@RequiredArgsConstructor
public class TiposImpuestoController {

    private final TiposImpuestoService service;
    private final TiposImpuestoMapper mapper;

    @GetMapping
    public ApiResponse<List<TiposImpuestoResponse>> findAll() {
        return ApiResponse.ok(mapper.toResponseList(service.findAll()));
    }

    @GetMapping("/tipo/{tipoImpuesto}")
    public ApiResponse<TiposImpuestoResponse> findByTipoImpuesto(@PathVariable String tipoImpuesto) {
        return ApiResponse.ok(mapper.toResponse(service.findByTipoImpuesto(tipoImpuesto)));
    }

    @GetMapping("/{id}")
    public ApiResponse<TiposImpuestoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TiposImpuestoResponse> create(@Valid @RequestBody TiposImpuestoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<TiposImpuestoResponse> update(@PathVariable Long id,
                                                     @Valid @RequestBody TiposImpuestoRequest request) {
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
    public ApiResponse<TiposImpuestoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TiposImpuestoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
