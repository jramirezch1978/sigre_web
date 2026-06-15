package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionPagoListResponse {

    private Long id;

    private LocalDate fechaProgramada;

    private BigDecimal totalProgramado;

    private Integer cantidadDocumentos;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
