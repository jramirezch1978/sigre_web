package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfAdaptacionDepRequest;
import pe.restaurant.activos.dto.AfAdaptacionDepResponse;
import pe.restaurant.activos.mapper.AfAdaptacionDepMapper;
import pe.restaurant.activos.service.AfAdaptacionDepService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/adaptaciones-depreciacion")
@RequiredArgsConstructor
public class AfAdaptacionDepController {

    private final AfAdaptacionDepService service;
    private final AfAdaptacionDepMapper mapper;

    @GetMapping("/{id}")
    public ApiResponse<AfAdaptacionDepResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfAdaptacionDepResponse> crear(@Valid @RequestBody AfAdaptacionDepRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfAdaptacionDepResponse> actualizar(@PathVariable Long id,
                                                            @Valid @RequestBody AfAdaptacionDepRequest request) {
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
    public ApiResponse<List<AfAdaptacionDepResponse>> listarPorAdaptacion(@PathVariable Long adaptacionId) {
        var depreciaciones = service.findByAdaptacion(adaptacionId);
        return ApiResponse.ok(mapper.toResponseList(depreciaciones));
    }

    @GetMapping("/periodo/{anio}/{mes}")
    public ApiResponse<List<AfAdaptacionDepResponse>> listarPorPeriodo(@PathVariable Integer anio, 
                                                                        @PathVariable Integer mes) {
        var depreciaciones = service.findByPeriodo(anio, mes);
        return ApiResponse.ok(mapper.toResponseList(depreciaciones));
    }

    @PostMapping("/adaptacion/{adaptacionId}/calcular")
    public ApiResponse<AfAdaptacionDepResponse> calcularDepreciacion(@PathVariable Long adaptacionId,
                                                                      @RequestParam Integer anio,
                                                                      @RequestParam Integer mes) {
        return ApiResponse.ok(mapper.toResponse(service.calcularDepreciacion(adaptacionId, anio, mes)), 
                "Depreciación calculada");
    }
}
