package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CalcularImpuestosRequest {

    private BigDecimal descuentoGlobal = BigDecimal.ZERO;

    private Boolean dsctoGlobalConIgv = true;

    private String dsctoGlobalTipo = "$";

    @NotNull(message = "Debe incluir al menos un ítem")
    @Valid
    private List<ItemCalculoRequest> items;
}
