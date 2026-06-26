package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.SecuenciaDocumentoRequest;
import pe.restaurant.core.dto.SecuenciaDocumentoResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.SecuenciaDocumentoMapper;
import pe.restaurant.core.service.SecuenciaDocumentoService;

@RestController
@RequestMapping("/api/core/secuencias-documento")
@RequiredArgsConstructor
public class SecuenciaDocumentoController {

    private final SecuenciaDocumentoService service;
    private final SecuenciaDocumentoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<SecuenciaDocumentoResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<SecuenciaDocumentoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<SecuenciaDocumentoResponse> create(@Valid @RequestBody SecuenciaDocumentoRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<SecuenciaDocumentoResponse> update(@PathVariable Long id, @Valid @RequestBody SecuenciaDocumentoRequest request) {
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
