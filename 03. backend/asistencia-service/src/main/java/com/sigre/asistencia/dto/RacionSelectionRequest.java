package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RacionSelectionRequest {
    
    @NotBlank(message = "El código de tarjeta es requerido")
    private String codigoTarjeta;
    
    @NotBlank(message = "El ID de ración es requerido")
    private String racionId;
}
