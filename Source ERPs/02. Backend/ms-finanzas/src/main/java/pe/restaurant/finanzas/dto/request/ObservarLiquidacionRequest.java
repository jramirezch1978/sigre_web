package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request para observar una liquidación de rendición de gastos (HU-FIN-OPE-004, 6.7).
 * El motivo es OBLIGATORIO; al observar, la liquidación vuelve a ser editable por quien la registró.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ObservarLiquidacionRequest {

    @NotBlank(message = "El motivo de la observación es obligatorio")
    @Size(max = 200, message = "El motivo no puede exceder 200 caracteres")
    private String motivo;
}
