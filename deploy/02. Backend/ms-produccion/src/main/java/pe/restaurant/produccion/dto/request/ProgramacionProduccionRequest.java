package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionProduccionRequest {

    private Long sucursalId;

    @NotNull(message = "La receta es requerida")
    private Long recetaId;

    @NotNull(message = "La orden de trabajo es requerida")
    private Long ordenTrabajoId;

    @NotBlank(message = "La frecuencia es requerida")
    @Size(max = 20, message = "La frecuencia no debe exceder 20 caracteres")
    private String frecuencia;

    @NotNull(message = "La fecha de inicio es requerida")
    private LocalDate fechaInicio;

    private LocalDate fechaFin;

    @NotNull(message = "La cantidad por período es requerida")
    @Digits(integer = 18, fraction = 4, message = "Cantidad inválida")
    private BigDecimal cantidadPorPeriodo;

    @Size(max = 20, message = "El turno no debe exceder 20 caracteres")
    private String turno;
}
