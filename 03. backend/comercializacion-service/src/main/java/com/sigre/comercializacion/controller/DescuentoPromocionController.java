package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.dto.response.DescuentoPromocionResponse;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.DescuentoPromocionService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/descuentos-promocion")
@RequiredArgsConstructor
@Tag(name = "Descuentos y promociones", description = "Maestro de promociones aplicables a ventas")
public class DescuentoPromocionController {

    private final DescuentoPromocionService service;
    private final VentasResponseMapper mapper;

    @GetMapping
    @Operation(summary = "Listar descuentos/promociones")
    public ApiResponse<PageData<DescuentoPromocionResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String tipo,
            @RequestParam(required = false) String flagEstado) {
        var page = service.findAll(nombre, tipo, flagEstado, pageable);
        var content = page.getContent().stream().map(mapper::toDescuentoResponse).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener por id")
    public ApiResponse<DescuentoPromocionResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toDescuentoResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear promoción")
    public ApiResponse<DescuentoPromocionResponse> create(@Valid @RequestBody DescuentoPromocionRequest request) {
        return ApiResponse.ok(mapper.toDescuentoResponse(service.create(request)), "Promoción creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar promoción")
    public ApiResponse<DescuentoPromocionResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody DescuentoPromocionRequest request) {
        return ApiResponse.ok(mapper.toDescuentoResponse(service.update(id, request)), "Promoción actualizada");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Baja lógica")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(null, "Promoción eliminada");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar")
    public ApiResponse<DescuentoPromocionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toDescuentoResponse(service.activar(id)), "Activada");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar")
    public ApiResponse<DescuentoPromocionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toDescuentoResponse(service.desactivar(id)), "Desactivada");
    }
}
