package com.sigre.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.core.dto.NumeradorDocumentoResponse;
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
}
