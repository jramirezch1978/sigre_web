package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfAdaptacionRequest;
import pe.restaurant.activos.dto.AfAdaptacionResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfAdaptacionMapper;
import pe.restaurant.activos.service.AfAdaptacionService;
import pe.restaurant.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/activos/adaptaciones")
@RequiredArgsConstructor
public class AfAdaptacionController {

    private final AfAdaptacionService service;
    private final AfAdaptacionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfAdaptacionResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfAdaptacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfAdaptacionResponse> crear(@Valid @RequestBody AfAdaptacionRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfAdaptacionResponse> actualizar(@PathVariable Long id,
                                                         @Valid @RequestBody AfAdaptacionRequest request) {
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
    public ApiResponse<List<AfAdaptacionResponse>> listarPorActivo(@PathVariable Long activoId) {
        var adaptaciones = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(adaptaciones));
    }

    @GetMapping("/rango-fechas")
    public ApiResponse<List<AfAdaptacionResponse>> listarPorRangoFechas(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin) {
        var adaptaciones = service.findByFechaRange(fechaInicio, fechaFin);
        return ApiResponse.ok(mapper.toResponseList(adaptaciones));
    }

    @PatchMapping("/{id}/validar")
    public ApiResponse<AfAdaptacionResponse> validar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.validar(id)), "Adaptación validada");
    }

    @PatchMapping("/{id}/capitalizar")
    public ApiResponse<AfAdaptacionResponse> capitalizar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.capitalizar(id)), "Adaptación capitalizada — base depreciable actualizada");
    }

    @GetMapping("/activo/{activoId}/total-capitalizado")
    public ApiResponse<BigDecimal> obtenerTotalCapitalizado(@PathVariable Long activoId) {
        return ApiResponse.ok(service.obtenerTotalCapitalizado(activoId));
    }
}
