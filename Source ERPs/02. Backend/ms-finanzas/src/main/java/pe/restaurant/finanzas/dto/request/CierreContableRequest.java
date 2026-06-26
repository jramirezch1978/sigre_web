package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * Request para el cierre contable completo de una liquidación (HU-FIN-ADL-004):
 * estampa la fecha de cierre, registra la glosa contable del cierre y dispara la
 * generación del asiento de cierre. DTO independiente del cierre simple existente
 * para no impactar el endpoint vigente.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CierreContableRequest {

    /** Fecha de cierre (columna fecha_liquidacion). Si es null se usa la fecha actual. */
    @PastOrPresent(message = "La fecha de liquidación no puede ser futura")
    private LocalDate fechaLiquidacion;

    /** Glosa / descripción contable del cierre (se envía como glosa del asiento). */
    @Size(max = 200, message = "La glosa no puede exceder 200 caracteres")
    private String glosa;

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
