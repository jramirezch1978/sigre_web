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
import com.sigre.rrhh.constants.TipoNovedadRrhhConstants;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.service.TipoNovedadRrhhService;

@RestController
@RequestMapping("/api/rrhh/tipos-novedad")
@RequiredArgsConstructor
@Tag(name = "Tipos de Novedad", description = "Gestión del catálogo de tipos de novedad RRHH")
public class TipoNovedadRrhhController {

    private final TipoNovedadRrhhService service;

    @GetMapping
    @Operation(summary = "Listar tipos de novedad")
    public ApiResponse<PageData<TipoNovedadRrhhResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<TipoNovedadRrhhResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener tipo de novedad por ID")
    public ApiResponse<TipoNovedadRrhhResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear tipo de novedad")
    public ApiResponse<TipoNovedadRrhhResponse> crear(@Valid @RequestBody TipoNovedadRrhhCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar tipo de novedad")
    public ApiResponse<TipoNovedadRrhhResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TipoNovedadRrhhUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar tipo de novedad (baja lógica)")
    public ApiResponse<TipoNovedadRrhhResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoNovedadRrhhConstants.MSG_DESACTIVADO);
    }
}
