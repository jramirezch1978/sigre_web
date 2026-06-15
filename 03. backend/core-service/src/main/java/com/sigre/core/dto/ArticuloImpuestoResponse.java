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
public class ArticuloImpuestoResponse {

    private Long id;
    private Long articuloId;
    private Long tiposImpuestoId;
    private String tipoImpuesto;
    private String descImpuesto;
    private BigDecimal tasaImpuesto;
    private String signo;
    private String flagIgv;
    private Short orden;
    private Integer tipoCalculo;
}
