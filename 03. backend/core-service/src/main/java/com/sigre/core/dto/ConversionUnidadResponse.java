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
public class ConversionUnidadResponse {
    private Long id;
    private Long umOrigenId;
    private String umOrigenCodigo;
    private String umOrigenNombre;
    private Long umDestinoId;
    private String umDestinoCodigo;
    private String umDestinoNombre;
    private BigDecimal factorConversion;
    private String flagEstado;
}
