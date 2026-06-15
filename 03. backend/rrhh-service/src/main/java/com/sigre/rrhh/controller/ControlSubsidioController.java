package com.sigre.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import com.sigre.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.rrhh.constants.ControlSubsidioConstants;
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;
import com.sigre.rrhh.service.ControlSubsidioService;

@Tag(name = "Control de Subsidios", description = "Gestión de subsidios laborales")
@RestController
@RequestMapping("/api/rrhh/subsidios")
@RequiredArgsConstructor
public class ControlSubsidioController {

    private final ControlSubsidioService service;

    @Operation(summary = "Listar controles de subsidio")
    @GetMapping
    public ApiResponse<PageData<ControlSubsidioResponse>> listar(Pageable pageable) {
        Page<ControlSubsidioResponse> page = service.listar(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @Operation(summary = "Obtener control de subsidio por ID")
    @GetMapping("/{id}")
    public ApiResponse<ControlSubsidioResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Crear control de subsidio")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ControlSubsidioResponse> crear(@Valid @RequestBody ControlSubsidioCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar control de subsidio")
    @PutMapping("/{id}")
    public ApiResponse<ControlSubsidioResponse> actualizar(@PathVariable Long id, @Valid @RequestBody ControlSubsidioUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Desactivar control de subsidio (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ControlSubsidioResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), ControlSubsidioConstants.MSG_DESACTIVADO);
    }
}
