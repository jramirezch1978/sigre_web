package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.DocTipoRequest;
import com.sigre.core.dto.DocTipoResponse;
import com.sigre.core.mapper.DocTipoMapper;
import com.sigre.core.service.DocTipoService;

import java.util.List;

@RestController
@RequestMapping("/api/core/tipos-documento")
@RequiredArgsConstructor
public class DocTipoController {

    private final DocTipoService service;
    private final DocTipoMapper mapper;

    @GetMapping
    public ApiResponse<List<DocTipoResponse>> findAll() {
        return ApiResponse.ok(mapper.toResponseList(service.findAll()));
    }

    @GetMapping("/codigo/{codigo}")
    public ApiResponse<DocTipoResponse> findByCodigo(@PathVariable String codigo) {
        return ApiResponse.ok(mapper.toResponse(service.findByCodigo(codigo)));
    }

    @GetMapping("/{id}")
    public ApiResponse<DocTipoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DocTipoResponse> create(@Valid @RequestBody DocTipoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<DocTipoResponse> update(@PathVariable Long id,
                                               @Valid @RequestBody DocTipoRequest request) {
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
    public ApiResponse<DocTipoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<DocTipoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
