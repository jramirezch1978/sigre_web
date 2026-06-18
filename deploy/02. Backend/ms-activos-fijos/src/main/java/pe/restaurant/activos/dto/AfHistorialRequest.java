package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfHistorialRequest {

    @NotNull(message = "El ID del activo es obligatorio")
    private Long afMaestroId;

    @NotBlank(message = "El tipo de evento es obligatorio")
    @Size(max = 50, message = "El tipo de evento no puede exceder 50 caracteres")
    private String tipoEvento;

    @NotBlank(message = "La descripción es obligatoria")
    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    private String descripcion;

    @Size(max = 200, message = "El valor anterior no puede exceder 200 caracteres")
    private String valorAnterior;

    @Size(max = 200, message = "El valor nuevo no puede exceder 200 caracteres")
    private String valorNuevo;

    @NotNull(message = "El ID del usuario es obligatorio")
    private Long usuarioId;

    @NotNull(message = "La fecha del evento es obligatoria")
    private LocalDateTime fechaEvento;

    @Size(max = 50, message = "La IP de origen no puede exceder 50 caracteres")
    private String ipOrigen;

    @Size(max = 50, message = "El módulo no puede exceder 50 caracteres")
    private String modulo;
}
