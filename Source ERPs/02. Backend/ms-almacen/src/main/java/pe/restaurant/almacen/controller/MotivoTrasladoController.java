package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.MotivoTrasladoRequest;
import pe.restaurant.almacen.dto.MotivoTrasladoResponse;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.mapper.MotivoTrasladoMapper;
import pe.restaurant.almacen.service.MotivoTrasladoService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/maestros/motivos-traslado")
@RequiredArgsConstructor
public class MotivoTrasladoController {

    private final MotivoTrasladoService service;
    private final MotivoTrasladoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<MotivoTrasladoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<MotivoTrasladoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MotivoTrasladoResponse> create(@Valid @RequestBody MotivoTrasladoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<MotivoTrasladoResponse> update(@PathVariable Long id,
                                                      @Valid @RequestBody MotivoTrasladoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<MotivoTrasladoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<MotivoTrasladoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
