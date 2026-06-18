package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfVentaRequest;
import pe.restaurant.activos.dto.AfVentaResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfVentaMapper;
import pe.restaurant.activos.service.AfVentaService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/ventas")
@RequiredArgsConstructor
public class AfVentaController {

    private final AfVentaService service;
    private final AfVentaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfVentaResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfVentaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfVentaResponse> crear(@Valid @RequestBody AfVentaRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfVentaResponse> actualizar(@PathVariable Long id,
                                                    @Valid @RequestBody AfVentaRequest request) {
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
    public ApiResponse<AfVentaResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.aprobar(id)), "Baja aprobada — activo dado de baja, depreciación bloqueada");
    }

    @PatchMapping("/{id}/anular")
    public ApiResponse<AfVentaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.anular(id)), "Baja anulada — activo restaurado");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfVentaResponse>> listarPorActivo(@PathVariable Long activoId) {
        var ventas = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(ventas));
    }

    @GetMapping("/reporte/{anio}")
    public ApiResponse<List<AfVentaResponse>> reportePorAnio(@PathVariable Integer anio) {
        var ventas = service.findByAnio(anio);
        return ApiResponse.ok(mapper.toResponseList(ventas));
    }
}
