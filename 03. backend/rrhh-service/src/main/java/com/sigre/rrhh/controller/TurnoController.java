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
import com.sigre.rrhh.dto.request.TurnoRequest;
import com.sigre.rrhh.dto.response.TurnoResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.constants.TurnoConstants;
import com.sigre.rrhh.service.TurnoService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/turnos")
@RequiredArgsConstructor
@Tag(name = "Turnos", description = "Gestión de turnos laborales con horarios y días de aplicación")
public class TurnoController {

    private final TurnoService turnoService;

    @GetMapping
    @Operation(summary = "Listar turnos")
    public ApiResponse<PageData<TurnoResponse>> listar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<TurnoResponse> page = turnoService.listar(nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener turno por ID")
    public ApiResponse<TurnoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(turnoService.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear turno")
    public ApiResponse<TurnoResponse> crear(@Valid @RequestBody TurnoRequest request) {
        return ApiResponse.ok(turnoService.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar turno")
    public ApiResponse<TurnoResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TurnoRequest request) {
        return ApiResponse.ok(turnoService.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar turno (baja lógica)")
    public ApiResponse<TurnoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(turnoService.desactivar(id), TurnoConstants.MSG_TURNO_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar turno")
    public ApiResponse<TurnoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(turnoService.activar(id), TurnoConstants.MSG_TURNO_ACTIVADO);
    }

    @GetMapping("/activos")
    @Operation(summary = "Listar turnos activos")
    public ApiResponse<List<TurnoResponse>> listarActivos() {
        return ApiResponse.ok(turnoService.listarActivos());
    }
}
