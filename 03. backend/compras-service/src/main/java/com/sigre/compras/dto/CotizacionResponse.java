package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CotizacionResponse {

    private Long id;
    private Long sucursalId;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private String proveedorRuc;
    private LocalDate fecha;
    private Long monedaId;
    private String monedaCodigo;
    private BigDecimal total;
    private String flagEstado;
}
