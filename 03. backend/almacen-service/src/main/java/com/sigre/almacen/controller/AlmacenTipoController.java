package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.AlmacenTipoRequest;
import com.sigre.almacen.dto.AlmacenTipoResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.mapper.AlmacenTipoMapper;
import com.sigre.almacen.service.AlmacenTipoService;
import com.sigre.almacen.support.AlmacenTipoResponseEnricher;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/almacen-tipos")
@RequiredArgsConstructor
public class AlmacenTipoController {

    private final AlmacenTipoService service;
    private final AlmacenTipoMapper mapper;
    private final AlmacenTipoResponseEnricher almacenTipoResponseEnricher;

    @GetMapping
    public ApiResponse<PageData<AlmacenTipoResponse>> findAll(
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(this::toResponseEnriched).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<AlmacenTipoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AlmacenTipoResponse> create(@Valid @RequestBody AlmacenTipoRequest request) {
        return ApiResponse.ok(toResponseEnriched(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AlmacenTipoResponse> update(@PathVariable Long id, @Valid @RequestBody AlmacenTipoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(toResponseEnriched(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AlmacenTipoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AlmacenTipoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(toResponseEnriched(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    private AlmacenTipoResponse toResponseEnriched(AlmacenTipo entity) {
        AlmacenTipoResponse dto = mapper.toResponse(entity);
        almacenTipoResponseEnricher.enrich(dto);
        return dto;
    }
}
