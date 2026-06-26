package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfAccesorioRequest;
import pe.restaurant.activos.dto.AfAccesorioResponse;
import pe.restaurant.activos.entity.AfAccesorio;
import pe.restaurant.activos.service.AfAccesorioService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/accesorios")
@RequiredArgsConstructor
public class AfAccesorioController {

    private final AfAccesorioService service;

    @GetMapping("/maestro/{maestroId}")
    public ApiResponse<List<AfAccesorioResponse>> listarPorMaestro(@PathVariable Long maestroId) {
        return ApiResponse.ok(service.findByMaestro(maestroId).stream().map(this::toResponse).toList());
    }

    @GetMapping("/{id}")
    public ApiResponse<AfAccesorioResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfAccesorioResponse> crear(@Valid @RequestBody AfAccesorioRequest request) {
        AfAccesorio e = new AfAccesorio();
        e.setAfMaestroId(request.getAfMaestroId());
        e.setDescripcion(request.getDescripcion());
        e.setCosto(request.getCosto());
        e.setFechaInstalacion(request.getFechaInstalacion());
        return ApiResponse.ok(toResponse(service.create(e)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfAccesorioResponse> actualizar(@PathVariable Long id,
                                                        @Valid @RequestBody AfAccesorioRequest request) {
        AfAccesorio e = service.findById(id);
        e.setDescripcion(request.getDescripcion());
        e.setCosto(request.getCosto());
        e.setFechaInstalacion(request.getFechaInstalacion());
        return ApiResponse.ok(toResponse(service.update(id, e)));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true);
    }

    private AfAccesorioResponse toResponse(AfAccesorio e) {
        AfAccesorioResponse r = new AfAccesorioResponse();
        r.setId(e.getId());
        r.setAfMaestroId(e.getAfMaestroId());
        r.setDescripcion(e.getDescripcion());
        r.setCosto(e.getCosto());
        r.setFechaInstalacion(e.getFechaInstalacion());
        r.setFlagEstado(e.getFlagEstado());
        return r;
    }
}
