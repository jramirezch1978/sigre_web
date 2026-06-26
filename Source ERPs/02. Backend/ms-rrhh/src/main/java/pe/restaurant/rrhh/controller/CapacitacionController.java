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
import pe.restaurant.rrhh.constants.CapacitacionConstants;
import pe.restaurant.rrhh.dto.request.CapacitacionCreateRequest;
import pe.restaurant.rrhh.dto.request.CapacitacionUpdateRequest;
import pe.restaurant.rrhh.dto.request.CapacitacionTrabajadorRequest;
import pe.restaurant.rrhh.dto.response.CapacitacionResponse;
import pe.restaurant.rrhh.dto.response.CapacitacionTrabajadorResponse;
import pe.restaurant.rrhh.service.CapacitacionService;
import java.util.List;

@Tag(name = "Capacitaciones", description = "Gestión de capacitaciones y participantes")
@RestController
@RequestMapping("/api/rrhh/capacitaciones")
@RequiredArgsConstructor
public class CapacitacionController {

    private final CapacitacionService service;

    @Operation(summary = "Listar capacitaciones")
    @GetMapping
    public ApiResponse<PageData<CapacitacionResponse>> listar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaInicio", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<CapacitacionResponse> page = service.listar(nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener capacitación por ID")
    @GetMapping("/{id}")
    public ApiResponse<CapacitacionResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear capacitación")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CapacitacionResponse> crear(@Valid @RequestBody CapacitacionCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar capacitación")
    @PutMapping("/{id}")
    public ApiResponse<CapacitacionResponse> actualizar(@PathVariable Long id, @Valid @RequestBody CapacitacionUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar capacitación (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CapacitacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), CapacitacionConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Listar participantes de una capacitación")
    @GetMapping("/{id}/participantes")
    public ApiResponse<List<CapacitacionTrabajadorResponse>> listarParticipantes(@PathVariable Long id) {
        return ApiResponse.ok(service.listarParticipantes(id));
    }

    @Operation(summary = "Agregar participante a capacitación")
    @PostMapping("/{id}/participantes")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CapacitacionTrabajadorResponse> agregarParticipante(
            @PathVariable Long id, @Valid @RequestBody CapacitacionTrabajadorRequest request) {
        return ApiResponse.ok(service.agregarParticipante(id, request));
    }

    @Operation(summary = "Actualizar participante de capacitación")
    @PutMapping("/{id}/participantes/{trabajadorId}")
    public ApiResponse<CapacitacionTrabajadorResponse> actualizarParticipante(
            @PathVariable Long id, @PathVariable Long trabajadorId,
            @Valid @RequestBody CapacitacionTrabajadorRequest request) {
        return ApiResponse.ok(service.actualizarParticipante(id, trabajadorId, request));
    }

    @Operation(summary = "Quitar participante de capacitación")
    @DeleteMapping("/{id}/participantes/{trabajadorId}")
    public ApiResponse<Boolean> quitarParticipante(@PathVariable Long id, @PathVariable Long trabajadorId) {
        service.eliminarParticipante(id, trabajadorId);
        return ApiResponse.ok(true, "Participante quitado correctamente");
    }
}
