package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaVentaRequest {
    
    @NotBlank(message = "La zona de venta es obligatoria")
    @Size(max = 8, message = "La zona de venta no puede exceder 8 caracteres")
    private String zonaVenta;
    
    @NotBlank(message = "La descripción de la zona de venta es obligatoria")
    @Size(max = 200, message = "La descripción no puede exceder 200 caracteres")
    private String descZonaVenta;
    
    @Size(max = 6, message = "El ubigeo no puede exceder 6 caracteres")
    private String ubigeo;
}
