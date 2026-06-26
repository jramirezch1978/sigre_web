package pe.restaurant.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.request.PlanContableRequest;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.dto.response.PlanContableResponse;
import pe.restaurant.contabilidad.service.PlanContableService;

@Tag(name = "Plan Contable", description = "Mantenimiento de planes contables (contabilidad.plan_contable)")
@RestController
@RequestMapping("/api/contabilidad/plan-contable")
@RequiredArgsConstructor
public class PlanContableController {

    private final PlanContableService service;

    @Operation(summary = "Listar planes contables",
               description = "Filtros: codigo (búsqueda parcial), anio, flagEstado")
    @GetMapping
    public ApiResponse<PageData<PlanContableResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<PlanContableResponse> page = service.listar(codigo, anio, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener plan contable por ID")
    @GetMapping("/{id}")
    public ApiResponse<PlanContableResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Registrar plan contable")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PlanContableResponse> crear(@Valid @RequestBody PlanContableRequest request) {
        return ApiResponse.ok(service.crear(request), "Plan contable creado");
    }

    @Operation(summary = "Actualizar plan contable")
    @PutMapping("/{id}")
    public ApiResponse<PlanContableResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody PlanContableRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Plan contable actualizado");
    }

    @Operation(summary = "Cambiar estado del plan contable")
    @PatchMapping("/{id}/estado")
    public ApiResponse<PlanContableResponse> cambiarEstado(@PathVariable Long id) {
        return ApiResponse.ok(service.cambiarEstado(id));
    }
}
