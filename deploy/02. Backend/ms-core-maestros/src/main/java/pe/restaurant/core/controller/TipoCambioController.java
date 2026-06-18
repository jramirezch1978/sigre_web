package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.dto.TipoCambioRequest;
import pe.restaurant.core.dto.TipoCambioResponse;
import pe.restaurant.core.mapper.TipoCambioMapper;
import pe.restaurant.core.service.TipoCambioService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/core/tipos-cambio")
@RequiredArgsConstructor
public class TipoCambioController {

    private final TipoCambioService service;
    private final TipoCambioMapper mapper;

    @GetMapping
    public ApiResponse<PageData<TipoCambioResponse>> findAll(
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = service.findAll(monedaId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<TipoCambioResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/por-fecha")
    public ApiResponse<TipoCambioResponse> findByFecha(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            @RequestParam Long monedaId) {
        return ApiResponse.ok(mapper.toResponse(service.findByFecha(fecha, monedaId)));
    }

    @GetMapping("/ultimo-por-fecha")
    public ApiResponse<TipoCambioResponse> findUltimoByFecha(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            @RequestParam Long monedaId) {
        return ApiResponse.ok(mapper.toResponse(service.findUltimoByFecha(fecha, monedaId)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoCambioResponse> create(@Valid @RequestBody TipoCambioRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<TipoCambioResponse> update(@PathVariable Long id,
                                                  @Valid @RequestBody TipoCambioRequest request) {
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
    public ApiResponse<TipoCambioResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoCambioResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
