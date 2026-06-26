package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TurnoRequest {

    @NotBlank(message = "El nombre del turno es obligatorio")
    @Size(max = 120, message = "El nombre no puede exceder los 120 caracteres")
    private String nombre;

    private LocalTime horaEntrada;

    private LocalTime horaSalida;

    @Min(value = 0, message = "Los minutos de tolerancia deben ser mayores o iguales a 0")
    @Builder.Default
    private Integer minutosTolerancia = 0;

    @Builder.Default
    private Boolean aplicaLunes = true;

    @Builder.Default
    private Boolean aplicaMartes = true;

    @Builder.Default
    private Boolean aplicaMiercoles = true;

    @Builder.Default
    private Boolean aplicaJueves = true;

    @Builder.Default
    private Boolean aplicaViernes = true;

    @Builder.Default
    private Boolean aplicaSabado = false;

    @Builder.Default
    private Boolean aplicaDomingo = false;
}
