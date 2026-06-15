package com.sigre.rrhh.dto.request;

import lombok.Data;

@Data
public class ProgramVacacionUpdateRequest {
    private Integer diasProgramados;
    private String observacion;
    private String flagEstado;
}
