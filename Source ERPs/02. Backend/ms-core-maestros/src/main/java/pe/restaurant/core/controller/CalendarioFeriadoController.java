package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.CalendarioFeriadoRequest;
import pe.restaurant.core.dto.CalendarioFeriadoResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.CalendarioFeriadoMapper;
import pe.restaurant.core.service.CalendarioFeriadoService;

@RestController
@RequestMapping("/api/core/calendario-feriados")
@RequiredArgsConstructor
public class CalendarioFeriadoController {

    private final CalendarioFeriadoService service;
    private final CalendarioFeriadoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CalendarioFeriadoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CalendarioFeriadoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CalendarioFeriadoResponse> create(@Valid @RequestBody CalendarioFeriadoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CalendarioFeriadoResponse> update(@PathVariable Long id, @Valid @RequestBody CalendarioFeriadoRequest request) {
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
    public ApiResponse<CalendarioFeriadoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CalendarioFeriadoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
