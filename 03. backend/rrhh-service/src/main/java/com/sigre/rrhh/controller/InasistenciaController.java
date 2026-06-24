package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.InasistenciaConstants;
import com.sigre.rrhh.dto.request.InasistenciaCreateRequest;
import com.sigre.rrhh.dto.request.InasistenciaRegularizarRequest;
import com.sigre.rrhh.dto.request.InasistenciaUpdateRequest;
import com.sigre.rrhh.dto.response.InasistenciaResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.InasistenciaService;

import java.time.LocalDate;

@Tag(name = "Inasistencias", description = "Registro y validación de inasistencias de trabajadores")
@RestController
@RequestMapping("/api/rrhh/inasistencias")
@RequiredArgsConstructor
public class InasistenciaController {

    private final InasistenciaService service;

    @Operation(summary = "Listar inasistencias")
    @GetMapping
    public ApiResponse<PageData<InasistenciaResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaDesde", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<InasistenciaResponse> page = service.listar(trabajadorId, fechaDesde, fechaHasta, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener inasistencia por ID")
    @GetMapping("/{id}")
    public ApiResponse<InasistenciaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Registrar inasistencia")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<InasistenciaResponse> crear(@Valid @RequestBody InasistenciaCreateRequest request) {
        return ApiResponse.ok(service.crear(request), InasistenciaConstants.MSG_CREADA);
    }

    @Operation(summary = "Actualizar inasistencia")
    @PutMapping("/{id}")
    public ApiResponse<InasistenciaResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody InasistenciaUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), InasistenciaConstants.MSG_ACTUALIZADA);
    }

    @Operation(summary = "Justificar inasistencia")
    @PostMapping("/{id}/aprobar")
    public ApiResponse<InasistenciaResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(service.aprobar(id), InasistenciaConstants.MSG_APROBADA);
    }

    @Operation(summary = "Marcar inasistencia como injustificada")
    @PostMapping("/{id}/rechazar")
    public ApiResponse<InasistenciaResponse> rechazar(@PathVariable Long id) {
        return ApiResponse.ok(service.rechazar(id), InasistenciaConstants.MSG_RECHAZADA);
    }

    @Operation(summary = "Anular inasistencia")
    @PostMapping("/{id}/anular")
    public ApiResponse<InasistenciaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id), InasistenciaConstants.MSG_ANULADA);
    }

    @Operation(summary = "Regularizar inasistencia")
    @PostMapping("/{id}/regularizar")
    public ApiResponse<InasistenciaResponse> regularizar(
            @PathVariable Long id,
            @Valid @RequestBody InasistenciaRegularizarRequest request) {
        return ApiResponse.ok(service.regularizar(id, request), InasistenciaConstants.MSG_REGULARIZADA);
    }

    @Operation(summary = "Desactivar inasistencia (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<InasistenciaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), InasistenciaConstants.MSG_DESACTIVADA);
    }
}
