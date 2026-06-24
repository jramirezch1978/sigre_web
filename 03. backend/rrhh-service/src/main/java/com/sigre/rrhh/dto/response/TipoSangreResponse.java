package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class TipoSangreResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
