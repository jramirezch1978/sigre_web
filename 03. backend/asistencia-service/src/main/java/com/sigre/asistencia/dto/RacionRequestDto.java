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
    @Pattern(regexp = "^(D|A|C)$", 
             message = "Tipo de ración no válido. Debe ser: D (Desayuno), A (Almuerzo) o C (Cena)")
    private String tipoRacion;
    
    @NotBlank(message = "El usuario es obligatorio")
    private String codUsuario;
    
    private String direccionIp;
    private String observaciones;
}