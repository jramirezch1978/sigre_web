package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request para la reapertura controlada (reversión de cierre) de una liquidación.
 * El motivo es obligatorio por tratarse de una operación excepcional sobre un
 * documento ya cerrado (HU-FIN-ADL-004, consideración técnica de irreversibilidad).
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RevertirCierreRequest {

    @NotBlank(message = "El motivo de la reversión es obligatorio")
    @Size(max = 200, message = "El motivo no puede exceder 200 caracteres")
    private String motivo;
}