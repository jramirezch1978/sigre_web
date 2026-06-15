package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.compras.dto.ArticuloPrecioPactadoRequest;
import com.sigre.compras.dto.ArticuloPrecioPactadoResponse;
import com.sigre.compras.dto.PageData;
import com.sigre.compras.mapper.ArticuloPrecioPactadoMapper;
import com.sigre.compras.service.ArticuloPrecioPactadoService;

@RestController
@RequestMapping("/api/compras/maestros/articulo-precios-pactados")
@RequiredArgsConstructor
public class ArticuloPrecioPactadoController {

    private final ArticuloPrecioPactadoService service;
    private final ArticuloPrecioPactadoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloPrecioPactadoResponse>> findAll(
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) Long proveedorId,
            Pageable pageable) {
        var page = service.findAll(articuloId, proveedorId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloPrecioPactadoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloPrecioPactadoResponse> create(@Valid @RequestBody ArticuloPrecioPactadoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloPrecioPactadoResponse> update(@PathVariable Long id,
                                                              @Valid @RequestBody ArticuloPrecioPactadoRequest request) {
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
    public ApiResponse<ArticuloPrecioPactadoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloPrecioPactadoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
