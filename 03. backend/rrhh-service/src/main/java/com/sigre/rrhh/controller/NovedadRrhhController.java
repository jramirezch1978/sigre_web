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
import com.sigre.rrhh.constants.NovedadRrhhConstants;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhDetRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhDetResponse;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import com.sigre.rrhh.service.NovedadRrhhService;
import java.time.LocalDate;
import java.util.List;

@Tag(name = "Novedades RRHH", description = "Gestión de novedades de trabajadores")
@RestController
@RequestMapping("/api/rrhh/novedades")
@RequiredArgsConstructor
public class NovedadRrhhController {

    private final NovedadRrhhService service;

    @Operation(summary = "Listar novedades")
    @GetMapping
    public ApiResponse<PageData<NovedadRrhhResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Long tipoNovedadRrhhId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaIni", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<NovedadRrhhResponse> page = service.listar(trabajadorId, tipoNovedadRrhhId, fechaDesde, fechaHasta, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener novedad por ID")
    @GetMapping("/{id}")
    public ApiResponse<NovedadRrhhResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear novedad")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NovedadRrhhResponse> crear(@Valid @RequestBody NovedadRrhhCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar novedad")
    @PutMapping("/{id}")
    public ApiResponse<NovedadRrhhResponse> actualizar(@PathVariable Long id, @Valid @RequestBody NovedadRrhhUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar novedad (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<NovedadRrhhResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), NovedadRrhhConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Listar detalles de novedad")
    @GetMapping("/{id}/detalles")
    public ApiResponse<List<NovedadRrhhDetResponse>> listarDetalles(@PathVariable Long id) {
        return ApiResponse.ok(service.listarDetalles(id));
    }

    @Operation(summary = "Agregar detalle a novedad")
    @PostMapping("/{id}/detalles")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NovedadRrhhDetResponse> crearDetalle(@PathVariable Long id, @Valid @RequestBody NovedadRrhhDetRequest request) {
        return ApiResponse.ok(service.crearDetalle(id, request));
    }

    @Operation(summary = "Eliminar detalle de novedad")
    @DeleteMapping("/{id}/detalles/{detalleId}")
    public ApiResponse<Boolean> eliminarDetalle(@PathVariable Long id, @PathVariable Long detalleId) {
        service.eliminarDetalle(id, detalleId);
        return ApiResponse.ok(true, "Detalle eliminado correctamente");
    }
}
