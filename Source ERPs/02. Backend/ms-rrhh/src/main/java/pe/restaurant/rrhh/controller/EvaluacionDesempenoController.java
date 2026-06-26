package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import pe.restaurant.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import pe.restaurant.rrhh.dto.response.EvaluacionDesempenoResponse;
import pe.restaurant.rrhh.service.EvaluacionDesempenoService;

@Tag(name = "Evaluaciones de Desempeño", description = "Registro de evaluaciones de desempeño")
@RestController
@RequestMapping("/api/rrhh/evaluaciones-desempeno")
@RequiredArgsConstructor
public class EvaluacionDesempenoController {

    private final EvaluacionDesempenoService service;

    @Operation(summary = "Listar evaluaciones")
    @GetMapping
    public ApiResponse<PageData<EvaluacionDesempenoResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Integer periodoAnio,
            @RequestParam(required = false) Integer periodoSemestre,
            Pageable pageable) {
        Page<EvaluacionDesempenoResponse> page = service.listar(trabajadorId, periodoAnio, periodoSemestre, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener evaluación por ID")
    @GetMapping("/{id}")
    public ApiResponse<EvaluacionDesempenoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear evaluación")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EvaluacionDesempenoResponse> crear(@Valid @RequestBody EvaluacionDesempenoCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar evaluación")
    @PutMapping("/{id}")
    public ApiResponse<EvaluacionDesempenoResponse> actualizar(@PathVariable Long id, @Valid @RequestBody EvaluacionDesempenoUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Eliminar evaluación (físico)")
    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ApiResponse.ok(true, "Evaluación eliminada correctamente");
    }
}
