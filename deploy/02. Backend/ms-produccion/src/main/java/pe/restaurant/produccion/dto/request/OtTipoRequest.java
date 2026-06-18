package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OtTipoRequest {

    @NotBlank(message = "El código es requerido")
    @Size(max = 20, message = "El código no debe exceder 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 120, message = "El nombre no debe exceder 120 caracteres")
    private String nombre;
}
