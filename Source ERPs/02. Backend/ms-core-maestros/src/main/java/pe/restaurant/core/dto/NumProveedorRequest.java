package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NumProveedorRequest {

    @NotNull
    private Long sucursalId;

    @NotBlank
    @Size(max = 10)
    private String serie;

    @NotNull
    private Integer anio;

    private Long ultimoNumero = 0L;
}
