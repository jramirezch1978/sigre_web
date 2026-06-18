package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfOperacionesRequest;
import pe.restaurant.activos.dto.AfOperacionesResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfOperacionesMapper;
import pe.restaurant.activos.service.AfOperacionesService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/operaciones")
@RequiredArgsConstructor
public class AfOperacionesController {

    private final AfOperacionesService service;
    private final AfOperacionesMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfOperacionesResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfOperacionesResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfOperacionesResponse> crear(@Valid @RequestBody AfOperacionesRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfOperacionesResponse> actualizar(@PathVariable Long id,
                                                          @Valid @RequestBody AfOperacionesRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/programadas")
    public ApiResponse<List<AfOperacionesResponse>> listarProgramadas() {
        var operaciones = service.findProgramadas();
        return ApiResponse.ok(mapper.toResponseList(operaciones));
    }

    @PatchMapping("/{id}/ejecutar")
    public ApiResponse<AfOperacionesResponse> ejecutar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.ejecutar(id)), "Operación ejecutada");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfOperacionesResponse>> listarPorActivo(@PathVariable Long activoId) {
        var operaciones = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(operaciones));
    }
}
