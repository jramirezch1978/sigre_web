package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecepcionResumenResponse {

    private Long id;
    private String nroVale;
    private LocalDate fecha;
    private String flagEstado;
    private Long almacenId;
    private BigDecimal totalCantidad;
}
