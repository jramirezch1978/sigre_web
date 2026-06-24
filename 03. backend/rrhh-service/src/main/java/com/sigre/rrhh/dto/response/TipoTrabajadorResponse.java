package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class TipoTrabajadorResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private Integer libroProvRemuneracion;
    private Integer libroProvGratificacion;
    private Integer libroProvCts;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
