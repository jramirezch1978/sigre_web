package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * Request para el cierre de liquidación que, además de la observación, recibe la
 * fecha de cierre (columna finanzas.liquidacion.fecha_liquidacion). Se crea como
 * DTO independiente de {@link CerrarLiquidacionRequest} para no impactar el endpoint
 * de cierre existente.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CerrarLiquidacionConFechaRequest {

    @NotNull(message = "La fecha de liquidación es obligatoria")
    @PastOrPresent(message = "La fecha de liquidación no puede ser futura")
    private LocalDate fechaLiquidacion;

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
