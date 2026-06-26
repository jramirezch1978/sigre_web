package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoNumRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long docTipoId;

    private Long origenId = 0L;

    @NotNull
    private Integer anio;

    private Long ultimoNumero = 0L;

    private String flagEstado = "1";
}
