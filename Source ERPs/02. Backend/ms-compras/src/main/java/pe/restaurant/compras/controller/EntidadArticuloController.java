package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.EntidadArticuloRequest;
import pe.restaurant.compras.dto.EntidadArticuloResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.mapper.EntidadArticuloMapper;
import pe.restaurant.compras.service.EntidadArticuloService;

@RestController
@RequestMapping("/api/compras/entidad-articulos")
@RequiredArgsConstructor
public class EntidadArticuloController {

    private final EntidadArticuloService service;
    private final EntidadArticuloMapper mapper;

    @GetMapping
    public ApiResponse<PageData<EntidadArticuloResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<EntidadArticuloResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadArticuloResponse> create(@Valid @RequestBody EntidadArticuloRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<EntidadArticuloResponse> update(@PathVariable Long id, @Valid @RequestBody EntidadArticuloRequest request) {
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
    public ApiResponse<EntidadArticuloResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EntidadArticuloResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
