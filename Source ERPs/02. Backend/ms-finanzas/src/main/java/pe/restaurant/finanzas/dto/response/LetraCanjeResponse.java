package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LetraCanjeResponse {
    
    private String referencia;
    
    private Long proveedorId;
    
    private String proveedorRazonSocial;
    
    private LocalDate fechaCanje;
    
    private BigDecimal montoCanjeado;
    
    private Integer cantidadOrigenes;
    
    private Integer cantidadDestinos;
    
    private Long createdBy;
    
    private Instant fecCreacion;
}
