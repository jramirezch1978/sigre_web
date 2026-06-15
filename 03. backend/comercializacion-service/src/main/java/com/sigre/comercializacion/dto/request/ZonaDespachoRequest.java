package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaDespachoRequest {
    
    @NotBlank(message = "La zona de despacho es obligatoria")
    @Size(max = 8, message = "La zona de despacho no puede exceder 8 caracteres")
    private String zonaDespacho;
    
    @NotBlank(message = "La descripción de la zona de despacho es obligatoria")
    @Size(max = 200, message = "La descripción no puede exceder 200 caracteres")
    private String descZonaDespacho;
    
    @Size(max = 6, message = "El ubigeo no puede exceder 6 caracteres")
    private String ubigeo;
}
