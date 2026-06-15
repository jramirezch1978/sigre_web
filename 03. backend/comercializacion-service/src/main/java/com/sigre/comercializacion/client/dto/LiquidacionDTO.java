package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO para transferir datos de Liquidación desde finanzas-service.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionDTO {
    private Long id;
    private String nroLiquidacion;
    private LocalDate fechaRegistro;
    private Long proveedorId;
    private Long monedaId;
    private BigDecimal importeNeto;
    private BigDecimal saldo;
    private String observacion;
}
