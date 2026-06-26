package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.MotivoNotaRequest;
import pe.restaurant.core.dto.MotivoNotaResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.MotivoNotaMapper;
import pe.restaurant.core.service.MotivoNotaService;

@RestController
@RequestMapping("/api/core/motivos-nota")
@RequiredArgsConstructor
public class MotivoNotaController {

    private final MotivoNotaService service;
    private final MotivoNotaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<MotivoNotaResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<MotivoNotaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MotivoNotaResponse> create(@Valid @RequestBody MotivoNotaRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<MotivoNotaResponse> update(@PathVariable Long id, @Valid @RequestBody MotivoNotaRequest request) {
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
    public ApiResponse<MotivoNotaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<MotivoNotaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
