package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.compras.dto.AprobadorConfiguradoRequest;
import com.sigre.compras.dto.AprobadorConfiguradoResponse;
import com.sigre.compras.dto.PageData;
import com.sigre.compras.mapper.AprobadorConfiguradoMapper;
import com.sigre.compras.service.AprobadorConfiguradoService;

@RestController
@RequestMapping("/api/compras/maestros/aprobadores")
@RequiredArgsConstructor
public class AprobadorConfiguradoController {

    private final AprobadorConfiguradoService service;
    private final AprobadorConfiguradoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AprobadorConfiguradoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AprobadorConfiguradoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AprobadorConfiguradoResponse> create(@Valid @RequestBody AprobadorConfiguradoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AprobadorConfiguradoResponse> update(@PathVariable Long id,
                                                            @Valid @RequestBody AprobadorConfiguradoRequest request) {
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
    public ApiResponse<AprobadorConfiguradoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AprobadorConfiguradoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
