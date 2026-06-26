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
public class NumTablasRequest {

    @NotBlank
    @Size(max = 120)
    private String nombreTabla;

    @NotBlank
    @Size(max = 20)
    private String codOrigen = "XX";

    private Long ultimoNumero = 0L;
}
