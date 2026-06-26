package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfPolizaActivoRequest;
import pe.restaurant.activos.dto.AfPolizaActivoResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfPolizaActivoMapper;
import pe.restaurant.activos.service.AfPolizaActivoService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/polizas-activos")
@RequiredArgsConstructor
public class AfPolizaActivoController {

    private final AfPolizaActivoService service;
    private final AfPolizaActivoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfPolizaActivoResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfPolizaActivoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfPolizaActivoResponse> crear(@Valid @RequestBody AfPolizaActivoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfPolizaActivoResponse> actualizar(@PathVariable Long id,
                                                           @Valid @RequestBody AfPolizaActivoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/poliza/{polizaId}")
    public ApiResponse<List<AfPolizaActivoResponse>> listarPorPoliza(@PathVariable Long polizaId) {
        var activos = service.findByPoliza(polizaId);
        return ApiResponse.ok(mapper.toResponseList(activos));
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfPolizaActivoResponse>> listarPorActivo(@PathVariable Long activoId) {
        var polizas = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(polizas));
    }
}
