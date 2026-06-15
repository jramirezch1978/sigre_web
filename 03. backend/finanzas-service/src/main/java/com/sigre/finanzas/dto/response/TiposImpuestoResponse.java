package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TiposImpuestoResponse {
    private Long id;
    private String tipoImpuesto;
    private String descImpuesto;
    private BigDecimal tasaImpuesto;
    private String signo;
    private String flagDhCxp;
    private String flagIgv;
    private String flagEstado;
    private Integer tipoCalculo;
}
