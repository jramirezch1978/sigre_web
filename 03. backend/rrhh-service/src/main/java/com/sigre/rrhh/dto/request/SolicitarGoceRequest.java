package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class SolicitarGoceRequest {
    @NotNull private LocalDate fechaInicio;
    @NotNull private LocalDate fechaFin;
}
