package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.CondicionPagoRequest;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.mapper.CondicionPagoMapper;
import com.sigre.core.service.CondicionPagoService;

@RestController
@RequestMapping("/api/core/condiciones-pago")
@RequiredArgsConstructor
public class CondicionPagoController {
    private final CondicionPagoService service;
    private final CondicionPagoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CondicionPagoResponse>> list(Pageable pageable) {
        var page = service.list(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(mapper::toResponse).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<CondicionPagoResponse> getById(@PathVariable Long id) {
        return ApiResponse.ok(service.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CondicionPagoResponse> create(@Valid @RequestBody CondicionPagoRequest request) {
        return ApiResponse.ok(service.create(request), "Condicion de pago creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<CondicionPagoResponse> update(@PathVariable Long id, @Valid @RequestBody CondicionPagoRequest request) {
        return ApiResponse.ok(service.update(id, request), "Condicion de pago actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CondicionPagoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CondicionPagoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
