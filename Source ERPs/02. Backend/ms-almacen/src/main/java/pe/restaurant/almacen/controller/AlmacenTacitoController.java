package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.AlmacenTacitoRequest;
import pe.restaurant.almacen.dto.AlmacenTacitoResponse;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.mapper.AlmacenTacitoMapper;
import pe.restaurant.almacen.service.AlmacenTacitoService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/maestros/almacen-tacito")
@RequiredArgsConstructor
public class AlmacenTacitoController {

    private final AlmacenTacitoService service;
    private final AlmacenTacitoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AlmacenTacitoResponse>> buscar(
            @RequestParam(required = false) String codClase,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long almacenId,
            Pageable pageable) {
        var page = service.buscar(codClase, sucursalId, almacenId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AlmacenTacitoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AlmacenTacitoResponse> create(@Valid @RequestBody AlmacenTacitoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AlmacenTacitoResponse> update(@PathVariable Long id,
                                                     @Valid @RequestBody AlmacenTacitoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AlmacenTacitoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AlmacenTacitoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
