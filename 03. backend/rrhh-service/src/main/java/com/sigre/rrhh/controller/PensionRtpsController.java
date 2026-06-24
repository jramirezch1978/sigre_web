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
import com.sigre.rrhh.constants.PensionRtpsConstants;
import com.sigre.rrhh.dto.request.PensionRtpsCreateRequest;
import com.sigre.rrhh.dto.request.PensionRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.PensionRtpsResponse;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.service.PensionRtpsService;
import java.util.List;

@Tag(name = "PensionRtps", description = "Catálogo pension_rtps")
@RestController
@RequestMapping("/api/rrhh/pensiones-rtps")
@RequiredArgsConstructor
public class PensionRtpsController {
    private final PensionRtpsService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<PensionRtpsResponse>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), PensionRtpsConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PensionRtpsResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<PensionRtpsResponse>> crear(@Valid @RequestBody PensionRtpsCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), PensionRtpsConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<PensionRtpsResponse>> actualizar(@PathVariable Long id, @Valid @RequestBody PensionRtpsUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<PensionRtpsResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), PensionRtpsConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<PensionRtpsResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), PensionRtpsConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<PensionRtpsResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
