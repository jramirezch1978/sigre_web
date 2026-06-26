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
public class MonedaRequest {

    @NotBlank
    @Size(max = 10)
    private String codigo;

    @Size(max = 10)
    private String siglaMoneda;

    @NotBlank
    @Size(max = 80)
    private String nombre;

    @Size(max = 10)
    private String simbolo;

    private Integer decimales = 2;

    private String flagEstado = "1";
}
