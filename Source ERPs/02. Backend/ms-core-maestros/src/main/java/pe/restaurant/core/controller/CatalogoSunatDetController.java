package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.CatalogoSunatDetRequest;
import pe.restaurant.core.dto.CatalogoSunatDetResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.CatalogoSunatDetMapper;
import pe.restaurant.core.service.CatalogoSunatDetService;

@RestController
@RequestMapping("/api/core/catalogos-sunat/detalles")
@RequiredArgsConstructor
public class CatalogoSunatDetController {

    private final CatalogoSunatDetService service;
    private final CatalogoSunatDetMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CatalogoSunatDetResponse>> findAll(
            @RequestParam(required = false) Long catalogoSunatId,
            @RequestParam(required = false) String codigoItem,
            @RequestParam(required = false) String nombreItem,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(catalogoSunatId, codigoItem, nombreItem, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CatalogoSunatDetResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/catalogo/{catalogoSunatId}/activos")
    public ApiResponse<java.util.List<CatalogoSunatDetResponse>> findActivosByCatalogoId(@PathVariable Long catalogoSunatId) {
        var list = service.findActivosByCatalogoId(catalogoSunatId);
        return ApiResponse.ok(mapper.toResponseList(list));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CatalogoSunatDetResponse> create(@Valid @RequestBody CatalogoSunatDetRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Detalle SUNAT creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CatalogoSunatDetResponse> update(@PathVariable Long id,
                                                        @Valid @RequestBody CatalogoSunatDetRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Detalle SUNAT actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CatalogoSunatDetResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Detalle SUNAT activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CatalogoSunatDetResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Detalle SUNAT desactivado");
    }
}
