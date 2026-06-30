package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LineaCreditoResponse {
    private Long id;
    private Long monedaId;
    private BigDecimal limiteCredito;
    private Integer diasCredito;
    private String flagEstado;
}
