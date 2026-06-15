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
public class ArticuloEstructuraResponse {

    private Long articuloPadreId;
    private Long articuloHijoId;
    private BigDecimal cantidad;
}
