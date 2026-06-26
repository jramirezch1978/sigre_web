package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfRevaluacionRequest;
import pe.restaurant.activos.dto.AfRevaluacionResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.entity.AfRevaluacion;
import pe.restaurant.activos.service.AfRevaluacionService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/revaluaciones")
@RequiredArgsConstructor
public class AfRevaluacionController {

    private final AfRevaluacionService service;

    @GetMapping
    public ApiResponse<PageData<AfRevaluacionResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(this::toResponse).toList()));
    }

    @GetMapping("/maestro/{maestroId}")
    public ApiResponse<List<AfRevaluacionResponse>> listarPorMaestro(@PathVariable Long maestroId) {
        return ApiResponse.ok(service.findByMaestro(maestroId).stream().map(this::toResponse).toList());
    }

    @GetMapping("/{id}")
    public ApiResponse<AfRevaluacionResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfRevaluacionResponse> crear(@Valid @RequestBody AfRevaluacionRequest request) {
        AfRevaluacion e = new AfRevaluacion();
        e.setAfMaestroId(request.getAfMaestroId());
        e.setFecha(request.getFecha());
        e.setValorAnterior(request.getValorAnterior());
        e.setValorNuevo(request.getValorNuevo());
        e.setSustento(request.getSustento());
        e.setPeritoId(request.getPeritoId());
        return ApiResponse.ok(toResponse(service.create(e)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfRevaluacionResponse> actualizar(@PathVariable Long id,
                                                         @Valid @RequestBody AfRevaluacionRequest request) {
        AfRevaluacion e = new AfRevaluacion();
        e.setFecha(request.getFecha());
        e.setValorAnterior(request.getValorAnterior());
        e.setValorNuevo(request.getValorNuevo());
        e.setSustento(request.getSustento());
        e.setPeritoId(request.getPeritoId());
        return ApiResponse.ok(toResponse(service.update(id, e)));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true);
    }

    private AfRevaluacionResponse toResponse(AfRevaluacion e) {
        AfRevaluacionResponse r = new AfRevaluacionResponse();
        r.setId(e.getId());
        r.setAfMaestroId(e.getAfMaestroId());
        r.setFecha(e.getFecha());
        r.setValorAnterior(e.getValorAnterior());
        r.setValorNuevo(e.getValorNuevo());
        r.setSustento(e.getSustento());
        r.setPeritoId(e.getPeritoId());
        r.setFlagEstado(e.getFlagEstado());
        return r;
    }
}
