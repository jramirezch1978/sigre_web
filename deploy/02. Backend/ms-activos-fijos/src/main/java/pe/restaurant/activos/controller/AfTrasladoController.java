package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfTrasladoRequest;
import pe.restaurant.activos.dto.AfTrasladoResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfTrasladoMapper;
import pe.restaurant.activos.service.AfTrasladoService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/traslados")
@RequiredArgsConstructor
public class AfTrasladoController {

    private final AfTrasladoService service;
    private final AfTrasladoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfTrasladoResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfTrasladoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfTrasladoResponse> crear(@Valid @RequestBody AfTrasladoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfTrasladoResponse> actualizar(@PathVariable Long id,
                                                       @Valid @RequestBody AfTrasladoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/aprobar")
    public ApiResponse<AfTrasladoResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.aprobar(id)), "Traslado aprobado");
    }

    @PatchMapping("/{id}/rechazar")
    public ApiResponse<AfTrasladoResponse> rechazar(@PathVariable Long id,
                                                     @RequestParam(required = false) String comentario) {
        return ApiResponse.ok(mapper.toResponse(service.rechazar(id, comentario)), "Traslado rechazado");
    }

    @PatchMapping("/{id}/ejecutar")
    public ApiResponse<AfTrasladoResponse> ejecutar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.ejecutar(id)), "Traslado ejecutado");
    }

    @PatchMapping("/{id}/anular")
    public ApiResponse<AfTrasladoResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.anular(id)), "Traslado anulado");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfTrasladoResponse>> listarPorActivo(@PathVariable Long activoId) {
        var traslados = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(traslados));
    }

}
