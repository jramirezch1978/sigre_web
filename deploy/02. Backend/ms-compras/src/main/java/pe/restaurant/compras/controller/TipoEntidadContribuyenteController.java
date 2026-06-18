package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteRequest;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.mapper.TipoEntidadContribuyenteMapper;
import pe.restaurant.compras.service.TipoEntidadContribuyenteService;

@RestController
@RequestMapping("/api/compras/maestros/tipos-entidad-contribuyente")
@RequiredArgsConstructor
public class TipoEntidadContribuyenteController {

    private final TipoEntidadContribuyenteService service;
    private final TipoEntidadContribuyenteMapper mapper;

    @GetMapping
    public ApiResponse<PageData<TipoEntidadContribuyenteResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<TipoEntidadContribuyenteResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoEntidadContribuyenteResponse> create(
            @Valid @RequestBody TipoEntidadContribuyenteRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<TipoEntidadContribuyenteResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody TipoEntidadContribuyenteRequest request) {
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
    public ApiResponse<TipoEntidadContribuyenteResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoEntidadContribuyenteResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
