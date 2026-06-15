package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ValidacionCierreResponse {

    private Long id;

    private String nroLiquidacion;

    private BigDecimal importeNeto;

    private BigDecimal sumaDetalles;

    private Boolean cuadrado;

    private Long solicitudGiroId;

    private String solicitudGiroNumero;

    private Boolean puedeCerrar;
}
