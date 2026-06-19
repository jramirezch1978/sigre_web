package com.sigre.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.NumeradorDocumentoResponse;
import com.sigre.core.dto.NumeradorDocumentoUpsertRequest;
import com.sigre.core.dto.PageData;
import com.sigre.core.service.NumeradorDocumentoService;

@RestController
@RequestMapping("/api/core/numeradores-documento")
@RequiredArgsConstructor
public class NumeradorDocumentoController {

    private final NumeradorDocumentoService service;

    /**
     * Correlativos por tabla destino ({@code core.numerador_documento}).
     * Filtrar por {@code nombreTabla} (ej. {@code almacen.vale_mov}, {@code almacen.orden_traslado}).
     */
    @GetMapping
    public ApiResponse<PageData<NumeradorDocumentoResponse>> listar(
            @RequestParam(required = false) String nombreTabla,
            Pageable pageable) {
        return ApiResponse.ok(service.listar(nombreTabla, pageable));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NumeradorDocumentoResponse> upsert(@Valid @RequestBody NumeradorDocumentoUpsertRequest request) {
        return ApiResponse.ok(service.upsert(request), "Numerador guardado");
    }

    @PutMapping
    public ApiResponse<NumeradorDocumentoResponse> actualizar(@Valid @RequestBody NumeradorDocumentoUpsertRequest request) {
        return ApiResponse.ok(service.upsert(request), "Numerador actualizado");
    }

    @PatchMapping("/desactivar")
    public ApiResponse<Boolean> desactivar(
            @RequestParam String nombreTabla,
            @RequestParam Long sucursalId,
            @RequestParam Integer ano) {
        service.desactivar(nombreTabla, sucursalId, ano);
        return ApiResponse.ok(true, "Numerador desactivado");
    }
}
