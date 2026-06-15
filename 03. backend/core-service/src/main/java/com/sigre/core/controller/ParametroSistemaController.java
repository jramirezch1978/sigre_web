package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.dto.ParametroSistemaRequest;
import com.sigre.core.dto.ParametroSistemaResponse;
import com.sigre.core.mapper.ParametroSistemaMapper;
import com.sigre.core.service.ParametroSistemaService;

import java.util.List;

@RestController
@RequestMapping("/api/core/parametros-sistema")
@RequiredArgsConstructor
public class ParametroSistemaController {

    private final ParametroSistemaService service;
    private final ParametroSistemaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ParametroSistemaResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String modulo,
            Pageable pageable) {
        var page = service.findAll(codigo, modulo, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ParametroSistemaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ParametroSistemaResponse> create(@Valid @RequestBody ParametroSistemaRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ParametroSistemaResponse> update(@PathVariable Long id, @Valid @RequestBody ParametroSistemaRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PutMapping
    public ApiResponse<List<ParametroSistemaResponse>> updateBatch(
            @Valid @RequestBody List<ParametroSistemaRequest> requests) {
        var entities = requests.stream().map(mapper::toEntity).toList();
        var updated = service.updateBatch(entities);
        return ApiResponse.ok(mapper.toResponseList(updated), "Actualización masiva completada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ParametroSistemaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ParametroSistemaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
