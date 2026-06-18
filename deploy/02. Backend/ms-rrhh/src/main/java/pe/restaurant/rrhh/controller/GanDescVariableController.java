package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.GanDescVariableImportarRequest;
import pe.restaurant.rrhh.dto.request.GanDescVariableRequest;
import pe.restaurant.rrhh.dto.response.GanDescVariableResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.service.GanDescVariableService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/ganancias-descuentos-variables")
@RequiredArgsConstructor
@Tag(name = "Ganancias/Descuentos Variables", description = "Gestión de ganancias y descuentos variables")
public class GanDescVariableController {

    private final GanDescVariableService service;

    @GetMapping
    @Operation(summary = "Listar ganancias/descuentos variables")
    public ApiResponse<PageData<GanDescVariableResponse>> listar(
            Pageable pageable,
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Long conceptoId,
            @RequestParam(required = false) Integer anio,
            @RequestParam(required = false) Integer mes,
            @RequestParam(required = false) Long tipoPlanillaId) {
        Page<GanDescVariableResponse> page = service.listar(trabajadorId, conceptoId, anio, mes, tipoPlanillaId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle")
    public ApiResponse<GanDescVariableResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear")
    public ApiResponse<GanDescVariableResponse> crear(@Valid @RequestBody GanDescVariableRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar")
    public ApiResponse<GanDescVariableResponse> actualizar(@PathVariable Long id, @Valid @RequestBody GanDescVariableRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PostMapping("/importar")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Importar ganancias/descuentos variables (batch)")
    public ApiResponse<List<GanDescVariableResponse>> importar(
            @Valid @RequestBody GanDescVariableImportarRequest request) {
        return ApiResponse.ok(service.importar(request));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar (físico)")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ApiResponse.ok(true, "Ganancia/Descuento variable eliminado");
    }
}
