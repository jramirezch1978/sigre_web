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
import pe.restaurant.rrhh.dto.request.CntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.CntaCrrteDetResponse;
import pe.restaurant.rrhh.dto.response.CntaCrrteResponse;
import pe.restaurant.rrhh.service.CntaCrrteService;
import java.util.List;

@Tag(name = "Cuentas Corrientes", description = "Gestión de cuentas corrientes de trabajadores")
@RestController
@RequestMapping("/api/rrhh/cuentas-corrientes")
@RequiredArgsConstructor
public class CntaCrrteController {

    private final CntaCrrteService service;

    @Operation(summary = "Listar cuentas corrientes")
    @GetMapping
    public ApiResponse<PageData<CntaCrrteResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) String flagEstado, Pageable pageable) {
        Page<CntaCrrteResponse> page = service.listar(trabajadorId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener cuenta corriente por ID")
    @GetMapping("/{id}")
    public ApiResponse<CntaCrrteResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Aperturar cuenta corriente")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CntaCrrteResponse> crear(@Valid @RequestBody CntaCrrteCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar cuenta corriente")
    @PutMapping("/{id}")
    public ApiResponse<CntaCrrteResponse> actualizar(@PathVariable Long id, @Valid @RequestBody CntaCrrteUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Cambiar estado (activar/cerrar)")
    @PatchMapping("/{id}/estado")
    public ApiResponse<CntaCrrteResponse> cambiarEstado(@PathVariable Long id) {
        return ApiResponse.ok(service.cambiarEstado(id));
    }

    @Operation(summary = "Listar movimientos")
    @GetMapping("/{id}/movimientos")
    public ApiResponse<List<CntaCrrteDetResponse>> listarMovimientos(@PathVariable Long id) {
        return ApiResponse.ok(service.listarMovimientos(id));
    }

    @Operation(summary = "Obtener movimiento por ID")
    @GetMapping("/{id}/movimientos/{movimientoId}")
    public ApiResponse<CntaCrrteDetResponse> obtenerMovimiento(@PathVariable Long id, @PathVariable Long movimientoId) {
        return ApiResponse.ok(service.obtenerMovimiento(id, movimientoId));
    }

    @Operation(summary = "Registrar movimiento")
    @PostMapping("/{id}/movimientos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CntaCrrteDetResponse> crearMovimiento(@PathVariable Long id, @Valid @RequestBody CntaCrrteMovimientoRequest request) {
        return ApiResponse.ok(service.crearMovimiento(id, request));
    }

    @Operation(summary = "Actualizar movimiento")
    @PutMapping("/{id}/movimientos/{movimientoId}")
    public ApiResponse<CntaCrrteDetResponse> actualizarMovimiento(
            @PathVariable Long id, @PathVariable Long movimientoId,
            @Valid @RequestBody CntaCrrteMovimientoUpdateRequest request) {
        return ApiResponse.ok(service.actualizarMovimiento(id, movimientoId, request));
    }

    @Operation(summary = "Eliminar movimiento")
    @DeleteMapping("/{id}/movimientos/{movimientoId}")
    public ApiResponse<Boolean> eliminarMovimiento(@PathVariable Long id, @PathVariable Long movimientoId) {
        service.eliminarMovimiento(id, movimientoId);
        return ApiResponse.ok(true, "Movimiento eliminado correctamente");
    }
}
