package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfHistorialRequest;
import pe.restaurant.activos.dto.AfHistorialResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfHistorialMapper;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/activos/historial")
@RequiredArgsConstructor
public class AfHistorialController {

    private final AfHistorialService service;
    private final AfHistorialMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfHistorialResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfHistorialResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfHistorialResponse> crear(@Valid @RequestBody AfHistorialRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfHistorialResponse>> listarPorActivo(@PathVariable Long activoId) {
        var historial = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(historial));
    }

    @GetMapping("/tipo/{tipoEvento}")
    public ApiResponse<List<AfHistorialResponse>> listarPorTipo(@PathVariable String tipoEvento) {
        var historial = service.findByTipoEvento(tipoEvento);
        return ApiResponse.ok(mapper.toResponseList(historial));
    }

    @GetMapping("/usuario/{usuarioId}")
    public ApiResponse<List<AfHistorialResponse>> listarPorUsuario(@PathVariable Long usuarioId) {
        var historial = service.findByUsuario(usuarioId);
        return ApiResponse.ok(mapper.toResponseList(historial));
    }

    @GetMapping("/rango-fechas")
    public ApiResponse<List<AfHistorialResponse>> listarPorRangoFechas(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fechaFin) {
        var historial = service.findByFechaRange(fechaInicio, fechaFin);
        return ApiResponse.ok(mapper.toResponseList(historial));
    }
}
