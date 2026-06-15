package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoContableDetalleRequest {
    
    @NotNull(message = "El ID del plan contable es obligatorio")
    private Long planContableDetId;
    
    private Long centrosCostoId;
    
    private Long entidadContribuyenteId;
    
    private String glosaDetalle;
    
    @NotNull(message = "El monto del debe es obligatorio")
    private BigDecimal debe;
    
    @NotNull(message = "El monto del haber es obligatorio")
    private BigDecimal haber;
    
    private BigDecimal debeMe;
    
    private BigDecimal haberMe;
    
    private String referencia;
}
