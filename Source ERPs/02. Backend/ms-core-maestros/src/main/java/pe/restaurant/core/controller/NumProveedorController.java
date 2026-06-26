package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.NumProveedorRequest;
import pe.restaurant.core.dto.NumProveedorResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.NumProveedorMapper;
import pe.restaurant.core.service.NumProveedorService;

@RestController
@RequestMapping("/api/core/num-proveedores")
@RequiredArgsConstructor
public class NumProveedorController {

    private final NumProveedorService service;
    private final NumProveedorMapper mapper;

    @GetMapping
    public ApiResponse<PageData<NumProveedorResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<NumProveedorResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NumProveedorResponse> create(@Valid @RequestBody NumProveedorRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<NumProveedorResponse> update(@PathVariable Long id, @Valid @RequestBody NumProveedorRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
