package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAseguradoraRequest {

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 200, message = "El nombre debe tener máximo 200 caracteres")
    private String nombre;

    @Size(max = 20, message = "El RUC debe tener máximo 20 caracteres")
    private String ruc;

    @Size(max = 150, message = "El contacto debe tener máximo 150 caracteres")
    private String contacto;
}
