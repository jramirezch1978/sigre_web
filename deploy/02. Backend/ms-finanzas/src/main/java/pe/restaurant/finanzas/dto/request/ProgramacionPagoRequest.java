package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionPagoRequest {

    @NotNull(message = "La fecha programada es obligatoria")
    private LocalDate fechaProgramada;

    @Valid
    @NotNull(message = "Los detalles son obligatorios")
    @Size(min = 1, message = "Debe incluir al menos un detalle")
    private List<ProgramacionPagoDetalleRequest> detalles;
}
