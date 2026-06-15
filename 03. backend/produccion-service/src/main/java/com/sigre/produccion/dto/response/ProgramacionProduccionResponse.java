package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionProduccionResponse {

    private Long id;

    private Long sucursalId;
    private String sucursalNombre;

    private Long recetaId;
    private String recetaCodigo;
    private String recetaNombre;

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;

    private String frecuencia;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private BigDecimal cantidadPorPeriodo;
    private String turno;
    private String flagEstado;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
