package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConciliarPartidasRequest {

    @NotNull(message = "Los IDs de detalles son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle para conciliar")
    private List<Long> detalleIds;
}
