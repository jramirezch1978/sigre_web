package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsolidadoResponse {

    private List<ImpuestoCalculadoResponse> impuestos;
    private BigDecimal subtotal;
    private BigDecimal totalIgv;
    private BigDecimal totalConImpuestos;
    private BigDecimal descuentoGlobalSinImpuestos;
    private BigDecimal descuentoGlobalConImpuestos;
}
