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
import com.sigre.rrhh.dto.request.PrestamoCreateRequest;
import com.sigre.rrhh.dto.request.PrestamoUpdateRequest;
import com.sigre.rrhh.dto.response.PrestamoResponse;
import com.sigre.rrhh.service.PrestamoService;

@Tag(name = "Préstamos", description = "Gestión de préstamos a trabajadores")
@RestController
@RequestMapping("/api/rrhh/prestamos")
@RequiredArgsConstructor
public class PrestamoController {

    private final PrestamoService service;

    @Operation(summary = "Listar préstamos")
    @GetMapping
    public ApiResponse<PageData<PrestamoResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) String flagEstado, Pageable pageable) {
        Page<PrestamoResponse> page = service.listar(trabajadorId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener préstamo por ID")
    @GetMapping("/{id}")
    public ApiResponse<PrestamoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Registrar préstamo")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PrestamoResponse> crear(@Valid @RequestBody PrestamoCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar préstamo")
    @PutMapping("/{id}")
    public ApiResponse<PrestamoResponse> actualizar(@PathVariable Long id, @Valid @RequestBody PrestamoUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Cambiar estado")
    @PatchMapping("/{id}/estado")
    public ApiResponse<PrestamoResponse> cambiarEstado(@PathVariable Long id) {
        return ApiResponse.ok(service.cambiarEstado(id));
    }
}
