package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.dto.PlanContableDetResponse;
import com.sigre.core.repository.PlanContableDetRepository;

import java.util.List;

/**
 * Lectura del plan contable detalle (`contabilidad.plan_contable_det`) desde core.
 * - {@code GET /api/core/plan-contable-det} : selector/autocomplete (q, size).
 * - {@code GET /api/core/plan-contable-det/{id}} : usado por finanzas-service (Feign)
 *   para validar la cuenta contable de una cuenta bancaria.
 * Solo lectura: el mantenimiento del plan contable se hace por otra vía.
 */
@RestController
@RequestMapping("/api/core/plan-contable-det")
@RequiredArgsConstructor
public class PlanContableDetController {

    private final PlanContableDetRepository repository;

    /** Busca cuentas activas por código o descripción (máx. {@code size}, por defecto 50). */
    @GetMapping
    public ApiResponse<List<PlanContableDetResponse>> buscar(
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "size", defaultValue = "50") int size) {
        int limite = Math.min(Math.max(size, 1), 200);
        List<PlanContableDetResponse> data = repository
                .buscarResumen(q, PageRequest.of(0, limite))
                .stream()
                .map(this::toResponse)
                .toList();
        return ApiResponse.ok(data);
    }

    /** Obtiene una cuenta por id (404 si no existe). El flagEstado real permite a
     *  finanzas-service rechazar cuentas inactivas. */
    @GetMapping("/{id}")
    public ApiResponse<PlanContableDetResponse> porId(@PathVariable Long id) {
        return repository.findById(id)
                .map(p -> ApiResponse.ok(new PlanContableDetResponse(
                        p.getId(), p.getCntaCtbl(), p.getDescCnta(), null, null, p.getFlagEstado())))
                .orElseThrow(() -> new ResourceNotFoundException("PlanContableDet", id));
    }

    /** Mapea la proyección [id, cntaCtbl, descCnta] al DTO (nombre ← descCnta, activo). */
    private PlanContableDetResponse toResponse(Object[] row) {
        Long id = row[0] != null ? ((Number) row[0]).longValue() : null;
        String cntaCtbl = (String) row[1];
        String nombre = (String) row[2];
        return new PlanContableDetResponse(id, cntaCtbl, nombre, null, null, "1");
    }
}
