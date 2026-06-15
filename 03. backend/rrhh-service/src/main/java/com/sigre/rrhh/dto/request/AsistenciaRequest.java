package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * DTO de entrada para crear o actualizar un registro de asistencia.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsistenciaRequest {

    @NotNull(message = "El trabajador es obligatorio")
    private Long trabajadorId;

    @NotNull(message = "La fecha es obligatoria")
    private LocalDate fecha;

    private LocalTime horaEntrada;

    private LocalTime horaSalida;

    private Long tipoMovAsistenciaId;
}
