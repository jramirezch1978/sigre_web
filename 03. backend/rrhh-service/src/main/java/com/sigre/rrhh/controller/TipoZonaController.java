package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.TipoZonaConstants;
import com.sigre.rrhh.dto.request.TipoZonaCreateRequest;
import com.sigre.rrhh.dto.request.TipoZonaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoZonaResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.TipoZonaService;
import java.util.List;

@Tag(name = "TipoZona", description = "Catálogo tipo_zona")
@RestController
@RequestMapping("/api/rrhh/tipos-zona")
@RequiredArgsConstructor
public class TipoZonaController {
    private final TipoZonaService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoZonaResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoZonaConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoZonaResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoZonaResponse>> crear(@Valid @RequestBody TipoZonaCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoZonaConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoZonaResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoZonaUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoZonaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoZonaConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoZonaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoZonaConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoZonaResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
