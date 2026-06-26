package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.ProgramacionProduccionRequest;
import pe.restaurant.produccion.dto.response.ProgramacionProduccionResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.ProgramacionProduccionMapper;
import pe.restaurant.produccion.service.ProgramacionProduccionService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/produccion/programaciones")
@RequiredArgsConstructor
public class ProgramacionProduccionController {

    private final ProgramacionProduccionService service;
    private final ProgramacionProduccionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ProgramacionProduccionResponse>> findAll(
            @RequestParam(required = false) Long recetaId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String flagFrecuencia,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(recetaId, sucursalId, flagFrecuencia, fechaDesde, fechaHasta, flagEstado, pageable);
        var responses = mapper.toResponseList(page.getContent());
        service.enrichResponses(responses);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<ProgramacionProduccionResponse> findById(@PathVariable Long id) {
        var response = mapper.toResponse(service.findById(id));
        service.enrichResponses(List.of(response));
        return ApiResponse.ok(response);
    }

    @PostMapping
    public ApiResponse<ProgramacionProduccionResponse> create(@Valid @RequestBody ProgramacionProduccionRequest request) {
        var entity = mapper.toEntity(request);
        var saved = service.create(entity);
        var response = mapper.toResponse(saved);
        service.enrichResponses(List.of(response));
        return ApiResponse.ok(response, "Programación de producción creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<ProgramacionProduccionResponse> update(@PathVariable Long id,
                                                              @Valid @RequestBody ProgramacionProduccionRequest request) {
        var entity = mapper.toEntity(request);
        var updated = service.update(id, entity);
        var response = mapper.toResponse(updated);
        service.enrichResponses(List.of(response));
        return ApiResponse.ok(response, "Programación de producción actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ProgramacionProduccionResponse> activate(@PathVariable Long id) {
        var response = mapper.toResponse(service.activate(id));
        service.enrichResponses(List.of(response));
        return ApiResponse.ok(response, "Programación activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ProgramacionProduccionResponse> deactivate(@PathVariable Long id) {
        var response = mapper.toResponse(service.deactivate(id));
        service.enrichResponses(List.of(response));
        return ApiResponse.ok(response, "Programación desactivada");
    }

}
