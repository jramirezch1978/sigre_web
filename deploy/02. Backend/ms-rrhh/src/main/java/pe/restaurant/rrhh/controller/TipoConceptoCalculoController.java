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
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.constants.TipoConceptoCalculoConstants;
import pe.restaurant.rrhh.dto.request.TipoConceptoCalculoCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoConceptoCalculoUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoConceptoCalculoResponse;
import pe.restaurant.rrhh.service.TipoConceptoCalculoService;

import java.util.List;

@Tag(name = "TipoConceptoCalculos", description = "Catálogo de tipo_concepto_calculos")
@RestController
@RequestMapping("/api/rrhh/tipos-concepto-calculo")
@RequiredArgsConstructor
public class TipoConceptoCalculoController {

    private final TipoConceptoCalculoService service;

    @Operation(summary = "Listar tipo_concepto_calculos")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoConceptoCalculoResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), TipoConceptoCalculoConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener tipo_concepto_calculo por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoConceptoCalculoResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear tipo_concepto_calculo")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoConceptoCalculoResponse>> crear(@Valid @RequestBody TipoConceptoCalculoCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoConceptoCalculoConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar tipo_concepto_calculo")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoConceptoCalculoResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoConceptoCalculoUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar tipo de concepto de cálculo (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoConceptoCalculoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoConceptoCalculoConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de concepto de cálculo")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoConceptoCalculoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoConceptoCalculoConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de concepto de cálculo activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoConceptoCalculoResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
