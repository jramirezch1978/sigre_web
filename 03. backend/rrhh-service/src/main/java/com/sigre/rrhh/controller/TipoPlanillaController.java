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
import com.sigre.rrhh.constants.TipoPlanillaConstants;
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;
import com.sigre.rrhh.service.TipoPlanillaService;

import java.util.List;

@Tag(name = "TipoPlanillas", description = "Catálogo de tipo_planillas")
@RestController
@RequestMapping("/api/rrhh/tipos-planilla")
@RequiredArgsConstructor
public class TipoPlanillaController {

    private final TipoPlanillaService service;

    @Operation(summary = "Listar tipo_planillas")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoPlanillaResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), TipoPlanillaConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener tipo_planilla por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoPlanillaResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear tipo_planilla")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoPlanillaResponse>> crear(@Valid @RequestBody TipoPlanillaCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoPlanillaConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar tipo_planilla")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoPlanillaResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoPlanillaUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar tipo de planilla (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoPlanillaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoPlanillaConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar tipo de planilla")
    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoPlanillaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoPlanillaConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar tipos de planilla activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoPlanillaResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
