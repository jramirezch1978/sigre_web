package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para información de origen/planta
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrigenDto {
    private String codOrigen;
    private String nombre;
    private String ubicacion; // Combinación de distrito, provincia, departamento
}

