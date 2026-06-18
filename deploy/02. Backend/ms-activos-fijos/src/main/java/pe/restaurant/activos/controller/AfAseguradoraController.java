package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfAseguradoraRequest;
import pe.restaurant.activos.dto.AfAseguradoraResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfAseguradoraMapper;
import pe.restaurant.activos.service.AfAseguradoraService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/aseguradoras")
@RequiredArgsConstructor
public class AfAseguradoraController {

    private final AfAseguradoraService service;
    private final AfAseguradoraMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfAseguradoraResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfAseguradoraResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfAseguradoraResponse> crear(@Valid @RequestBody AfAseguradoraRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfAseguradoraResponse> actualizar(@PathVariable Long id,
                                                    @Valid @RequestBody AfAseguradoraRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AfAseguradoraResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AfAseguradoraResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
