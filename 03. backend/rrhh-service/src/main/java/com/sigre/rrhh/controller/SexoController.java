package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.SexoCreateRequest;
import com.sigre.rrhh.dto.request.SexoUpdateRequest;
import com.sigre.rrhh.dto.response.SexoResponse;
import com.sigre.rrhh.constants.SexoConstants;
import com.sigre.rrhh.service.SexoService;

@Tag(name = "Sexos", description = "Catálogo de sexos")
@RestController
@RequestMapping("/api/rrhh/sexos")
@RequiredArgsConstructor
public class SexoController {

    private final SexoService service;

    @Operation(summary = "Listar sexos")
    @GetMapping
    public ApiResponse<PageData<SexoResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<SexoResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener sexo por ID")
    @GetMapping("/{id}")
    public ApiResponse<SexoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear sexo")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<SexoResponse> crear(@Valid @RequestBody SexoCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar sexo")
    @PutMapping("/{id}")
    public ApiResponse<SexoResponse> actualizar(@PathVariable Long id, @Valid @RequestBody SexoUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar sexo (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<SexoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), SexoConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar sexo")
    @PatchMapping("/{id}/activar")
    public ApiResponse<SexoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), SexoConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar sexos activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<SexoResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
