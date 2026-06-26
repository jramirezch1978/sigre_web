package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfValuacionResponse {
    private Long id;
    private Long afMaestroId;
    private LocalDate fechaValuacion;
    private BigDecimal valorAnterior;
    private BigDecimal valorNuevo;
    private String metodoValuacion;
    private Long responsableId;
    private String observaciones;
    private LocalDate fechaAprobacion;
    private Long aprobadorId;
    private String estado;
    private String tipoRevaluacion;
    private String fuenteRevaluacion;
    private BigDecimal factorRevaluacion;
    private String documentoSoporte;
    private Integer nuevaVidaUtil;
    private BigDecimal valorResidual;
}
