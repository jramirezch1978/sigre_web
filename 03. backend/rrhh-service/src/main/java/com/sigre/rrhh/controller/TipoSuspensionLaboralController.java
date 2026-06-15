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
import com.sigre.rrhh.constants.TipoSuspensionLaboralConstants;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSuspensionLaboralResponse;
import com.sigre.rrhh.service.TipoSuspensionLaboralService;

@Tag(name = "Tipos de Suspensión Laboral", description = "Catálogo de tipos de suspensión laboral")
@RestController
@RequestMapping("/api/rrhh/tipos-suspension-laboral")
@RequiredArgsConstructor
public class TipoSuspensionLaboralController {

    private final TipoSuspensionLaboralService service;

    @Operation(summary = "Listar tipos de suspensión laboral")
    @GetMapping
    public ApiResponse<PageData<TipoSuspensionLaboralResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<TipoSuspensionLaboralResponse> result = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(result, result.getContent()));
    }

    @Operation(summary = "Obtener tipo de suspensión laboral por ID")
    @GetMapping("/{id}")
    public ApiResponse<TipoSuspensionLaboralResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear tipo de suspensión laboral")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoSuspensionLaboralResponse> crear(
            @Valid @RequestBody TipoSuspensionLaboralCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar tipo de suspensión laboral")
    @PutMapping("/{id}")
    public ApiResponse<TipoSuspensionLaboralResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody TipoSuspensionLaboralUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar tipo de suspensión laboral (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoSuspensionLaboralResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoSuspensionLaboralConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de suspensión laboral")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoSuspensionLaboralResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoSuspensionLaboralConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de suspensión laboral activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<TipoSuspensionLaboralResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
