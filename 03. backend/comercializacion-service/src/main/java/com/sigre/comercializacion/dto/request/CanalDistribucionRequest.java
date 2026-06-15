package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CanalDistribucionRequest {
    
    @NotBlank(message = "El código del canal es obligatorio")
    @Size(max = 20, message = "El código del canal no puede exceder 20 caracteres")
    private String codigo;
    
    @NotBlank(message = "El nombre del canal es obligatorio")
    @Size(max = 120, message = "El nombre del canal no puede exceder 120 caracteres")
    private String nombre;
}
