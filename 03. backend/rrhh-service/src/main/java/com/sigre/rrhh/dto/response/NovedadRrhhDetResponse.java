package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class NovedadRrhhDetResponse {
    private Long id;
    private Long novedadRrhhId;
    private LocalDate fechaProceso;
    private BigDecimal montoPlanilla;
    private BigDecimal montoSeguro;
    private String referenciaDoc;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
