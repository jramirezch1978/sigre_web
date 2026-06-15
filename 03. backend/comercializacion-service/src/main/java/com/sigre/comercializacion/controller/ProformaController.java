package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.ProformaRequest;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.dto.response.ProformaResponse;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.ProformaService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/proformas")
@RequiredArgsConstructor
@Tag(name = "Proformas", description = "Cotizaciones previas a la venta")
public class ProformaController {

    private final ProformaService service;
    private final VentasResponseMapper mapper;

    @GetMapping
    @Operation(
            summary = "Listar proformas",
            description = "Solo cabecera; el campo `detalles` viene en null. Use GET /{id} para líneas.")
    public ApiResponse<PageData<ProformaResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) String numero) {
        var page = service.findAll(sucursalId, clienteId, numero, pageable);
        var content = page.getContent().stream().map(mapper::toProformaResponseForList).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener proforma con detalle")
    public ApiResponse<ProformaResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toProformaResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear proforma")
    public ApiResponse<ProformaResponse> create(@Valid @RequestBody ProformaRequest request) {
        return ApiResponse.ok(mapper.toProformaResponse(service.create(request)), "Proforma creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar proforma (documento activo)")
    public ApiResponse<ProformaResponse> update(@PathVariable Long id, @Valid @RequestBody ProformaRequest request) {
        return ApiResponse.ok(mapper.toProformaResponse(service.update(id, request)), "Proforma actualizada");
    }

    @PatchMapping("/{id}/anular")
    @Operation(summary = "Anular proforma")
    public ApiResponse<ProformaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toProformaResponse(service.anular(id)), "Proforma anulada");
    }

    @PatchMapping("/{id}/marcar-vencida")
    @Operation(summary = "Marcar proforma como vencida")
    public ApiResponse<ProformaResponse> marcarVencida(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toProformaResponse(service.marcarVencida(id)), "Proforma vencida");
    }

    @PatchMapping("/{id}/marcar-convertida")
    @Operation(summary = "Marcar proforma convertida (pedido/factura)")
    public ApiResponse<ProformaResponse> marcarConvertida(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toProformaResponse(service.marcarConvertida(id)), "Proforma convertida");
    }
}
