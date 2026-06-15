package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class VacacionResponse {
    private Long id;
    private Long trabajadorId;
    private Integer periodoAnio;
    private Integer diasDerecho;
    private Integer diasGozados;
    private Integer diasPendientes;
    private String fechaInicio;
    private String fechaFin;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
