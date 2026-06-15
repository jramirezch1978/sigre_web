package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
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
public class ArticuloPrecioPactadoRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    private Long proveedorId;

    @NotNull
    private BigDecimal precio;

    private Long monedaId;

    private LocalDate fechaDesde;

    private LocalDate fechaHasta;
}
