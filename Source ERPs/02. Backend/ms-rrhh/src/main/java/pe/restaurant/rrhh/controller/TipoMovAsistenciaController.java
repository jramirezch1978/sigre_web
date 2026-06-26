package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import pe.restaurant.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovAsistenciaResponse;
import pe.restaurant.rrhh.constants.TipoMovAsistenciaConstants;
import pe.restaurant.rrhh.service.TipoMovAsistenciaService;

@Tag(name = "Tipos de Mov. Asistencia", description = "Catálogo de tipos de movimiento de asistencia")
@RestController
@RequestMapping("/api/rrhh/tipos-mov-asistencia")
@RequiredArgsConstructor
public class TipoMovAsistenciaController {

    private final TipoMovAsistenciaService service;

    @Operation(summary = "Listar tipos de movimiento de asistencia")
    @GetMapping
    public ApiResponse<PageData<TipoMovAsistenciaResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        Page<TipoMovAsistenciaResponse> page = service.listar(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener tipo de movimiento de asistencia por ID")
    @GetMapping("/{id}")
    public ApiResponse<TipoMovAsistenciaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear tipo de movimiento de asistencia")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<TipoMovAsistenciaResponse> crear(@Valid @RequestBody TipoMovAsistenciaCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar tipo de movimiento de asistencia")
    @PutMapping("/{id}")
    public ApiResponse<TipoMovAsistenciaResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TipoMovAsistenciaUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar tipo de movimiento de asistencia (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoMovAsistenciaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoMovAsistenciaConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de movimiento de asistencia")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoMovAsistenciaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoMovAsistenciaConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de movimiento de asistencia activos")
    @GetMapping("/activos")
    public ApiResponse<java.util.List<TipoMovAsistenciaResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
