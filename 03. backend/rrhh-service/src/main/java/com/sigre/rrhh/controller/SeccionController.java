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
import com.sigre.rrhh.constants.SeccionConstants;
import com.sigre.rrhh.dto.request.SeccionCreateRequest;
import com.sigre.rrhh.dto.request.SeccionUpdateRequest;
import com.sigre.rrhh.dto.response.SeccionResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.SeccionService;
import java.util.List;

@Tag(name = "Seccion", description = "Catálogo seccion")
@RestController
@RequestMapping("/api/rrhh/secciones")
@RequiredArgsConstructor
public class SeccionController {
    private final SeccionService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<SeccionResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), SeccionConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<SeccionResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<SeccionResponse>> crear(@Valid @RequestBody SeccionCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), SeccionConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<SeccionResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody SeccionUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<SeccionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), SeccionConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<SeccionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), SeccionConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<SeccionResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
