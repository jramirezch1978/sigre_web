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
public class OperacionDetalleInfo {
    private Long id;
    private ArticuloInfo articulo;
    private BigDecimal cantidadRequerida;
    private String flagEstado;
}
