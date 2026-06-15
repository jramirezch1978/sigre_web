package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServicioDisponibleResponse {
    private Long id;
    private String servicio;
    private String descripcion;
    private Long unidadMedidaId;
    private Long articuloSubCategId;
    private BigDecimal tarifaEstd;
}
