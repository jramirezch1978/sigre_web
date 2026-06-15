package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class SancionAmonestacionResponse {
    private Long id;
    private Long trabajadorId;
    private Long tipoSancionId;
    private LocalDate fecha;
    private String motivo;
    private String documento;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
