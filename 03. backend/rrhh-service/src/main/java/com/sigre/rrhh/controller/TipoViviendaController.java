package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.TipoViviendaConstants;
import com.sigre.rrhh.dto.request.TipoViviendaCreateRequest;
import com.sigre.rrhh.dto.request.TipoViviendaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoViviendaResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.TipoViviendaService;
import java.util.List;

@Tag(name = "TipoVivienda", description = "Catálogo tipo_vivienda")
@RestController
@RequestMapping("/api/rrhh/tipos-vivienda")
@RequiredArgsConstructor
public class TipoViviendaController {
    private final TipoViviendaService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoViviendaResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoViviendaConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoViviendaResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoViviendaResponse>> crear(@Valid @RequestBody TipoViviendaCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoViviendaConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoViviendaResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoViviendaUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoViviendaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoViviendaConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoViviendaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoViviendaConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoViviendaResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
