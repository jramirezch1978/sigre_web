package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class RemuneracionMinimaVitalUpdateRequest {

    @NotNull
    private Long tipoTrabajadorId;

    @NotNull
    @DecimalMin(value = "0.01", message = "El RMV debe ser mayor a cero.")
    @Digits(integer = 11, fraction = 2)
    private BigDecimal rmv;

    @NotNull
    private LocalDate fechaDesde;
}
