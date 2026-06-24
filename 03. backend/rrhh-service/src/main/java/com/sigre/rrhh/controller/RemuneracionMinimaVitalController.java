package com.sigre.rrhh.controller;

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
import com.sigre.rrhh.constants.RemuneracionMinimaVitalConstants;
import com.sigre.rrhh.dto.request.RemuneracionMinimaVitalCreateRequest;
import com.sigre.rrhh.dto.request.RemuneracionMinimaVitalUpdateRequest;
import com.sigre.rrhh.dto.response.PageData;
import com.sigre.rrhh.dto.response.RemuneracionMinimaVitalResponse;
import com.sigre.rrhh.service.RemuneracionMinimaVitalService;

import java.util.List;

@Tag(name = "RemuneracionMinimaVital", description = "RMV por tipo de trabajador (SIGRE RMV_X_TIPO_TRABAJ)")
@RestController
@RequestMapping("/api/rrhh/remuneraciones-minimas-vitales")
@RequiredArgsConstructor
public class RemuneracionMinimaVitalController {

    private final RemuneracionMinimaVitalService service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<RemuneracionMinimaVitalResponse>>> listar(
            @RequestParam(required = false) Long tipoTrabajadorId,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaDesde", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<RemuneracionMinimaVitalResponse> page = service.listar(tipoTrabajadorId, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), RemuneracionMinimaVitalConstants.MSG_OBTENIDOS));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RemuneracionMinimaVitalResponse>> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<RemuneracionMinimaVitalResponse>> crear(
            @Valid @RequestBody RemuneracionMinimaVitalCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(service.crear(request), RemuneracionMinimaVitalConstants.MSG_CREADO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RemuneracionMinimaVitalResponse>> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody RemuneracionMinimaVitalUpdateRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<RemuneracionMinimaVitalResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), RemuneracionMinimaVitalConstants.MSG_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<RemuneracionMinimaVitalResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), RemuneracionMinimaVitalConstants.MSG_ACTIVADO);
    }

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<RemuneracionMinimaVitalResponse>>> listarActivos() {
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }
}
