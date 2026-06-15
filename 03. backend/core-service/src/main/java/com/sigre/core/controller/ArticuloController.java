package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.*;
import com.sigre.core.mapper.ArticuloMapper;
import com.sigre.core.service.ArticuloService;

import java.util.List;

@RestController
@RequestMapping("/api/core/articulos")
@RequiredArgsConstructor
public class ArticuloController {
    private final ArticuloService service;
    private final ArticuloMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloResponse>> list(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) Long categoriaId,
            Pageable pageable
    ) {
        var page = service.list(codigo, nombre, categoriaId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(mapper::toResponse).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloDetalleResponse> getById(@PathVariable Long id) {
        return ApiResponse.ok(service.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloResponse> create(@Valid @RequestBody ArticuloRequest request) {
        return ApiResponse.ok(service.create(request), "Articulo creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloResponse> update(@PathVariable Long id, @Valid @RequestBody ArticuloRequest request) {
        return ApiResponse.ok(service.update(id, request), "Articulo actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @GetMapping("/{articuloId}/proveedores")
    public ApiResponse<List<ArticuloProveedorResponse>> listProveedores(@PathVariable Long articuloId) {
        return ApiResponse.ok(service.listProveedores(articuloId));
    }

    @PostMapping("/{articuloId}/proveedores")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloProveedorResponse> createProveedor(
            @PathVariable Long articuloId,
            @Valid @RequestBody ArticuloProveedorRequest request
    ) {
        return ApiResponse.ok(service.createProveedor(articuloId, request), "Proveedor asociado");
    }

    @GetMapping("/{articuloId}/almacenes-config")
    public ApiResponse<List<ArticuloAlmacenConfigResponse>> listAlmacenesConfig(@PathVariable Long articuloId) {
        return ApiResponse.ok(service.listAlmacenesConfig(articuloId));
    }

    @PutMapping("/{articuloId}/almacenes-config")
    public ApiResponse<ArticuloAlmacenConfigResponse> upsertAlmacenConfig(
            @PathVariable Long articuloId,
            @Valid @RequestBody ArticuloAlmacenConfigRequest request
    ) {
        return ApiResponse.ok(service.upsertAlmacenConfig(articuloId, request), "Configuracion guardada");
    }

    @GetMapping("/{articuloId}/impuestos")
    public ApiResponse<List<ArticuloImpuestoResponse>> listImpuestos(@PathVariable Long articuloId) {
        return ApiResponse.ok(service.listImpuestos(articuloId));
    }

    @PostMapping("/{articuloId}/impuestos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloImpuestoResponse> createImpuesto(
            @PathVariable Long articuloId,
            @Valid @RequestBody ArticuloImpuestoRequest request
    ) {
        return ApiResponse.ok(service.createImpuesto(articuloId, request), "Impuesto asociado");
    }

    @DeleteMapping("/{articuloId}/impuestos/{impuestoId}")
    public ApiResponse<Boolean> deleteImpuesto(
            @PathVariable Long articuloId,
            @PathVariable Long impuestoId
    ) {
        service.deleteImpuesto(articuloId, impuestoId);
        return ApiResponse.ok(true, "Impuesto desasociado");
    }
}
