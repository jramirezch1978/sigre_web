package com.sigre.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import java.util.List;
import com.sigre.contabilidad.dto.request.CentrosCostoRequest;
import com.sigre.contabilidad.dto.response.CentroCostoArbolItem;
import com.sigre.contabilidad.dto.response.CentrosCostoResponse;
import com.sigre.contabilidad.dto.response.PageData;
import com.sigre.contabilidad.mapper.CentrosCostoMapper;
import com.sigre.contabilidad.service.CentrosCostoService;

@RestController
@RequestMapping("/api/contabilidad/centros-costo")
@RequiredArgsConstructor
@Tag(name = "Centros de Costo", description = "Mantenimiento de centros de costo (contabilidad.centros_costo)")
public class CentrosCostoController {

    private final CentrosCostoService service;
    private final CentrosCostoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar centros de costo")
    public ApiResponse<PageData<CentrosCostoResponse>> findAll(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(size = 20) Pageable pageable) {
        var page = service.findAll(q, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/arbol")
    @Operation(summary = "Centros de costo activos con jerarquía (niv1/niv2/niv3) para treeview")
    public ApiResponse<List<CentroCostoArbolItem>> arbol() {
        return ApiResponse.ok(service.arbolActivos(), "Árbol de centros de costo");
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener centro de costo por ID")
    public ApiResponse<CentrosCostoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear centro de costo")
    public ApiResponse<CentrosCostoResponse> create(@Valid @RequestBody CentrosCostoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(request)), "Centro de costo creado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar centro de costo")
    public ApiResponse<CentrosCostoResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody CentrosCostoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.update(id, request)), "Centro de costo actualizado");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar centro de costo (lógico)")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Centro de costo desactivado");
    }
}
