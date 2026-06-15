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
public class TiposImpuestoResponse {
    private Long id;
    private String tipoImpuesto;
    private Long planContableDetId;
    private String descImpuesto;
    private BigDecimal tasaImpuesto;
    private String signo;
    private String flagDhCxp;
    private String flagIgv;
    private Integer tipoCalculo;
    private String flagEstado;
}
