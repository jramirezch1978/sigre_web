package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.DespachoOvRequest;
import com.sigre.comercializacion.dto.request.OrdenVentaRequest;
import com.sigre.comercializacion.dto.response.DespachoOvResponse;
import com.sigre.comercializacion.dto.response.OrdenVentaResponse;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.OrdenVentaService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/ordenes-venta")
@RequiredArgsConstructor
@Tag(name = "Órdenes de venta", description = "OV comercial B2B (cabecera + detalle)")
public class OrdenVentaController {

    private final OrdenVentaService service;
    private final VentasResponseMapper mapper;

    @GetMapping
    @Operation(summary = "Listar órdenes de venta")
    public ApiResponse<PageData<OrdenVentaResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) String nro) {
        var page = service.findAll(sucursalId, clienteId, nro, pageable);
        var content = page.getContent().stream().map(mapper::toOrdenVentaResponse).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener OV con detalle")
    public ApiResponse<OrdenVentaResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear orden de venta")
    public ApiResponse<OrdenVentaResponse> create(@Valid @RequestBody OrdenVentaRequest request) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.create(request)), "OV creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar orden de venta (documento activo)")
    public ApiResponse<OrdenVentaResponse> update(@PathVariable Long id, @Valid @RequestBody OrdenVentaRequest request) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.update(id, request)), "OV actualizada");
    }

    @PatchMapping("/{id}/confirmar")
    @Operation(summary = "Confirmar orden de venta")
    public ApiResponse<OrdenVentaResponse> confirmar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.confirmar(id)), "OV confirmada");
    }

    @PatchMapping("/{id}/anular")
    @Operation(summary = "Anular OV")
    public ApiResponse<OrdenVentaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.anular(id)), "OV anulada");
    }

    @PatchMapping("/{id}/cerrar")
    @Operation(summary = "Cerrar orden de venta")
    public ApiResponse<OrdenVentaResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toOrdenVentaResponse(service.cerrar(id)), "OV cerrada");
    }

    @PostMapping("/{id}/despachar")
    @Operation(summary = "Despachar OV → genera salida de almacén en almacen-service")
    public ApiResponse<DespachoOvResponse> despachar(
            @PathVariable Long id,
            @Valid @RequestBody DespachoOvRequest request) {
        return ApiResponse.ok(service.despacharEnAlmacen(id, request), "Despacho generado");
    }
}
