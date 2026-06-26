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
public class CatalogoSunatRequest {

    @NotBlank
    @Size(max = 30)
    private String codigoCatalogo;

    @NotBlank
    @Size(max = 180)
    private String nombreCatalogo;

    private String descripcionCatalogo;

    private String flagEstado = "1";
}
