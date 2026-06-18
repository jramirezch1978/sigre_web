package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.EjecutorRequest;
import pe.restaurant.produccion.dto.response.EjecutorResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.EjecutorMapper;
import pe.restaurant.produccion.service.EjecutorService;

import java.util.List;

@RestController
@RequestMapping("/api/produccion/ejecutores")
@RequiredArgsConstructor
public class EjecutorController {

    private final EjecutorService service;
    private final EjecutorMapper mapper;

    @GetMapping
    public ApiResponse<PageData<EjecutorResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String flagExterno,
            Pageable pageable) {
        var page = service.findAll(codigo, nombre, flagEstado, flagExterno, pageable);
        var responses = mapper.toResponseList(page.getContent());
        service.enrich(responses);
        return ApiResponse.ok(PageData.of(page, responses));
    }

    @GetMapping("/{id}")
    public ApiResponse<EjecutorResponse> findById(@PathVariable Long id) {
        var response = mapper.toResponse(service.findById(id));
        service.enrich(List.of(response));
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EjecutorResponse> create(@Valid @RequestBody EjecutorRequest request) {
        var entity = mapper.toEntity(request);
        var saved = service.create(entity);
        var response = mapper.toResponse(saved);
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Ejecutor creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<EjecutorResponse> update(@PathVariable Long id,
                                                 @Valid @RequestBody EjecutorRequest request) {
        var entity = mapper.toEntity(request);
        var updated = service.update(id, entity);
        var response = mapper.toResponse(updated);
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Ejecutor actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<EjecutorResponse> activate(@PathVariable Long id) {
        var response = mapper.toResponse(service.activate(id));
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Ejecutor activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EjecutorResponse> deactivate(@PathVariable Long id) {
        var response = mapper.toResponse(service.deactivate(id));
        service.enrich(List.of(response));
        return ApiResponse.ok(response, "Ejecutor desactivado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Ejecutor eliminado");
    }
}
