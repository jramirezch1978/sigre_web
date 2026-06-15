package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.EntidadCreditosCxcRequest;
import com.sigre.comercializacion.dto.response.EntidadCreditosCxcResponse;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.mapper.VentasIssue5DtoMapper;
import com.sigre.comercializacion.service.EntidadCreditosCxcService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/creditos-cxc")
@RequiredArgsConstructor
@Tag(name = "Créditos CxC por entidad", description = "Límites y días de crédito por cliente")
public class EntidadCreditosCxcController {

    private final EntidadCreditosCxcService service;
    private final VentasIssue5DtoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar condiciones de crédito")
    public ApiResponse<PageData<EntidadCreditosCxcResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long entidadContribuyenteId,
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) String flagEstado) {
        var page = service.findAll(entidadContribuyenteId, monedaId, flagEstado, pageable);
        var content = page.getContent().stream().map(mapper::toCreditosResponse).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener por id")
    public ApiResponse<EntidadCreditosCxcResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toCreditosResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear condición de crédito")
    public ApiResponse<EntidadCreditosCxcResponse> create(@Valid @RequestBody EntidadCreditosCxcRequest request) {
        return ApiResponse.ok(mapper.toCreditosResponse(service.create(request)), "Registro creado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar condición de crédito")
    public ApiResponse<EntidadCreditosCxcResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody EntidadCreditosCxcRequest request) {
        return ApiResponse.ok(mapper.toCreditosResponse(service.update(id, request)), "Registro actualizado");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar")
    public ApiResponse<EntidadCreditosCxcResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toCreditosResponse(service.activar(id)), "Activado");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar")
    public ApiResponse<EntidadCreditosCxcResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toCreditosResponse(service.desactivar(id)), "Desactivado");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Baja lógica")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(null, "Registro desactivado");
    }
}
