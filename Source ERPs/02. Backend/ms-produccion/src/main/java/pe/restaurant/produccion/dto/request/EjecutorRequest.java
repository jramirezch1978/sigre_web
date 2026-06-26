package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EjecutorRequest {

    @NotBlank(message = "El código es requerido")
    @Size(max = 20, message = "El código debe tener máximo 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 120, message = "El nombre debe tener máximo 120 caracteres")
    private String nombre;

    private Long centrosCostoId;

    private String flagExterno;
}
