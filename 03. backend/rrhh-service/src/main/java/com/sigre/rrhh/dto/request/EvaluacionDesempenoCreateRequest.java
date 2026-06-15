package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class EvaluacionDesempenoCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Integer periodoAnio;
    private Integer periodoSemestre;
    private BigDecimal calificacion;
    private String observaciones;
    private Long evaluadorId;
    private LocalDate fechaEvaluacion;
}
