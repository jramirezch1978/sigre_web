package com.sigre.core.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EjercicioPeriodoRequest {
    @NotNull
    private Integer anio;

    private LocalDate fechaInicio;

    private LocalDate fechaFin;

    @Size(max = 1)
    private String flagEstado;
}
