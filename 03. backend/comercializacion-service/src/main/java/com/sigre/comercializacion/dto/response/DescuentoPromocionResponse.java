package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DescuentoPromocionResponse {
    private Long id;
    private String nombre;
    private String tipo;
    private BigDecimal valor;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String diasAplicacion;
    private LocalTime horaInicio;
    private LocalTime horaFin;
    private BigDecimal montoMinimo;
    private String flagEstado;
    private String vigenciaDerivada;
}
