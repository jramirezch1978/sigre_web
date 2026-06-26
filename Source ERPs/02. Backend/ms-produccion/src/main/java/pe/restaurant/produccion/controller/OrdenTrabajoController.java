package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.OrdenTrabajoRequest;
import pe.restaurant.produccion.dto.response.OrdenTrabajoResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.OrdenTrabajoMapper;
import pe.restaurant.produccion.service.OrdenTrabajoService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/produccion/ordenes-trabajo")
@RequiredArgsConstructor
public class OrdenTrabajoController {

    private final OrdenTrabajoService service;
    private final OrdenTrabajoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<OrdenTrabajoResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long otTipoId,
            @RequestParam(required = false) Long otAdministracionId,
            @RequestParam(name = "fechaInicio", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam(name = "fechaFin", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(codigo, sucursalId, otTipoId, otAdministracionId,
                fechaInicio, fechaFin, flagEstado, pageable);
        var responses = mapper.toResponseList(page.getContent());
        responses.forEach(service::enrich);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<OrdenTrabajoResponse> findById(@PathVariable Long id) {
        var response = mapper.toResponse(service.findById(id));
        service.enrichDetail(response);
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OrdenTrabajoResponse> create(@Valid @RequestBody OrdenTrabajoRequest request) {
        var entity = mapper.toEntity(request);
        var response = mapper.toResponse(service.create(entity));
        service.enrichDetail(response);
        return ApiResponse.ok(response, "Orden de trabajo creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrdenTrabajoResponse> update(@PathVariable Long id,
                                                    @Valid @RequestBody OrdenTrabajoRequest request) {
        var entity = mapper.toEntity(request);
        var response = mapper.toResponse(service.update(id, entity));
        service.enrichDetail(response);
        return ApiResponse.ok(response, "Orden de trabajo actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<OrdenTrabajoResponse> activate(@PathVariable Long id) {
        var response = mapper.toResponse(service.activate(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Orden de trabajo activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<OrdenTrabajoResponse> deactivate(@PathVariable Long id) {
        var response = mapper.toResponse(service.deactivate(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Orden de trabajo desactivada");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<OrdenTrabajoResponse> cerrar(@PathVariable Long id) {
        var response = mapper.toResponse(service.cerrar(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Orden de trabajo cerrada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<OrdenTrabajoResponse> anular(@PathVariable Long id) {
        var response = mapper.toResponse(service.anular(id));
        service.enrich(response);
        return ApiResponse.ok(response, "Orden de trabajo anulada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Orden de trabajo eliminada");
    }
}
