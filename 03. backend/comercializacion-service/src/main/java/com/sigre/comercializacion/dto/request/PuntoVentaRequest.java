package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PuntoVentaRequest {
    
    @NotNull(message = "El ID de sucursal es obligatorio")
    private Long sucursalId;
    
    private Long almacenId;
    
    @NotBlank(message = "El código del punto de venta es obligatorio")
    @Size(max = 20, message = "El código del punto de venta no puede exceder 20 caracteres")
    private String codigo;
    
    @NotBlank(message = "El nombre del punto de venta es obligatorio")
    @Size(max = 150, message = "El nombre del punto de venta no puede exceder 150 caracteres")
    private String nombre;
    
    @Size(max = 10, message = "La serie de boleta no puede exceder 10 caracteres")
    private String serieBoleta;
    
    @Size(max = 10, message = "La serie de factura no puede exceder 10 caracteres")
    private String serieFactura;
    
    @Size(max = 30, message = "El tipo de impresora no puede exceder 30 caracteres")
    private String tipoImpresora;
}
