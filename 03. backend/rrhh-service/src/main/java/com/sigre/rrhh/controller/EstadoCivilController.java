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
import com.sigre.rrhh.constants.EstadoCivilConstants;
import com.sigre.rrhh.dto.request.EstadoCivilCreateRequest;
import com.sigre.rrhh.dto.request.EstadoCivilUpdateRequest;
import com.sigre.rrhh.dto.response.EstadoCivilResponse;
import com.sigre.rrhh.service.EstadoCivilService;

import java.util.List;

@Tag(name = "EstadoCivils", description = "Catálogo de estado_civils")
@RestController
@RequestMapping("/api/rrhh/estados-civiles")
@RequiredArgsConstructor
public class EstadoCivilController {

    private final EstadoCivilService service;

    @Operation(summary = "Listar estado_civils")
    @GetMapping
    public ResponseEntity<ApiResponse<PageData<EstadoCivilResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var _page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(_page, _page.getContent()), EstadoCivilConstants.MSG_OBTENIDOS));
    }

    @Operation(summary = "Obtener estado_civil por ID")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<EstadoCivilResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @Operation(summary = "Crear estado_civil")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<EstadoCivilResponse>> crear(@Valid @RequestBody EstadoCivilCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), EstadoCivilConstants.MSG_CREADO));
    }

    @Operation(summary = "Actualizar estado_civil")
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<EstadoCivilResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody EstadoCivilUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @Operation(summary = "Desactivar estado civil (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<EstadoCivilResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), EstadoCivilConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Activar estado civil")
    @PatchMapping("/{id}/activar")
    public ApiResponse<EstadoCivilResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), EstadoCivilConstants.MSG_ACTIVADO);
    }

    @Operation(summary = "Listar estados civiles activos")
    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<EstadoCivilResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
