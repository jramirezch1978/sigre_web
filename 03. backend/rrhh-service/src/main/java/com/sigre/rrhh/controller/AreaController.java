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
import com.sigre.rrhh.dto.request.AreaRequest;
import com.sigre.rrhh.dto.response.AreaResponse;
import com.sigre.rrhh.dto.response.AreaTreeResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.constants.AreaConstants;
import com.sigre.rrhh.service.AreaService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/areas")
@RequiredArgsConstructor
@Tag(name = "Áreas", description = "Gestión de áreas organizacionales y jerarquías")
public class AreaController {

    private final AreaService service;

    @GetMapping
    @Operation(summary = "Listar áreas")
    public ApiResponse<PageData<AreaResponse>> listar(Pageable pageable,
                                                      @RequestParam(required = false) String nombre,
                                                      @RequestParam(required = false) Long padreId,
                                                      @RequestParam(required = false) String flagEstado) {
        Page<AreaResponse> page = service.listar(pageable, nombre, padreId, flagEstado);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener área por ID")
    public ApiResponse<AreaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @GetMapping("/arbol")
    @Operation(summary = "Obtener árbol jerárquico")
    public ApiResponse<List<AreaTreeResponse>> obtenerArbol() {
        return ApiResponse.ok(service.obtenerArbolJerarquico());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear área")
    public ApiResponse<AreaResponse> crear(@Valid @RequestBody AreaRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar área")
    public ApiResponse<AreaResponse> actualizar(@PathVariable Long id, @Valid @RequestBody AreaRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar área (baja lógica)")
    public ApiResponse<AreaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), AreaConstants.MSG_AREA_DESACTIVADA);
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar área")
    public ApiResponse<AreaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), AreaConstants.MSG_AREA_ACTIVADA);
    }
}
