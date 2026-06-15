package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloPrecioPactadoResponse {

    private Long id;
    private Long articuloId;
    private Long proveedorId;
    private BigDecimal precio;
    private Long monedaId;
    private LocalDate fechaDesde;
    private LocalDate fechaHasta;
    private String flagEstado;
}
