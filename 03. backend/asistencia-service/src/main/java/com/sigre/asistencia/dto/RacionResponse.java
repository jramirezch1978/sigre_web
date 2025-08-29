package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RacionResponse {
    private String id;
    private String nombre;
    private String descripcion;
    private String icono;
    private boolean disponible;
    private String color;
    private String horario;
}
