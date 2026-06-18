package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.EjercicioPeriodoRequest;
import pe.restaurant.core.dto.EjercicioPeriodoResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.EjercicioPeriodoMapper;
import pe.restaurant.core.service.EjercicioPeriodoService;

@RestController
@RequestMapping("/api/core/ejercicios-periodos")
@RequiredArgsConstructor
public class EjercicioPeriodoController {

    private final EjercicioPeriodoService service;
    private final EjercicioPeriodoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<EjercicioPeriodoResponse>> findAll(
            @RequestParam(required = false) Integer anio,
            Pageable pageable) {
        var page = service.findAll(anio, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<EjercicioPeriodoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EjercicioPeriodoResponse> create(@Valid @RequestBody EjercicioPeriodoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<EjercicioPeriodoResponse> update(@PathVariable Long id, @Valid @RequestBody EjercicioPeriodoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<EjercicioPeriodoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EjercicioPeriodoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
