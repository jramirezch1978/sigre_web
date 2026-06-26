package pe.restaurant.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.produccion.dto.request.OtTipoRequest;
import pe.restaurant.produccion.dto.response.OtTipoResponse;
import pe.restaurant.produccion.dto.response.PageData;
import pe.restaurant.produccion.mapper.OtTipoMapper;
import pe.restaurant.produccion.service.OtTipoService;

@RestController
@RequestMapping("/api/produccion/ot-tipos")
@RequiredArgsConstructor
public class OtTipoController {

    private final OtTipoService service;
    private final OtTipoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<OtTipoResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<OtTipoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OtTipoResponse> create(@Valid @RequestBody OtTipoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Tipo de OT creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<OtTipoResponse> update(@PathVariable Long id,
                                              @Valid @RequestBody OtTipoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Tipo de OT actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<OtTipoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Tipo de OT activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<OtTipoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Tipo de OT desactivado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Tipo de OT eliminado");
    }
}
