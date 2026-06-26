package pe.restaurant.core.dto;

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
public class SunatCubsoRequest {

    @NotBlank
    @Size(max = 20)
    private String codCubso;

    @NotBlank
    @Size(max = 500)
    private String descripcion;

    @Size(max = 20)
    private String codClase;

    private String flagEstado = "1";
}
