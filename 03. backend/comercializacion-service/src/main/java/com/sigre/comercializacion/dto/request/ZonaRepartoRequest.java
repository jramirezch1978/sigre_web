package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaRepartoRequest {
    
    @NotBlank(message = "La zona de reparto es obligatoria")
    @Size(max = 8, message = "La zona de reparto no puede exceder 8 caracteres")
    private String zonaReparto;
    
    @NotBlank(message = "La descripción de la zona de reparto es obligatoria")
    @Size(max = 200, message = "La descripción no puede exceder 200 caracteres")
    private String descZonaReparto;
    
    @Size(max = 6, message = "El ubigeo no puede exceder 6 caracteres")
    private String ubigeo;
}
