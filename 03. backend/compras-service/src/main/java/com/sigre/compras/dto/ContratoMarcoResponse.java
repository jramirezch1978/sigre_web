package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContratoMarcoResponse {

    private Long id;
    private Long proveedorId;
    private String proveedorRazonSocial;
    private String proveedorRuc;
    private String numero;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String condiciones;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
