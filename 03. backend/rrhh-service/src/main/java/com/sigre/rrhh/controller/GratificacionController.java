package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.GratificacionProcesarRequest;
import com.sigre.rrhh.dto.response.GratificacionResponse;
import com.sigre.rrhh.service.GratificacionService;
import java.util.List;

@Tag(name = "Gratificaciones", description = "Cálculo batch de gratificaciones (Julio/Diciembre)")
@RestController
@RequestMapping("/api/rrhh/gratificaciones")
@RequiredArgsConstructor
public class GratificacionController {

    private final GratificacionService service;

    @Operation(summary = "Procesar gratificaciones (batch)")
    @PostMapping("/procesar")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<List<GratificacionResponse>> procesar(
            @Valid @RequestBody GratificacionProcesarRequest request) {
        return ApiResponse.ok(service.procesar(request));
    }

    @Operation(summary = "Listar gratificaciones")
    @GetMapping
    public ApiResponse<PageData<GratificacionResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Long periodoGratificacionId,
            Pageable pageable) {
        Page<GratificacionResponse> result = service.listar(trabajadorId, anio, periodoGratificacionId, pageable);
        return ApiResponse.ok(PageData.of(result, result.getContent()));
    }

    @Operation(summary = "Obtener gratificación por ID")
    @GetMapping("/{id}")
    public ApiResponse<GratificacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }
}
