package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Request para operaciones masivas (aprobación / anulación) de Órdenes de Giro
 * (HU-FIN-ADL-001 / ADL-002, acción "Aprobación masiva"). Cada orden se procesa de
 * forma independiente; el resultado individual se devuelve por id.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OperacionMasivaGiroRequest {

    @NotEmpty(message = "Debe indicar al menos una Orden de Giro")
    private List<Long> ordenGiroIds;

    /** Observación opcional (solo informativa; no se persiste por falta de columna). */
    private String observacion;
}
