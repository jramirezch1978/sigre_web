package com.sigre.comercializacion.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CierreCajaRequest {

    private Long turnoId;
    private BigDecimal ventasEfectivo;
    private BigDecimal ventasTarjeta;
    private BigDecimal ventasDigital;
    private BigDecimal ventasTotal;
    private BigDecimal propinasTotal;
    private BigDecimal fondoInicial;
    private String observaciones;
}
