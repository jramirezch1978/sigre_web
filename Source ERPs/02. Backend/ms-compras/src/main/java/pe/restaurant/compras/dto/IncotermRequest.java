package pe.restaurant.compras.dto;

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
public class IncotermRequest {

    @NotBlank
    @Size(max = 3)
    private String codigo;

    @Size(max = 60)
    private String descripcion;

    private String flagEstado = "1";
}
