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
public class OrdenServicioResumenResponse {

    private Long id;
    private Long sucursalId;
    private String codOrigen;
    private String nroOs;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private LocalDate fecRegistro;
    private Long monedaId;
    private String monedaCodigo;
    private BigDecimal montoTotal;
    private String flagEstado;
    private Long formaPagoId;
    private String compradorNombre;
}
