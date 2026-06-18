package pe.restaurant.activos.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class AfNumeracionConfigRequest {

    @NotBlank
    @Size(max = 20)
    private String prefijo;

    @NotNull
    @Min(0)
    private Long secuenciaActual;

    @NotNull
    @Min(4)
    private Integer longitudNumero;
}
