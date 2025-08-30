package com.sigre.asistencia.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RacionRequestDto {
    
    @NotBlank(message = "El código de trabajador es obligatorio")
    private String codTrabajador;
    
    @NotBlank(message = "El tipo de ración es obligatorio")
    @Pattern(regexp = "^(DESAYUNO|ALMUERZO|CENA)$", 
             message = "Tipo de ración no válido. Debe ser: DESAYUNO, ALMUERZO o CENA")
    private String tipoRacion;
    
    @NotBlank(message = "El usuario es obligatorio")
    private String codUsuario;
    
    private String direccionIp;
    private String observaciones;
}