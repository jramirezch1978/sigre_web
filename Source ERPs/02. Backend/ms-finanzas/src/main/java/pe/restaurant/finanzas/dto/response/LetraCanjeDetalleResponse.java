package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LetraCanjeDetalleResponse {
    
    private String referencia;
    
    private Long proveedorId;
    
    private String proveedorRazonSocial;
    
    private LocalDate fechaCanje;
    
    private BigDecimal montoCanjeado;
    
    private List<OrigenCanjeResponse> origenes;
    
    private List<DestinoCanjeResponse> destinos;
}
