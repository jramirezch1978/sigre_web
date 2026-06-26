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
public class DocTipoNumSerieRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long docTipoId;

    @NotBlank
    @Size(max = 10)
    private String serie;

    private Long ultimoNumero = 0L;

    private String flagEstado = "1";
}
