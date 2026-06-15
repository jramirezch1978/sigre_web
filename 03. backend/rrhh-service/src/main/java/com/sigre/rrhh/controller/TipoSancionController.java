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
import com.sigre.rrhh.dto.request.TipoSancionCreateRequest;
import com.sigre.rrhh.dto.request.TipoSancionUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSancionResponse;
import com.sigre.rrhh.constants.TipoSancionConstants;
import com.sigre.rrhh.service.TipoSancionService;

@Tag(name = "Tipos de Sanción", description = "Catálogo de tipos de sanción disciplinaria")
@RestController
@RequestMapping("/api/rrhh/tipos-sancion")
@RequiredArgsConstructor
public class TipoSancionController {

    private final TipoSancionService service;

    @Operation(summary = "Listar tipos de sanción")
    @GetMapping
    public ApiResponse<PageData<TipoSancionResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<TipoSancionResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener tipo de sanción por ID")
    @GetMapping("/{id}")
    public ApiResponse<TipoSancionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear tipo de sanción")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoSancionResponse> crear(@Valid @RequestBody TipoSancionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar tipo de sanción")
    @PutMapping("/{id}")
    public ApiResponse<TipoSancionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TipoSancionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar tipo de sanción (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoSancionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoSancionConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de sanción")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoSancionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoSancionConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de sanción activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<TipoSancionResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
