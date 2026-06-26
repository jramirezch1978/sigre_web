package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request para aprobar una liquidación de rendición de gastos (HU-FIN-OPE-004, 6.5).
 * La observación es opcional: la HU pide "registrar" la observación al aprobar, no la exige.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AprobarLiquidacionRequest {

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
