package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.ArticuloMovTipoRequest;
import com.sigre.almacen.dto.ArticuloMovTipoResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.mapper.ArticuloMovTipoMapper;
import com.sigre.almacen.service.ArticuloMovTipoService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/tipos-movimiento")
@RequiredArgsConstructor
public class TipoMovimientoController {

    private final ArticuloMovTipoService service;
    private final ArticuloMovTipoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloMovTipoResponse>> findAll(
            @PageableDefault(sort = "tipoMov", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloMovTipoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloMovTipoResponse> create(@Valid @RequestBody ArticuloMovTipoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloMovTipoResponse> update(@PathVariable Long id,
                                                       @Valid @RequestBody ArticuloMovTipoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloMovTipoResponse> deactivate(@PathVariable Long id) {
        var entity = service.findById(id);
        entity.setFlagEstado("0");
        return ApiResponse.ok(mapper.toResponse(service.update(id, entity)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloMovTipoResponse> activate(@PathVariable Long id) {
        var entity = service.findById(id);
        entity.setFlagEstado("1");
        return ApiResponse.ok(mapper.toResponse(service.update(id, entity)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
