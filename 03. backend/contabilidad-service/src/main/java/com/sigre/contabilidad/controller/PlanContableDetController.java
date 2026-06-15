package com.sigre.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.contabilidad.dto.request.PlanContableDetRequest;
import com.sigre.contabilidad.dto.response.PageData;
import com.sigre.contabilidad.dto.response.PlanContableDetResponse;
import com.sigre.contabilidad.mapper.PlanContableDetMapper;
import com.sigre.contabilidad.repository.PlanContableDetRepository;
import com.sigre.contabilidad.service.PlanContableDetService;

import java.util.List;

@RestController
@RequestMapping("/api/contabilidad/plan-contable-det")
@RequiredArgsConstructor
@Tag(name = "Plan Contable", description = "Mantenimiento de cuentas contables (contabilidad.plan_contable_det)")
public class PlanContableDetController {

    private final PlanContableDetService service;
    private final PlanContableDetMapper mapper;
    private final PlanContableDetRepository repository;

    @GetMapping
    @Operation(summary = "Listar o buscar cuentas contables")
    public ApiResponse<?> findAll(
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "planContableId", required = false) Long planContableId,
            @RequestParam(value = "flagEstado", required = false) String flagEstado,
            @RequestParam(value = "size", required = false) Integer selectorSize,
            @PageableDefault(size = 20) Pageable pageable) {
        if (selectorSize != null) {
            int limite = Math.min(Math.max(selectorSize, 1), 200);
            List<PlanContableDetResponse> data = repository
                    .buscarResumen(q, PageRequest.of(0, limite))
                    .stream()
                    .map(this::toResumenResponse)
                    .toList();
            return ApiResponse.ok(data);
        }
        var page = service.findAll(planContableId, q, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener cuenta contable por ID")
    public ApiResponse<PlanContableDetResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear cuenta contable")
    public ApiResponse<PlanContableDetResponse> create(@Valid @RequestBody PlanContableDetRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(request)), "Cuenta contable creada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar cuenta contable")
    public ApiResponse<PlanContableDetResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody PlanContableDetRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.update(id, request)), "Cuenta contable actualizada");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar cuenta contable")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Cuenta contable desactivada");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar cuenta contable")
    public ApiResponse<PlanContableDetResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Cuenta contable activada");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar cuenta contable (PATCH)")
    public ApiResponse<PlanContableDetResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Cuenta contable desactivada");
    }

    private PlanContableDetResponse toResumenResponse(Object[] row) {
        Long id = row[0] != null ? ((Number) row[0]).longValue() : null;
        String cntaCtbl = (String) row[1];
        String nombre = (String) row[2];
        return PlanContableDetResponse.builder()
                .id(id)
                .cntaCtbl(cntaCtbl)
                .nombre(nombre)
                .flagEstado("1")
                .build();
    }
}
