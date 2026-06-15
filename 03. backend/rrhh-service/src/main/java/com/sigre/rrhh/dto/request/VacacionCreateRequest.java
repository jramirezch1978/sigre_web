package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class VacacionCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Integer periodoAnio;
    private Integer diasDerecho;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
}
