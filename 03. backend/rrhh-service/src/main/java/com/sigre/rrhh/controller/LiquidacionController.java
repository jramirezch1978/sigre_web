package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.dto.request.LiquidacionCalcularRequest;
import com.sigre.rrhh.dto.response.LiquidacionResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.mapper.LiquidacionMapper;
import com.sigre.rrhh.service.LiquidacionService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/rrhh/liquidaciones")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Liquidaciones", description = "Gestión de liquidaciones de beneficios sociales por cese")
public class LiquidacionController {

    private final LiquidacionService service;
    private final LiquidacionMapper mapper;

    @PostMapping("/calcular")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Calcular liquidación")
    public ResponseEntity<ApiResponse<LiquidacionResponse>> calcular(@Valid @RequestBody LiquidacionCalcularRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(mapper.toResponse(service.calcular(request.getTrabajadorId(), request.getFechaCese())), "Liquidación calculada"));
    }

    @GetMapping
    @Operation(summary = "Listar liquidaciones")
    public ResponseEntity<ApiResponse<PageData<LiquidacionResponse>>> listar(
            Pageable pageable,
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        Page<LiquidacionResponse> page = service.listar(trabajadorId, flagEstado, fechaDesde, fechaHasta, pageable)
                .map(mapper::toResponse);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle de liquidación")
    public ResponseEntity<ApiResponse<LiquidacionResponse>> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.obtenerPorId(id))));
    }

    @PostMapping("/{id}/aprobar")
    @Operation(summary = "Aprobar liquidación")
    public ResponseEntity<ApiResponse<LiquidacionResponse>> aprobar(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.aprobar(id)), "Liquidación aprobada"));
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular liquidación")
    public ResponseEntity<ApiResponse<LiquidacionResponse>> anular(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(mapper.toResponse(service.anular(id)), "Liquidación anulada"));
    }
}
