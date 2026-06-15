package com.sigre.rrhh.dto.request;

import lombok.Data;
import java.time.LocalDate;

@Data
public class PermisoLicenciaUpdateRequest {

    private Long tipoSuspensionLaboralId;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer dias;
    private String sustento;
    private String flagEstado;
}
