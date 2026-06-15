package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.InventarioConteoRequest;
import com.sigre.almacen.dto.InventarioConteoResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.service.InventarioConteoService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/almacen/tomas-inventario")
@RequiredArgsConstructor
public class InventarioConteoController {

    private final InventarioConteoService service;

    @GetMapping
    public ApiResponse<PageData<InventarioConteoResponse>> buscar(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = service.buscar(almacenId, articuloId, estado, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<InventarioConteoResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<InventarioConteoResponse> crear(@Valid @RequestBody InventarioConteoRequest request) {
        return ApiResponse.ok(service.crear(request), "Toma de inventario registrada");
    }

    @PutMapping("/{id}")
    public ApiResponse<InventarioConteoResponse> actualizar(
            @PathVariable Long id, @Valid @RequestBody InventarioConteoRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Registro actualizado");
    }

    @PostMapping("/{id}/comparar")
    public ApiResponse<InventarioConteoResponse> compararPost(@PathVariable Long id) {
        return ApiResponse.ok(service.comparar(id), "Comparación registrada");
    }

    @PatchMapping("/{id}/comparar")
    public ApiResponse<InventarioConteoResponse> compararPatch(@PathVariable Long id) {
        return compararPost(id);
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<InventarioConteoResponse> cerrarPost(@PathVariable Long id) {
        return ApiResponse.ok(service.cerrar(id), "Toma de inventario cerrada");
    }

    @PatchMapping("/{id}/cerrar")
    public ApiResponse<InventarioConteoResponse> cerrarPatch(@PathVariable Long id) {
        return cerrarPost(id);
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<InventarioConteoResponse> anularPost(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id), "Toma de inventario anulada");
    }

    @PatchMapping("/{id}/anular")
    public ApiResponse<InventarioConteoResponse> anularPatch(@PathVariable Long id) {
        return anularPost(id);
    }
}
