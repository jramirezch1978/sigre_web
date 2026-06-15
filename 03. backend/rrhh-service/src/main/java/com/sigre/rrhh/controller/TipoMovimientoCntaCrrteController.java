package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.TipoMovimientoCntaCrrteConstants;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;
import com.sigre.rrhh.service.TipoMovimientoCntaCrrteService;

import java.util.List;

@Tag(name = "TipoMovimientoCntaCrrtes", description = "Catálogo de tipo_movimiento_cnta_crrtes")
@RestController
@RequestMapping("/api/rrhh/tipos-movimiento-cnta-crrte")
@RequiredArgsConstructor
public class TipoMovimientoCntaCrrteController {

    private final TipoMovimientoCntaCrrteService service;

    @Operation(summary = "Listar tipo_movimiento_cnta_crrtes")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoMovimientoCntaCrrteResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), TipoMovimientoCntaCrrteConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener tipo_movimiento_cnta_crrte por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoMovimientoCntaCrrteResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear tipo_movimiento_cnta_crrte")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoMovimientoCntaCrrteResponse>> crear(@Valid @RequestBody TipoMovimientoCntaCrrteCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoMovimientoCntaCrrteConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar tipo_movimiento_cnta_crrte")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoMovimientoCntaCrrteResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoMovimientoCntaCrrteUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar tipo de movimiento de cuenta corriente (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoMovimientoCntaCrrteResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoMovimientoCntaCrrteConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de movimiento de cuenta corriente")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoMovimientoCntaCrrteResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoMovimientoCntaCrrteConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de movimiento de cuenta corriente activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoMovimientoCntaCrrteResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
