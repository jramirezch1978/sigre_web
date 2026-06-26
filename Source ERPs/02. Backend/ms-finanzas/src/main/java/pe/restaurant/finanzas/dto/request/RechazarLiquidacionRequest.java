package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request para rechazar una liquidación de rendición de gastos (HU-FIN-OPE-004, 6.6).
 * La justificación es OBLIGATORIA según la HU.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RechazarLiquidacionRequest {

    @NotBlank(message = "La justificación del rechazo es obligatoria")
    @Size(max = 200, message = "La justificación no puede exceder 200 caracteres")
    private String justificacion;
}
