package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.VacacionConstants;
import com.sigre.rrhh.dto.request.SolicitarGoceRequest;
import com.sigre.rrhh.dto.request.VacacionCreateRequest;
import com.sigre.rrhh.dto.request.VacacionObservarRequest;
import com.sigre.rrhh.dto.request.VacacionProcesarRequest;
import com.sigre.rrhh.dto.request.VacacionUpdateRequest;
import com.sigre.rrhh.dto.response.SaldoVacacionDto;
import com.sigre.rrhh.dto.response.VacacionResponse;
import com.sigre.rrhh.service.VacacionService;

import java.util.List;

@Tag(name = "Vacaciones", description = "Gestión de vacaciones y programación vacacional")
@RestController
@RequestMapping("/api/rrhh/vacaciones")
@RequiredArgsConstructor
public class VacacionController {

    private final VacacionService service;

    @Operation(summary = "Listar períodos vacacionales")
    @GetMapping
    public ApiResponse<PageData<VacacionResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer periodoAnio,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<VacacionResponse> page = service.listar(trabajadorId, periodoAnio, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener vacación por ID")
    @GetMapping("/{id}")
    public ApiResponse<VacacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear período vacacional")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<VacacionResponse> crear(@Valid @RequestBody VacacionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar período vacacional")
    @PutMapping("/{id}")
    public ApiResponse<VacacionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody VacacionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Solicitar goce vacacional")
    @PostMapping("/{id}/solicitar-goce")
    public ApiResponse<VacacionResponse> solicitarGoce(@PathVariable Long id, @Valid @RequestBody SolicitarGoceRequest request) {
        return ApiResponse.ok(service.solicitarGoce(id, request));
    }

    @Operation(summary = "Aprobar goce vacacional")
    @PostMapping("/{id}/aprobar")
    public ApiResponse<VacacionResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(service.aprobar(id));
    }

    @Operation(summary = "Rechazar goce vacacional")
    @PostMapping("/{id}/rechazar")
    public ApiResponse<VacacionResponse> rechazar(@PathVariable Long id) {
        return ApiResponse.ok(service.rechazar(id));
    }

    @Operation(summary = "Reprogramar goce vacacional")
    @PostMapping("/{id}/reprogramar")
    public ApiResponse<VacacionResponse> reprogramar(@PathVariable Long id, @Valid @RequestBody SolicitarGoceRequest request) {
        return ApiResponse.ok(service.reprogramar(id, request));
    }

    @Operation(summary = "Desactivar período vacacional")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<VacacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), VacacionConstants.MSG_DESACTIVADO);
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO — NUEVAS
    // ══════════════════════════════════════════════════════════════

    @Operation(summary = "Observar goce vacacional")
    @PostMapping("/{id}/observar")
    public ApiResponse<VacacionResponse> observar(@PathVariable Long id, @Valid @RequestBody VacacionObservarRequest request) {
        return ApiResponse.ok(service.observar(id, request));
    }

    @Operation(summary = "Anular goce vacacional")
    @PostMapping("/{id}/anular")
    public ApiResponse<VacacionResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id));
    }

    @Operation(summary = "Cerrar goce vacacional")
    @PostMapping("/{id}/cerrar")
    public ApiResponse<VacacionResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(service.cerrar(id));
    }

    // ══════════════════════════════════════════════════════════════
    //  CONSULTAS Y PROCESOS BATCH
    // ══════════════════════════════════════════════════════════════

    @Operation(summary = "Bandeja de aprobación de vacaciones")
    @GetMapping("/bandeja-aprobacion")
    public ApiResponse<PageData<VacacionResponse>> bandejaAprobacion(
            @RequestParam(required = false) Integer periodoAnio,
            Pageable pageable) {
        Page<VacacionResponse> page = service.bandejaAprobacion(periodoAnio, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Consultar saldos vacacionales")
    @GetMapping("/saldos")
    public ApiResponse<List<SaldoVacacionDto>> consultarSaldos(
            @RequestParam(required = false) Integer periodoAnio) {
        return ApiResponse.ok(service.consultarSaldos(periodoAnio));
    }

    @Operation(summary = "Procesar planificación vacacional")
    @PostMapping("/procesar")
    public ApiResponse<VacacionResponse> procesar(@Valid @RequestBody VacacionProcesarRequest request) {
        return ApiResponse.ok(service.procesar(request.periodoAnio()));
    }
}
