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
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import pe.restaurant.rrhh.dto.response.ConceptoPlanillaResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.constants.ConceptoPlanillaConstants;
import pe.restaurant.rrhh.service.ConceptoPlanillaService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/conceptos-planilla")
@RequiredArgsConstructor
@Tag(name = "Conceptos de Planilla", description = "Gestión de conceptos de planilla")
public class ConceptoPlanillaController {

    private final ConceptoPlanillaService service;

    @GetMapping
    @Operation(summary = "Listar conceptos de planilla")
    public ApiResponse<PageData<ConceptoPlanillaResponse>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String grupoCalculo,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<ConceptoPlanillaResponse> page = service.listar(codigo, nombre, grupoCalculo, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener concepto por ID")
    public ApiResponse<ConceptoPlanillaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear concepto de planilla")
    public ApiResponse<ConceptoPlanillaResponse> crear(@Valid @RequestBody ConceptoPlanillaCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar concepto de planilla")
    public ApiResponse<ConceptoPlanillaResponse> actualizar(@PathVariable Long id, @Valid @RequestBody ConceptoPlanillaUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar concepto de planilla (baja lógica)")
    public ApiResponse<ConceptoPlanillaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), ConceptoPlanillaConstants.MSG_CONCEPTO_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar concepto de planilla")
    public ApiResponse<ConceptoPlanillaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), ConceptoPlanillaConstants.MSG_CONCEPTO_ACTIVADO);
    }

    @GetMapping("/activos")
    @Operation(summary = "Listar conceptos de planilla activos")
    public ApiResponse<List<ConceptoPlanillaResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
