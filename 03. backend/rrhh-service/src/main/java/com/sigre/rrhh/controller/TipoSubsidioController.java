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
import com.sigre.rrhh.dto.request.TipoSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.TipoSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSubsidioResponse;
import com.sigre.rrhh.constants.TipoSubsidioConstants;
import com.sigre.rrhh.service.TipoSubsidioService;

@Tag(name = "Tipos de Subsidio", description = "Catálogo de tipos de subsidio")
@RestController
@RequestMapping("/api/rrhh/tipos-subsidio")
@RequiredArgsConstructor
public class TipoSubsidioController {

    private final TipoSubsidioService service;

    @Operation(summary = "Listar tipos de subsidio")
    @GetMapping
    public ApiResponse<PageData<TipoSubsidioResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<TipoSubsidioResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener tipo de subsidio por ID")
    @GetMapping("/{id}")
    public ApiResponse<TipoSubsidioResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear tipo de subsidio")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoSubsidioResponse> crear(@Valid @RequestBody TipoSubsidioCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar tipo de subsidio")
    @PutMapping("/{id}")
    public ApiResponse<TipoSubsidioResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TipoSubsidioUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar tipo de subsidio (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoSubsidioResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoSubsidioConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de subsidio")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoSubsidioResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoSubsidioConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de subsidio activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<TipoSubsidioResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
