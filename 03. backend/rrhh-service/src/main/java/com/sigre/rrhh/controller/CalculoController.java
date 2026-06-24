package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.CalculoProcesarRequest;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.CalculoService;

@RestController
@RequestMapping("/api/rrhh/calculos")
@RequiredArgsConstructor
@Tag(name = "Cálculo Planilla", description = "Procesamiento y consulta de cálculos de planilla")
public class CalculoController {

    private final CalculoService service;

    @GetMapping
    @Operation(summary = "Listar cálculos de planilla")
    public ApiResponse<PageData<CalculoResponse>> listar(
            Pageable pageable,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Integer mes,
            @RequestParam(required = false) Long tipoPlanillaId) {
        Page<CalculoResponse> page = service.listar(anio, mes, tipoPlanillaId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle del cálculo")
    public ApiResponse<CalculoDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerDetalle(id));
    }

    @PostMapping("/procesar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Procesar planilla")
    public ApiResponse<CalculoDetalleResponse> procesar(@Valid @RequestBody CalculoProcesarRequest request) {
        return ApiResponse.ok(service.procesar(
            request.getAnio(), request.getMes(), request.getTipoPlanillaCodigo(), request.getOrigen()));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar cálculo (físico)")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ApiResponse.ok(true, "Cálculo eliminado");
    }

}
