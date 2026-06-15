package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.compras.dto.ArticuloEstructuraRequest;
import com.sigre.compras.dto.ArticuloEstructuraResponse;
import com.sigre.compras.dto.PageData;
import com.sigre.compras.entity.ArticuloEstructuraId;
import com.sigre.compras.mapper.ArticuloEstructuraMapper;
import com.sigre.compras.service.ArticuloEstructuraService;

@RestController
@RequestMapping("/api/compras/maestros/articulo-estructuras")
@RequiredArgsConstructor
public class ArticuloEstructuraController {

    private final ArticuloEstructuraService service;
    private final ArticuloEstructuraMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloEstructuraResponse>> findAll(
            @RequestParam(required = false) Long articuloPadreId,
            Pageable pageable) {
        var page = service.findAll(articuloPadreId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{articuloPadreId}/{articuloHijoId}")
    public ApiResponse<ArticuloEstructuraResponse> findById(
            @PathVariable Long articuloPadreId,
            @PathVariable Long articuloHijoId) {
        var id = new ArticuloEstructuraId(articuloPadreId, articuloHijoId);
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloEstructuraResponse> create(
            @Valid @RequestBody ArticuloEstructuraRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{articuloPadreId}/{articuloHijoId}")
    public ApiResponse<ArticuloEstructuraResponse> update(
            @PathVariable Long articuloPadreId,
            @PathVariable Long articuloHijoId,
            @Valid @RequestBody ArticuloEstructuraRequest request) {
        var id = new ArticuloEstructuraId(articuloPadreId, articuloHijoId);
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{articuloPadreId}/{articuloHijoId}")
    public ApiResponse<Boolean> delete(
            @PathVariable Long articuloPadreId,
            @PathVariable Long articuloHijoId) {
        var id = new ArticuloEstructuraId(articuloPadreId, articuloHijoId);
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
