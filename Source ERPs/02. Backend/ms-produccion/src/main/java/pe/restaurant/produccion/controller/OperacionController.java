package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.OperacionDetRequest;
import pe.restaurant.produccion.dto.request.OperacionRequest;
import pe.restaurant.produccion.dto.response.OperacionDetResponse;
import pe.restaurant.produccion.dto.response.OperacionResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.OperacionMapper;
import pe.restaurant.produccion.mapper.OperacionesDetMapper;
import pe.restaurant.produccion.service.OperacionService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/produccion/operaciones")
@RequiredArgsConstructor
public class OperacionController {

    private final OperacionService service;
    private final OperacionMapper mapper;
    private final OperacionesDetMapper detMapper;

    @GetMapping
    public ApiResponse<PageData<OperacionResponse>> findAll(
            @RequestParam(required = false) Long ordenTrabajoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(ordenTrabajoId, fechaDesde, fechaHasta, flagEstado, pageable);
        var responses = mapper.toResponseList(page.getContent());
        service.enrich(responses);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<OperacionResponse> findById(@PathVariable Long id) {
        var entity = service.findById(id);
        var response = mapper.toResponse(entity);
        response.setDetalles(detMapper.toResponseList(service.findDetalles(id)));
        service.enrich(response);
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OperacionResponse> create(@Valid @RequestBody OperacionRequest request) {
        var entity = mapper.toEntity(request);
        var detalles = toDetEntityList(request.getDetalles());
        var saved = service.create(entity, detalles);
        var response = mapper.toResponse(saved);
        response.setDetalles(detMapper.toResponseList(service.findDetalles(saved.getId())));
        service.enrich(response);
        return ApiResponse.ok(response, "Operación creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OperacionResponse> update(@PathVariable Long id,
                                                  @Valid @RequestBody OperacionRequest request) {
        var entity = mapper.toEntity(request);
        var detalles = toDetEntityList(request.getDetalles());
        var updated = service.update(id, entity, detalles);
        var response = mapper.toResponse(updated);
        response.setDetalles(detMapper.toResponseList(service.findDetalles(updated.getId())));
        service.enrich(response);
        return ApiResponse.ok(response, "Operación actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<OperacionResponse> activate(@PathVariable Long id) {
        var response = mapper.toResponse(service.activate(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Operación activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<OperacionResponse> deactivate(@PathVariable Long id) {
        var response = mapper.toResponse(service.deactivate(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Operación desactivada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Operación eliminada");
    }

    @GetMapping("/{id}/detalles")
    public ApiResponse<List<OperacionDetResponse>> findDetalles(@PathVariable Long id) {
        var detalles = detMapper.toResponseList(service.findDetalles(id));
        service.enrichDetalles(detalles);
        return ApiResponse.ok(detalles);
    }

    @PostMapping("/{id}/detalles")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<List<OperacionDetResponse>> addDetalles(
            @PathVariable Long id,
            @Valid @RequestBody List<OperacionDetRequest> requests) {
        var detalles = requests.stream().map(detMapper::toEntity).toList();
        var saved = service.addDetalles(id, detalles);
        var responses = detMapper.toResponseList(saved);
        service.enrichDetalles(responses);
        return ApiResponse.ok(responses, "Detalles agregados");
    }

    private List<pe.restaurant.produccion.entity.OperacionesDet> toDetEntityList(
            List<pe.restaurant.produccion.dto.request.OperacionDetRequest> requests) {
        if (requests == null) return null;
        return requests.stream().map(detMapper::toEntity).toList();
    }
}
