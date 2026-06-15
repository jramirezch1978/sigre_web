package com.sigre.finanzas.dto.response;

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
public class AsientoContableResponse {
    
    private Long id;
    
    private String voucher;
    
    private Long libroId;
    
    private LocalDate fecha;
    
    private String glosa;
    
    private String tipo;
    
    private String moduloOrigen;
    
    private Long documentoOrigenId;
    
    private Long monedaId;
    
    private BigDecimal tc;
    
    private Long createdBy;
    
    private Instant fecCreacion;
    
    private Long updatedBy;
    
    private Instant fecModificacion;
    
    private List<AsientoContableDetalleResponse> detalles;
}
