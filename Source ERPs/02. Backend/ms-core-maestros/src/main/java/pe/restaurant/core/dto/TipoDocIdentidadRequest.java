package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TipoDocIdentidadRequest {

    @NotBlank
    @Size(max = 10)
    private String codigo;

    @NotBlank
    @Size(max = 120)
    private String nombre;

    @Size(max = 10)
    private String tipoDoc;

    @NotBlank
    @Size(max = 10)
    private String tipoDocAfpnet = "0";

    @Size(max = 10)
    private String flagDocBbva;

    private String flagEstado = "1";
}
