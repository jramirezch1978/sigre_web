package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.GanDescFijoEstadoRequest;
import com.sigre.rrhh.dto.request.GanDescFijoRequest;
import com.sigre.rrhh.dto.response.GanDescFijoResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.mapper.GanDescFijoMapper;
import com.sigre.rrhh.service.GanDescFijoService;

@RestController
@RequestMapping("/api/rrhh/ganancias-descuentos-fijos")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Ganancias/Descuentos Fijos", description = "Gestión de ganancias y descuentos fijos")
public class GanDescFijoController {

    private final GanDescFijoService service;
    private final GanDescFijoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar ganancias/descuentos fijos")
    public ResponseEntity<ApiResponse<PageData<GanDescFijoResponse>>> listar(
            Pageable pageable,
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Long conceptoId,
            @RequestParam(required = false) String flagEstado) {
        Page<GanDescFijoResponse> page = service.listar(trabajadorId, conceptoId, flagEstado, pageable)
                .map(mapper::toResponse);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle de ganancia/descuento fijo")
    public ResponseEntity<ApiResponse<GanDescFijoResponse>> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.obtenerPorId(id))));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear ganancia/descuento fijo")
    public ResponseEntity<ApiResponse<GanDescFijoResponse>> crear(@Valid @RequestBody GanDescFijoRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(mapper.toResponse(service.crear(request)), "Ganancia/descuento fijo creado"));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar ganancia/descuento fijo")
    public ResponseEntity<ApiResponse<GanDescFijoResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody GanDescFijoRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.actualizar(id, request)), "Ganancia/descuento fijo actualizado"));
    }

    @PatchMapping("/{id}/estado")
    @Operation(summary = "Cambiar estado")
    public ResponseEntity<ApiResponse<GanDescFijoResponse>> cambiarEstado(@PathVariable Long id, @Valid @RequestBody GanDescFijoEstadoRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.cambiarEstado(id, request)),
                "1".equals(request.getFlagEstado()) ? "Registro activado" : "Registro inactivado"));
    }
}
