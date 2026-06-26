package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.dto.ServicioCatalogoRequest;
import pe.restaurant.compras.dto.ServicioCatalogoResponse;
import pe.restaurant.compras.mapper.ServicioCatalogoMapper;
import pe.restaurant.compras.service.ServicioCatalogoService;

@RestController
@RequestMapping("/api/compras/maestros/servicios-catalogo")
@RequiredArgsConstructor
public class ServicioCatalogoController {

    private final ServicioCatalogoService service;
    private final ServicioCatalogoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<ServicioCatalogoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ServicioCatalogoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ServicioCatalogoResponse> create(@Valid @RequestBody ServicioCatalogoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ServicioCatalogoResponse> update(@PathVariable Long id,
                                                        @Valid @RequestBody ServicioCatalogoRequest request) {
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
    public ApiResponse<ServicioCatalogoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ServicioCatalogoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
