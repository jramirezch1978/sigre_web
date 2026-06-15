package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.CatalogoSunatRequest;
import com.sigre.core.dto.CatalogoSunatResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.mapper.CatalogoSunatMapper;
import com.sigre.core.service.CatalogoSunatService;

@RestController
@RequestMapping("/api/core/catalogos-sunat")
@RequiredArgsConstructor
public class CatalogoSunatController {

    private final CatalogoSunatService service;
    private final CatalogoSunatMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CatalogoSunatResponse>> findAll(
            @RequestParam(required = false) String codigoCatalogo,
            @RequestParam(required = false) String nombreCatalogo,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(codigoCatalogo, nombreCatalogo, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CatalogoSunatResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CatalogoSunatResponse> create(@Valid @RequestBody CatalogoSunatRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Catálogo SUNAT creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CatalogoSunatResponse> update(@PathVariable Long id,
                                                     @Valid @RequestBody CatalogoSunatRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Catálogo SUNAT actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CatalogoSunatResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Catálogo SUNAT activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CatalogoSunatResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Catálogo SUNAT desactivado");
    }
}
