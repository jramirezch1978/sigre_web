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
public class ItemCalculoResponse {

    private Integer item;
    private BigDecimal baseImponible;
    private BigDecimal montoTotal;
    private boolean esGravado;
    private boolean esInafecto;
    private List<ImpuestoCalculadoResponse> impuestos;
    private List<ImpuestoCalculadoResponse> descuentos;
}
