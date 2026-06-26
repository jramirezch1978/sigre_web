package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoContableDetalleResponse {
    
    private Long id;
    
    private Long planContableDetId;
    
    private String cuentaContable;
    
    private String nombreCuenta;
    
    private Long centrosCostoId;
    
    private String codigoCentroCosto;
    
    private Long entidadContribuyenteId;
    
    private String glosaDetalle;
    
    private BigDecimal debe;
    
    private BigDecimal haber;
    
    private BigDecimal debeMe;
    
    private BigDecimal haberMe;
    
    private String referencia;
    
    private Long createdBy;
    
    private Instant fecCreacion;
}
