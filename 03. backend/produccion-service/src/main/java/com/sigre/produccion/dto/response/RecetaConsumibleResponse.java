package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecetaConsumibleResponse {

    private Long id;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloDescripcion;
    private BigDecimal cantidad;
}
