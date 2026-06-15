package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockArticuloAlmacenResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private BigDecimal cantidadDisponible;
    private BigDecimal cantidadReservada;
    private BigDecimal cantidadTotal;
    private BigDecimal costoPromedio;
    private OffsetDateTime ultimaActualizacion;
}
