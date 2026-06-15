package com.sigre.almacen.dto;

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
public class ArticuloBonificacionResponse {

    private Long id;
    private Long articuloId;
    private BigDecimal cantidadMinima;
    private BigDecimal cantidadBonificacion;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String flagEstado;
}
