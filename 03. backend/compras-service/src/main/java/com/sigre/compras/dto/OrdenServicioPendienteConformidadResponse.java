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
public class OrdenServicioPendienteConformidadResponse {
    private Long ordenServicioId;
    private String nroOs;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private LocalDate fecRegistro;
    private BigDecimal montoTotal;
    private String flagEstado;
}
