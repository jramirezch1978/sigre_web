package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.FormaEmbarqueRequest;
import com.sigre.almacen.dto.FormaEmbarqueResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.mapper.FormaEmbarqueMapper;
import com.sigre.almacen.service.FormaEmbarqueService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/maestros/formas-embarque")
@RequiredArgsConstructor
public class FormaEmbarqueController {

    private final FormaEmbarqueService service;
    private final FormaEmbarqueMapper mapper;

    @GetMapping
    public ApiResponse<PageData<FormaEmbarqueResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<FormaEmbarqueResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<FormaEmbarqueResponse> create(@Valid @RequestBody FormaEmbarqueRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<FormaEmbarqueResponse> update(@PathVariable Long id,
                                                     @Valid @RequestBody FormaEmbarqueRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<FormaEmbarqueResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<FormaEmbarqueResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
