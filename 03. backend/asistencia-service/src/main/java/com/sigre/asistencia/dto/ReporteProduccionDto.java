package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReporteProduccionDto {

    private Integer nro;
    private String codigoTrabajador;
    private String dni;
    private String nombres;
    private String apellidos;
    private LocalDateTime horaIngresoPlanta;
    private LocalDateTime horaIngresoProduccion;
    private Double minutosCambioRopa;
    private LocalDateTime horaSalidaProduccion;
    private LocalDateTime horaSalidaPlanta;
    private Double horasEfectivasProduccion;
    private Double horasTotalPlanta;
    private Double horasMuertas;
    private LocalDate fecha;
}
