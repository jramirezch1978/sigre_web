package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * Request para el cierre masivo de liquidaciones (HU-FIN-ADL-004, consideración
 * técnica de cierres masivos con confirmación previa). Cada liquidación se cierra
 * de forma independiente; el resultado individual se devuelve por id.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CierreMasivoRequest {

    @NotEmpty(message = "Debe indicar al menos una liquidación a cerrar")
    private List<Long> liquidacionIds;

    /** Fecha de cierre aplicada a todas. Si es null se usa la fecha actual por liquidación. */
    @PastOrPresent(message = "La fecha de liquidación no puede ser futura")
    private LocalDate fechaLiquidacion;

    @Size(max = 200, message = "La glosa no puede exceder 200 caracteres")
    private String glosa;

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
