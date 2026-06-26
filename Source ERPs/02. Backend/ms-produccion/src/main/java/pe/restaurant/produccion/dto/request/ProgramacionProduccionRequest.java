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
    @Size(max = 1, message = "La frecuencia debe ser un código de 1 carácter (D=Diaria, S=Semanal, Q=Quincenal, M=Mensual, A=Anual)")
    private String flagFrecuencia;

    @NotNull(message = "La fecha de inicio es requerida")
    private LocalDate fechaInicio;

    private LocalDate fechaFin;

    @NotNull(message = "La cantidad por período es requerida")
    @Digits(integer = 18, fraction = 4, message = "Cantidad inválida")
    private BigDecimal cantidadPorPeriodo;

    @Size(max = 1, message = "El turno debe ser un código de 1 carácter (M=Mañana, T=Tarde, N=Noche)")
    private String flagTurno;
}
