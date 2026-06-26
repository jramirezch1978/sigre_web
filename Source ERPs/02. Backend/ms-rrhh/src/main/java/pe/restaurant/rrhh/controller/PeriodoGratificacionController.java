package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import pe.restaurant.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoGratificacionResponse;
import pe.restaurant.rrhh.constants.PeriodoGratificacionConstants;
import pe.restaurant.rrhh.service.PeriodoGratificacionService;

@Tag(name = "Períodos de Gratificación", description = "Catálogo de períodos de gratificación")
@RestController
@RequestMapping("/api/rrhh/periodos-gratificacion")
@RequiredArgsConstructor
public class PeriodoGratificacionController {

    private final PeriodoGratificacionService service;

    @Operation(summary = "Listar períodos de gratificación")
    @GetMapping
    public ApiResponse<PageData<PeriodoGratificacionResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<PeriodoGratificacionResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener período de gratificación por ID")
    @GetMapping("/{id}")
    public ApiResponse<PeriodoGratificacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear período de gratificación")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PeriodoGratificacionResponse> crear(@Valid @RequestBody PeriodoGratificacionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar período de gratificación")
    @PutMapping("/{id}")
    public ApiResponse<PeriodoGratificacionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody PeriodoGratificacionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar período de gratificación (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<PeriodoGratificacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), PeriodoGratificacionConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar período de gratificación")
    @PatchMapping("/{id}/activar")
    public ApiResponse<PeriodoGratificacionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), PeriodoGratificacionConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar períodos de gratificación activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<PeriodoGratificacionResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
