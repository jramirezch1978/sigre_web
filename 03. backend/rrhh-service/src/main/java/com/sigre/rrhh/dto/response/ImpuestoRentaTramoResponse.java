package com.sigre.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class ImpuestoRentaTramoResponse {

    private Long id;
    private Integer secuencia;
    private BigDecimal tasa;
    private BigDecimal topeIni;
    private BigDecimal topeFin;
    private LocalDate fechaVigIni;
    private LocalDate fechaVigFin;
    private String codUsr;
    private String flagReplicacion;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
