package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfAdaptacionDetRequest;
import pe.restaurant.activos.dto.AfAdaptacionDetResponse;
import pe.restaurant.activos.mapper.AfAdaptacionDetMapper;
import pe.restaurant.activos.service.AfAdaptacionDetService;
import pe.restaurant.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/activos/adaptaciones-detalles")
@RequiredArgsConstructor
public class AfAdaptacionDetController {

    private final AfAdaptacionDetService service;
    private final AfAdaptacionDetMapper mapper;

    @GetMapping("/{id}")
    public ApiResponse<AfAdaptacionDetResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfAdaptacionDetResponse> crear(@Valid @RequestBody AfAdaptacionDetRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfAdaptacionDetResponse> actualizar(@PathVariable Long id,
                                                            @Valid @RequestBody AfAdaptacionDetRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/adaptacion/{adaptacionId}")
    public ApiResponse<List<AfAdaptacionDetResponse>> listarPorAdaptacion(@PathVariable Long adaptacionId) {
        var detalles = service.findByAdaptacion(adaptacionId);
        return ApiResponse.ok(mapper.toResponseList(detalles));
    }

    @GetMapping("/adaptacion/{adaptacionId}/total")
    public ApiResponse<BigDecimal> calcularTotal(@PathVariable Long adaptacionId) {
        return ApiResponse.ok(service.calcularTotal(adaptacionId));
    }
}
