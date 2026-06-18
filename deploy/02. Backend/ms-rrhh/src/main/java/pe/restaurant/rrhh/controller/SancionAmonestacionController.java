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
import pe.restaurant.rrhh.constants.SancionAmonestacionConstants;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionCreateRequest;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.SancionAmonestacionResponse;
import pe.restaurant.rrhh.service.SancionAmonestacionService;
import java.time.LocalDate;

@Tag(name = "Sanciones y Amonestaciones", description = "Gestión de sanciones disciplinarias")
@RestController
@RequestMapping("/api/rrhh/sanciones")
@RequiredArgsConstructor
public class SancionAmonestacionController {

    private final SancionAmonestacionService service;

    @Operation(summary = "Listar sanciones")
    @GetMapping
    public ApiResponse<PageData<SancionAmonestacionResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) Long tipoSancionId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fecha", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<SancionAmonestacionResponse> page = service.listar(trabajadorId, tipoSancionId, fechaDesde, fechaHasta, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener sanción por ID")
    @GetMapping("/{id}")
    public ApiResponse<SancionAmonestacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Registrar sanción")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<SancionAmonestacionResponse> crear(@Valid @RequestBody SancionAmonestacionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar sanción")
    @PutMapping("/{id}")
    public ApiResponse<SancionAmonestacionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody SancionAmonestacionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar sanción (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<SancionAmonestacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), SancionAmonestacionConstants.MSG_DESACTIVADO);
    }
}
