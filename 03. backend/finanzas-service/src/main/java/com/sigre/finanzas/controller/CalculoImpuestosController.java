package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.request.CalcularImpuestosRequest;
import com.sigre.finanzas.dto.response.CalcularImpuestosResponse;
import com.sigre.finanzas.service.CalculoImpuestosService;

@Slf4j
@RestController
@RequestMapping("/api/finanzas")
@RequiredArgsConstructor
@Tag(name = "Cálculo de Impuestos", description = "Endpoint para calcular impuestos de CXP/CXC sin persistir")
public class CalculoImpuestosController {

    private final CalculoImpuestosService service;

    @PostMapping("/calcular-impuestos")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "Calcular impuestos",
               description = "Calcula el desglose de impuestos para ítems de CXP/CXC. No persiste nada. El país se determina desde la sucursal del token JWT.")
    public ApiResponse<CalcularImpuestosResponse> calcular(@Valid @RequestBody CalcularImpuestosRequest request) {
        log.info("POST /api/finanzas/calcular-impuestos - items: {}",
            request.getItems() != null ? request.getItems().size() : 0);

        CalcularImpuestosResponse response = service.calcular(request);
        return ApiResponse.ok(response);
    }
}
