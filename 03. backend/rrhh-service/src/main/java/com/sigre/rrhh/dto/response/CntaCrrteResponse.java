package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class CntaCrrteResponse {
    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private LocalDate fechaApertura;
    private BigDecimal saldoInicial;
    private BigDecimal saldoActual;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
