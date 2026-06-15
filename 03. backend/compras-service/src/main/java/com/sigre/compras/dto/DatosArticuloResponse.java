package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DatosArticuloResponse {

    private BigDecimal precioPactado;
    private Long almacenTacitoId;
    private BigDecimal saldoActual;
    private Boolean flagPercepcion;
    private BigDecimal percepcionTasa;
    private Long unidadMedidaId;
    private String unidadMedidaDescripcion;
}
