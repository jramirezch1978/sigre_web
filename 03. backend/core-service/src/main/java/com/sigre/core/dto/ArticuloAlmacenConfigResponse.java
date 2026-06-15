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
public class ArticuloAlmacenConfigResponse {
    private Long id;
    private Long articuloId;
    private Long almacenId;
    private BigDecimal stockMin;
    private BigDecimal stockMax;
}
