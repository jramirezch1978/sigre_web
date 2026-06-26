package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO de entrada para crear o actualizar un registro de ganancia/descuento variable.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDescVariableRequest {

    @NotNull(message = "El trabajador es obligatorio")
    private Long trabajadorId;

    @NotNull(message = "La fecha de movimiento es obligatoria")
    private LocalDate fecMovim;

    @NotNull(message = "El concepto de planilla es obligatorio")
    private Long conceptoId;

    @Size(max = 30)
    private String nroDoc;

    private BigDecimal impVar;

    private Long centrosCostoId;

    private BigDecimal cantLabor;

    private BigDecimal nroDias;

    private BigDecimal nroHoras;

    private Integer nroCuotas;

    private Long tipoPlanillaId;
}
