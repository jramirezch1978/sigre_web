package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.*;
import com.sigre.core.mapper.NumeradorMapper;
import com.sigre.core.service.NumeradorService;

@RestController
@RequestMapping("/api/core/numeradores")
@RequiredArgsConstructor
public class NumeradorController {

    private final NumeradorService service;
    private final NumeradorMapper mapper;

    @GetMapping
    public ApiResponse<PageData<NumeradorResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<NumeradorResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NumeradorResponse> create(@Valid @RequestBody NumeradorRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<NumeradorResponse> update(@PathVariable Long id, @Valid @RequestBody NumeradorRequest request) {
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
    public ApiResponse<NumeradorResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<NumeradorResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PostMapping("/siguiente")
    public ApiResponse<SiguienteNumeradorResponse> siguiente(@Valid @RequestBody SiguienteNumeradorRequest request) {
        Long next = service.siguiente(request.getCodigoNumerador());
        return ApiResponse.ok(new SiguienteNumeradorResponse(next));
    }
}
