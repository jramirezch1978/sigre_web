package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DevolucionTotalRequest {

    @NotBlank(message = "El motivo de devolución es obligatorio")
    private String motivoDevolucion;
}
