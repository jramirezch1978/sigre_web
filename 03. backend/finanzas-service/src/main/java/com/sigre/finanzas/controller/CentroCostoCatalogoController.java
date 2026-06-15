package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.service.CentroCostoCatalogoService;

import java.util.List;
import java.util.Map;

/**
 * Catálogo de centros de costo activos.
 *
 * Ruta consumida por el front (CxP, Notas, OC) para reemplazar el valor fijo
 * centrosCostoId = 1. Devuelve [{ id, nombre }] dentro de ApiResponse.data.
 */
@RestController
@RequestMapping("/api/finanzas/centros-costo")
@RequiredArgsConstructor
@Tag(name = "Centros de Costo", description = "Catálogo de centros de costo activos")
public class CentroCostoCatalogoController {

    private final CentroCostoCatalogoService service;

    @GetMapping
    @Operation(summary = "Listar centros de costo activos")
    public ApiResponse<List<Map<String, Object>>> listar() {
        return ApiResponse.ok(service.listarActivos());
    }
}
