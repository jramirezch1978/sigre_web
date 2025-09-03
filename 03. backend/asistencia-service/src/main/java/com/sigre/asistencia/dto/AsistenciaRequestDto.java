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
public class AsistenciaRequestDto {
    
    @NotBlank(message = "El código de trabajador es obligatorio")
    private String codTrabajador;
    
    @NotBlank(message = "El tipo de movimiento es obligatorio")
    @Pattern(regexp = "^(INGRESO_PLANTA|SALIDA_PLANTA|SALIDA_ALMORZAR|REGRESO_ALMORZAR|SALIDA_COMISION|RETORNO_COMISION|INGRESO_PRODUCCION|SALIDA_PRODUCCION)$", 
             message = "Tipo de movimiento no válido")
    private String tipoMovimiento;
    
    @NotBlank(message = "El tipo de marcaje es obligatorio")
    @Pattern(regexp = "^(puerta-principal|area-produccion|comedor)$", 
             message = "Tipo de marcaje no válido")
    private String tipoMarcaje;
    
    @NotBlank(message = "El usuario es obligatorio")
    private String codUsuario;
    
    private String direccionIp;
    private String observaciones;
    private String turno;
}