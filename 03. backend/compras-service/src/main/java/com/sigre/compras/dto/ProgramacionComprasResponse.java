package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionComprasResponse {

    private Long id;
    private Long sucursalId;
    private String numero;
    private Integer anio;
    private Integer mes;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
}
