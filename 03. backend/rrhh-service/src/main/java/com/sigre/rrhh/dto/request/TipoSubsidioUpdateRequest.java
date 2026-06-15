package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoSubsidioUpdateRequest {
    @Size(max = 120) private String nombre;
    private Integer nroDias;
    private String flagEstado;
}
