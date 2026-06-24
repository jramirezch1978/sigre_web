package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class SeccionResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private Long areaId;
    private String areaNombre;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
