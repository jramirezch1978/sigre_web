package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.ProgramVacacionConstants;
import com.sigre.rrhh.dto.request.ProgramVacacionCreateRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionImportarRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionUpdateRequest;
import com.sigre.rrhh.dto.response.ProgramVacacionResponse;
import com.sigre.rrhh.service.ProgramVacacionService;

import java.util.List;

@Tag(name = "Programación Vacacional", description = "Distribución mensual de vacaciones")
@RestController
@RequestMapping("/api/rrhh/vacaciones/programacion")
@RequiredArgsConstructor
public class ProgramVacacionController {

    private final ProgramVacacionService service;

    @Operation(summary = "Listar programaciones")
    @GetMapping
    public ApiResponse<PageData<ProgramVacacionResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer anio,
            Pageable pageable) {
        Page<ProgramVacacionResponse> page = service.listar(trabajadorId, anio, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener programación por ID")
    @GetMapping("/{id}")
    public ApiResponse<ProgramVacacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear programación vacacional")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ProgramVacacionResponse> crear(@Valid @RequestBody ProgramVacacionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar programación vacacional")
    @PutMapping("/{id}")
    public ApiResponse<ProgramVacacionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody ProgramVacacionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar programación vacacional")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ProgramVacacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), ProgramVacacionConstants.MSG_DESACTIVADO);
    }

    // ══════════════════════════════════════════════════════════════
    //  IMPORTACIÓN / EXPORTACIÓN
    // ══════════════════════════════════════════════════════════════

    @Operation(summary = "Importar programación vacacional (batch)")
    @PostMapping("/importar")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<List<ProgramVacacionResponse>> importar(
            @Valid @RequestBody ProgramVacacionImportarRequest request) {
        return ApiResponse.ok(service.importar(request));
    }

    @Operation(summary = "Exportar programación vacacional a Excel")
    @GetMapping("/exportar")
    public ResponseEntity<byte[]> exportar(
            @RequestParam(required = false) Integer anio) {
        byte[] bytes = service.exportarExcel(anio);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=programacion-vacaciones.xlsx")
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(bytes);
    }
}
