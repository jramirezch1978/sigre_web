package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrigenCanjeResponse {
    
    private Long cntasPagarId;
    
    private String serie;
    
    private String numero;
    
    private BigDecimal totalOriginal;
    
    private BigDecimal montoCanjeado;
    
    private BigDecimal saldoFinal;
}
