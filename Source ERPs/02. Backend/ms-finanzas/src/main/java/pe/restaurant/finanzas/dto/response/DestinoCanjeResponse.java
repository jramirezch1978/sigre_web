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
public class DestinoCanjeResponse {
    
    private Long cntasPagarId;
    
    private Long docTipoId;
    
    private String serie;
    
    private String numero;
    
    private LocalDate fechaEmision;
    
    private LocalDate fechaVencimiento;
    
    private Long monedaId;
    
    private BigDecimal total;
    
    private BigDecimal saldo;
    
    private String flagEstado;
    
    private Long createdBy;
    
    private Instant fecCreacion;
    
    private Long updatedBy;
    
    private Instant fecModificacion;
}
