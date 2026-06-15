package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AprobadorConfiguradoResponse {

    private Long id;
    private Long docTipoId;
    private Integer nivel;
    private Long aprobadorId;
    private BigDecimal montoMinimo;
    private BigDecimal montoMaximo;
    private String flagEstado;
}
