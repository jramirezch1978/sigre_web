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
import com.sigre.rrhh.constants.TipoTrabajadorConstants;
import com.sigre.rrhh.dto.request.TipoTrabajadorCreateRequest;
import com.sigre.rrhh.dto.request.TipoTrabajadorUpdateRequest;
import com.sigre.rrhh.dto.response.TipoTrabajadorResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.TipoTrabajadorService;
import java.util.List;

@Tag(name = "TipoTrabajador", description = "Catálogo tipo_trabajador")
@RestController
@RequestMapping("/api/rrhh/tipos-trabajador")
@RequiredArgsConstructor
public class TipoTrabajadorController {
    private final TipoTrabajadorService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<TipoTrabajadorResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), TipoTrabajadorConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoTrabajadorResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<TipoTrabajadorResponse>> crear(@Valid @RequestBody TipoTrabajadorCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), TipoTrabajadorConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TipoTrabajadorResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody TipoTrabajadorUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<TipoTrabajadorResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), TipoTrabajadorConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<TipoTrabajadorResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), TipoTrabajadorConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<TipoTrabajadorResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
