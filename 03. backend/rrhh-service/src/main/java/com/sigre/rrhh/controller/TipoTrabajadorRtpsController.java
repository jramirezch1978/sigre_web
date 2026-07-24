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
import com.sigre.rrhh.constants.TipoTrabajadorRtpsConstants;
import com.sigre.rrhh.dto.request.TipoTrabajadorRtpsCreateRequest;
import com.sigre.rrhh.dto.request.TipoTrabajadorRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.TipoTrabajadorRtpsResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.TipoTrabajadorRtpsService;
import java.util.List;

@Tag(name = "TipoTrabajadorRtps", description = "Catálogo tipo_trabajador_rtps")
@RestController
@RequestMapping("/api/rrhh/tipos-trabajador-rtps")
@RequiredArgsConstructor
public class TipoTrabajadorRtpsController {
    private final TipoTrabajadorRtpsService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoTrabajadorRtpsResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoTrabajadorRtpsConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoTrabajadorRtpsResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoTrabajadorRtpsResponse>> crear(@Valid @RequestBody TipoTrabajadorRtpsCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoTrabajadorRtpsConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoTrabajadorRtpsResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoTrabajadorRtpsUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoTrabajadorRtpsResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoTrabajadorRtpsConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoTrabajadorRtpsResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoTrabajadorRtpsConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoTrabajadorRtpsResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
