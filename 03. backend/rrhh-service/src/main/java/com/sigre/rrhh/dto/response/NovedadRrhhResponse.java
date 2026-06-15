package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class NovedadRrhhResponse {
    private Long id;
    private Long trabajadorId;
    private Long tipoNovedadRrhhId;
    private String citt;
    private LocalDate fechaIni;
    private LocalDate fechaFin;
    private Integer diasTeoricos;
    private Integer diasReales;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
