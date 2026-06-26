package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfValuacionRequest;
import pe.restaurant.activos.dto.AfValuacionResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfValuacionMapper;
import pe.restaurant.activos.service.AfValuacionService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/activos/valuaciones")
@RequiredArgsConstructor
public class AfValuacionController {

    private final AfValuacionService service;
    private final AfValuacionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfValuacionResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfValuacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfValuacionResponse> crear(@Valid @RequestBody AfValuacionRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfValuacionResponse> actualizar(@PathVariable Long id,
                                                        @Valid @RequestBody AfValuacionRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfValuacionResponse>> listarPorActivo(@PathVariable Long activoId) {
        var valuaciones = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(valuaciones));
    }

    @GetMapping("/periodo")
    public ApiResponse<List<AfValuacionResponse>> listarPorPeriodo(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin) {
        var valuaciones = service.findByPeriodo(fechaInicio, fechaFin);
        return ApiResponse.ok(mapper.toResponseList(valuaciones));
    }

    @PatchMapping("/{id}/validar")
    public ApiResponse<AfValuacionResponse> validar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.validar(id)), "Valuación validada");
    }

    @PatchMapping("/{id}/aprobar")
    public ApiResponse<AfValuacionResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.aprobar(id)), "Valuación aprobada — base depreciable actualizada");
    }

    @PatchMapping("/{id}/anular")
    public ApiResponse<AfValuacionResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.anular(id)), "Valuación anulada");
    }
}
