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
import com.sigre.rrhh.constants.OcupacionRtpsConstants;
import com.sigre.rrhh.dto.request.OcupacionRtpsCreateRequest;
import com.sigre.rrhh.dto.request.OcupacionRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.OcupacionRtpsResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.OcupacionRtpsService;
import java.util.List;

@Tag(name = "OcupacionRtps", description = "Catálogo ocupacion_rtps")
@RestController
@RequestMapping("/api/rrhh/ocupaciones-rtps")
@RequiredArgsConstructor
public class OcupacionRtpsController {
    private final OcupacionRtpsService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<OcupacionRtpsResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), OcupacionRtpsConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<OcupacionRtpsResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<OcupacionRtpsResponse>> crear(@Valid @RequestBody OcupacionRtpsCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), OcupacionRtpsConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<OcupacionRtpsResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody OcupacionRtpsUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<OcupacionRtpsResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), OcupacionRtpsConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<OcupacionRtpsResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), OcupacionRtpsConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<OcupacionRtpsResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
