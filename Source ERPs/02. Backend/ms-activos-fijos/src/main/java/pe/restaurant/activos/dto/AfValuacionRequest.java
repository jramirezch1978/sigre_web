package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
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
public class AfValuacionRequest {

    @NotNull(message = "El ID del activo es obligatorio")
    private Long afMaestroId;

    @NotNull(message = "La fecha de valuación es obligatoria")
    private LocalDate fechaValuacion;

    @NotNull(message = "El valor anterior es obligatorio")
    @DecimalMin(value = "0.0", message = "El valor anterior debe ser mayor o igual a 0")
    private BigDecimal valorAnterior;

    @NotNull(message = "El valor nuevo es obligatorio")
    @DecimalMin(value = "0.0", message = "El valor nuevo debe ser mayor o igual a 0")
    private BigDecimal valorNuevo;

    @NotBlank(message = "El método de valuación es obligatorio")
    @Size(max = 50, message = "El método de valuación no puede exceder 50 caracteres")
    private String metodoValuacion;

    @NotNull(message = "El ID del responsable es obligatorio")
    private Long responsableId;

    @Size(max = 500, message = "Las observaciones no pueden exceder 500 caracteres")
    private String observaciones;

    private LocalDate fechaAprobacion;

    private Long aprobadorId;

    @Size(max = 20, message = "El tipo de revaluación no puede exceder 20 caracteres")
    private String tipoRevaluacion;

    @Size(max = 50, message = "La fuente de revaluación no puede exceder 50 caracteres")
    private String fuenteRevaluacion;

    private BigDecimal factorRevaluacion;

    @Size(max = 30, message = "El documento soporte no puede exceder 30 caracteres")
    private String documentoSoporte;

    private Integer nuevaVidaUtil;

    private BigDecimal valorResidual;
}
