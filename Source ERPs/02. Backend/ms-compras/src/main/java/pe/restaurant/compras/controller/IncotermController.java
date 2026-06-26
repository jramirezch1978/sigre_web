package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.IncotermRequest;
import pe.restaurant.compras.dto.IncotermResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.mapper.IncotermMapper;
import pe.restaurant.compras.service.IncotermService;

@RestController
@RequestMapping("/api/compras/incoterms")
@RequiredArgsConstructor
public class IncotermController {

    private final IncotermService service;
    private final IncotermMapper mapper;

    @GetMapping
    public ApiResponse<PageData<IncotermResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<IncotermResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<IncotermResponse> create(@Valid @RequestBody IncotermRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<IncotermResponse> update(@PathVariable Long id, @Valid @RequestBody IncotermRequest request) {
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
    public ApiResponse<IncotermResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<IncotermResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
