package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.ContratoRequest;
import pe.restaurant.rrhh.dto.request.HorarioRequest;
import pe.restaurant.rrhh.dto.request.TrabajadorCeseRequest;
import pe.restaurant.rrhh.dto.request.TrabajadorRequest;
import pe.restaurant.rrhh.dto.response.*;
import pe.restaurant.rrhh.service.TrabajadorService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/trabajadores")
@RequiredArgsConstructor
@Tag(name = "Trabajadores", description = "Gestión de trabajadores, contratos y horarios")
public class TrabajadorController {

    private final TrabajadorService service;

    @GetMapping
    @Operation(summary = "Listar trabajadores")
    public ApiResponse<PageData<TrabajadorListResponse>> listar(
            Pageable pageable,
            @RequestParam(required = false) String codigoTrabajador,
            @RequestParam(required = false) String nombres,
            @RequestParam(required = false) String apellidoPaterno,
            @RequestParam(required = false) String numeroDocumento,
            @RequestParam(required = false) Long areaId,
            @RequestParam(required = false) Long cargoId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String flagEstado) {
        Page<TrabajadorListResponse> page = service.listar(
                codigoTrabajador, nombres, apellidoPaterno, numeroDocumento,
                areaId, cargoId, sucursalId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle del trabajador")
    public ApiResponse<TrabajadorDetailResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear trabajador")
    public ApiResponse<TrabajadorDetailResponse> crear(@Valid @RequestBody TrabajadorRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar trabajador")
    public ApiResponse<TrabajadorDetailResponse> actualizar(@PathVariable Long id, @Valid @RequestBody TrabajadorRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar trabajador")
    public ApiResponse<TrabajadorDetailResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar trabajador")
    public ApiResponse<TrabajadorDetailResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id));
    }

    @PostMapping("/{id}/cesar")
    @Operation(summary = "Cesar trabajador")
    public ApiResponse<TrabajadorDetailResponse> cesar(@PathVariable Long id, @Valid @RequestBody TrabajadorCeseRequest request) {
        return ApiResponse.ok(service.cesar(id, request.getFechaCese(), request.getMotivoCese()));
    }

    @GetMapping("/{trabajadorId}/contratos")
    @Operation(summary = "Listar contratos del trabajador")
    public ApiResponse<List<ContratoResponse>> listarContratos(
            @PathVariable Long trabajadorId, @RequestParam(required = false) String flagEstado) {
        return ApiResponse.ok(service.listarContratos(trabajadorId, flagEstado));
    }

    @GetMapping("/{trabajadorId}/contratos/{id}")
    @Operation(summary = "Detalle de un contrato")
    public ApiResponse<ContratoResponse> obtenerContrato(@PathVariable Long trabajadorId, @PathVariable Long id) {
        return ApiResponse.ok(service.obtenerContrato(trabajadorId, id));
    }

    @PostMapping("/{trabajadorId}/contratos")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear contrato")
    public ApiResponse<ContratoResponse> crearContrato(@PathVariable Long trabajadorId, @Valid @RequestBody ContratoRequest request) {
        return ApiResponse.ok(service.crearContrato(trabajadorId, request));
    }

    @PutMapping("/{trabajadorId}/contratos/{id}")
    @Operation(summary = "Actualizar contrato")
    public ApiResponse<ContratoResponse> actualizarContrato(@PathVariable Long trabajadorId, @PathVariable Long id, @Valid @RequestBody ContratoRequest request) {
        return ApiResponse.ok(service.actualizarContrato(trabajadorId, id, request));
    }

    @PatchMapping("/{trabajadorId}/contratos/{id}/desactivar")
    @Operation(summary = "Finalizar contrato")
    public ApiResponse<ContratoResponse> desactivarContrato(@PathVariable Long trabajadorId, @PathVariable Long id) {
        return ApiResponse.ok(service.desactivarContrato(trabajadorId, id));
    }

    @GetMapping("/{trabajadorId}/horarios")
    @Operation(summary = "Listar horarios del trabajador")
    public ApiResponse<List<HorarioResponse>> listarHorarios(
            @PathVariable Long trabajadorId, @RequestParam(required = false) String flagEstado) {
        return ApiResponse.ok(service.listarHorarios(trabajadorId, flagEstado));
    }

    @GetMapping("/{trabajadorId}/horarios/{id}")
    @Operation(summary = "Detalle de un horario")
    public ApiResponse<HorarioResponse> obtenerHorario(@PathVariable Long trabajadorId, @PathVariable Long id) {
        return ApiResponse.ok(service.obtenerHorario(trabajadorId, id));
    }

    @PostMapping("/{trabajadorId}/horarios")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Asignar horario")
    public ApiResponse<HorarioResponse> crearHorario(@PathVariable Long trabajadorId, @Valid @RequestBody HorarioRequest request) {
        return ApiResponse.ok(service.crearHorario(trabajadorId, request));
    }

    @PutMapping("/{trabajadorId}/horarios/{id}")
    @Operation(summary = "Actualizar horario")
    public ApiResponse<HorarioResponse> actualizarHorario(@PathVariable Long trabajadorId, @PathVariable Long id, @Valid @RequestBody HorarioRequest request) {
        return ApiResponse.ok(service.actualizarHorario(trabajadorId, id, request));
    }

    @PatchMapping("/{trabajadorId}/horarios/{id}/desactivar")
    @Operation(summary = "Finalizar horario")
    public ApiResponse<HorarioResponse> desactivarHorario(@PathVariable Long trabajadorId, @PathVariable Long id) {
        return ApiResponse.ok(service.desactivarHorario(trabajadorId, id));
    }
}
