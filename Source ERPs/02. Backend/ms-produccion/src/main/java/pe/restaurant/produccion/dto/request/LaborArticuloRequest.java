package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LaborArticuloRequest {

    @NotNull(message = "El artículo es requerido")
    @Positive(message = "El artículo debe ser un valor positivo")
    private Long articuloId;
}
