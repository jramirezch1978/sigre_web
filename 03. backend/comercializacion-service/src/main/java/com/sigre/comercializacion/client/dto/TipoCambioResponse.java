package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TipoCambioResponse {
    private Long id;
    private Long monedaId;
    private LocalDate fecha;
    private BigDecimal compra;
    private BigDecimal venta;
}
