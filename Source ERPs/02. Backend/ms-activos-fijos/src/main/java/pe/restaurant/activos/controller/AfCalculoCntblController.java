package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfCalculoCntblRequest;
import pe.restaurant.activos.dto.AfCalculoCntblResponse;
import pe.restaurant.activos.dto.DepreciacionMensualRequest;
import pe.restaurant.activos.mapper.AfCalculoCntblMapper;
import pe.restaurant.activos.service.AfCalculoCntblService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/depreciacion")
@RequiredArgsConstructor
public class AfCalculoCntblController {

    private final AfCalculoCntblService service;
    private final AfCalculoCntblMapper mapper;

    @GetMapping("/{id}")
    public ApiResponse<AfCalculoCntblResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/maestro/{id}")
    public ApiResponse<List<AfCalculoCntblResponse>> obtenerHistorialPorActivo(@PathVariable Long id) {
        var historial = service.obtenerHistorialPorActivo(id);
        return ApiResponse.ok(mapper.toResponseList(historial));
    }

    @GetMapping("/periodo/{anio}/{mes}")
    public ApiResponse<List<AfCalculoCntblResponse>> obtenerPorPeriodo(
            @PathVariable Integer anio,
            @PathVariable Integer mes) {
        var depreciaciones = service.obtenerPorPeriodo(anio, mes);
        return ApiResponse.ok(mapper.toResponseList(depreciaciones));
    }

    @PostMapping("/calcular-mensual")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfCalculoCntblResponse> calcularDepreciacionMensual(
            @Valid @RequestBody DepreciacionMensualRequest request,
            @RequestParam Long afMaestroId) {
        var calculo = service.calcularDepreciacionMensual(
                afMaestroId, request.getAnio(), request.getMes(), request.getUnidadesProducidasPeriodo());
        return ApiResponse.ok(mapper.toResponse(calculo), "Depreciación calculada exitosamente");
    }

    @PostMapping("/calcular-masivo")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<List<AfCalculoCntblResponse>> calcularDepreciacionMasiva(
            @Valid @RequestBody DepreciacionMensualRequest request) {
        var calculos = service.calcularDepreciacionMasiva(request.getAnio(), request.getMes());
        return ApiResponse.ok(
                mapper.toResponseList(calculos),
                "Depreciación masiva calculada: " + calculos.size() + " activos procesados"
        );
    }

    @GetMapping("/reporte/{anio}/{mes}")
    public ApiResponse<List<AfCalculoCntblResponse>> generarReporte(
            @PathVariable Integer anio,
            @PathVariable Integer mes) {
        var reporte = service.obtenerPorPeriodo(anio, mes);
        return ApiResponse.ok(mapper.toResponseList(reporte));
    }

    @PutMapping("/{id}")
    public ApiResponse<AfCalculoCntblResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody AfCalculoCntblRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
