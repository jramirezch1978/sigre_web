package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CntasPagarResponse {
    
    private Long id;
    
    private Long sucursalId;
    
    private Long proveedorId;
    
    private String proveedorRazonSocial;
    
    private Long docTipoId;
    
    private String docTipoCodigo;
    
    private String docTipoNombre;
    
    private String serie;
    
    private String numero;
    
    private LocalDate fechaEmision;
    
    private LocalDate fechaVencimiento;
    
    private Long monedaId;
    
    private String monedaCodigo;
    
    private String monedaSimbolo;
    
    private BigDecimal total;
    
    private BigDecimal saldo;

    private Integer ano;

    private Integer mes;

    private Long cntblLibroId;
    
    private Long cntblAsientoId;
    
    private String flagEstado;
    
    private Long createdBy;
    
    private Instant fecCreacion;
    
    private Long updatedBy;
    
    private Instant fecModificacion;
    
    private List<CntasPagarDetResponse> detalles;
    
    private AsientoContableResponse asiento;
}
