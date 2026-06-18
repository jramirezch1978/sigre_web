package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.ControlCalidadRequest;
import pe.restaurant.produccion.dto.response.ControlCalidadResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.ControlCalidadMapper;
import pe.restaurant.produccion.service.ControlCalidadService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping({"/api/produccion/controles-calidad", "/api/produccion/control-calidad"})
@RequiredArgsConstructor
public class ControlCalidadController {

    private final ControlCalidadService service;
    private final ControlCalidadMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ControlCalidadResponse>> findAll(
            @RequestParam(required = false) Long ordenTrabajoId,
            @RequestParam(required = false) String resultado,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) Long inspectorId,
            Pageable pageable) {
        var page = service.findAll(ordenTrabajoId, resultado, fechaDesde, fechaHasta, inspectorId, pageable);
        var responses = mapper.toResponseList(page.getContent());
        service.enrich(responses);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<ControlCalidadResponse> findById(@PathVariable Long id) {
        var response = mapper.toResponse(service.findById(id));
        service.enrich(List.of(response));
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ControlCalidadResponse> create(@Valid @RequestBody ControlCalidadRequest request) {
        var entity = mapper.toEntity(request);
        var response = mapper.toResponse(service.create(entity));
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Control de calidad creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ControlCalidadResponse> update(@PathVariable Long id,
                                                       @Valid @RequestBody ControlCalidadRequest request) {
        var entity = mapper.toEntity(request);
        var response = mapper.toResponse(service.update(id, entity));
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Control de calidad actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Control de calidad eliminado");
    }
}
