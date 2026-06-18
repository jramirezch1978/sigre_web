package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActividadFlujoCajaRequest {

    @NotBlank(message = "El código es obligatorio")
    @Size(max = 2, message = "El código no puede exceder 2 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 200, message = "El nombre no puede exceder 200 caracteres")
    private String nombre;

    @NotNull(message = "El orden es obligatorio")
    private Integer orden;

    @Size(max = 1, message = "El flag tipo flujo no puede exceder 1 caracter")
    private String flagTipoFlujo = "E";
}
