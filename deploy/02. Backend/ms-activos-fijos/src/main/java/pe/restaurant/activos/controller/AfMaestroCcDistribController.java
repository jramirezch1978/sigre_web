package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfMaestroCcDistribRequest;
import pe.restaurant.activos.dto.AfMaestroCcDistribResponse;
import pe.restaurant.activos.entity.AfMaestroCcDistrib;
import pe.restaurant.activos.service.AfMaestroCcDistribService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/maestro/{maestroId}/distribucion-cc")
@RequiredArgsConstructor
public class AfMaestroCcDistribController {

    private final AfMaestroCcDistribService service;

    @GetMapping
    public ApiResponse<List<AfMaestroCcDistribResponse>> listar(@PathVariable Long maestroId) {
        return ApiResponse.ok(service.listarPorMaestro(maestroId).stream().map(this::toResponse).toList());
    }

    @PutMapping
    public ApiResponse<List<AfMaestroCcDistribResponse>> reemplazar(
            @PathVariable Long maestroId,
            @Valid @RequestBody List<AfMaestroCcDistribRequest> lineas) {
        return ApiResponse.ok(service.reemplazarDistribucion(maestroId, lineas).stream().map(this::toResponse).toList(),
                "Distribución por centro de costo actualizada");
    }

    private AfMaestroCcDistribResponse toResponse(AfMaestroCcDistrib e) {
        AfMaestroCcDistribResponse r = new AfMaestroCcDistribResponse();
        r.setId(e.getId());
        r.setAfMaestroId(e.getAfMaestroId());
        r.setCentroCostoId(e.getCentroCostoId());
        r.setPorcentaje(e.getPorcentaje());
        return r;
    }
}
