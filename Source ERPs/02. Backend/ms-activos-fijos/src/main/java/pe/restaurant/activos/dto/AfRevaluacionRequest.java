package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfRevaluacionRequest {

    @NotNull
    private Long afMaestroId;

    @NotNull
    private LocalDate fecha;

    private BigDecimal valorAnterior;
    private BigDecimal valorNuevo;
    private String sustento;
    private Long peritoId;
}
