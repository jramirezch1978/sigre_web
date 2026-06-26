package pe.restaurant.activos.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfRevaluacionResponse {
    private Long id;
    private Long afMaestroId;
    private LocalDate fecha;
    private BigDecimal valorAnterior;
    private BigDecimal valorNuevo;
    private String sustento;
    private Long peritoId;
    private String flagEstado;
}
