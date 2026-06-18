package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenTipoRequest {

    @NotBlank(message = "Código es obligatorio")
    @Size(max = 20)
    private String codigo;

    @NotBlank(message = "Nombre es obligatorio")
    @Size(max = 120)
    private String nombre;
}
