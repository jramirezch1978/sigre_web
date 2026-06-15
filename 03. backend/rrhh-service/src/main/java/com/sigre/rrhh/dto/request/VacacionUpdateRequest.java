package com.sigre.rrhh.dto.request;

import lombok.Data;
import java.time.LocalDate;

@Data
public class VacacionUpdateRequest {
    private Integer diasDerecho;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
}
