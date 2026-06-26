package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request de rechazo de Orden de Giro con <b>observación obligatoria</b> (HU-FIN-ADL-001 / ADL-002).
 *
 * <p>Se crea aparte de {@code RechazarSolicitudRequest} (cuyo {@code observacion} es opcional)
 * para no cambiar el contrato del endpoint existente {@code /solicitudes-giro/{id}/rechazar}.
 * Aquí la observación es {@code @NotBlank}.</p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RechazarOrdenGiroRequest {

    @NotBlank(message = "La observación (motivo de rechazo) es obligatoria")
    private String observacion;
}
