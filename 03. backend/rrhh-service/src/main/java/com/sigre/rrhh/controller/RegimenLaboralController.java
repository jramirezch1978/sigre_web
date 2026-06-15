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
import com.sigre.rrhh.constants.RegimenLaboralConstants;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;
import com.sigre.rrhh.service.RegimenLaboralService;

import java.util.List;

@Tag(name = "RegimenLaborals", description = "Catálogo de regimen_laborals")
@RestController
@RequestMapping("/api/rrhh/regimenes-laborales")
@RequiredArgsConstructor
public class RegimenLaboralController {

    private final RegimenLaboralService service;

    @Operation(summary = "Listar regimen_laborals")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<RegimenLaboralResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), RegimenLaboralConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener regimen_laboral por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RegimenLaboralResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear regimen_laboral")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<RegimenLaboralResponse>> crear(@Valid @RequestBody RegimenLaboralCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), RegimenLaboralConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar regimen_laboral")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RegimenLaboralResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody RegimenLaboralUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar régimen laboral (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<RegimenLaboralResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), RegimenLaboralConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar régimen laboral")
    @PatchMapping("/{id}/activar")
    public ApiResponse<RegimenLaboralResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), RegimenLaboralConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar regímenes laborales activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<RegimenLaboralResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
