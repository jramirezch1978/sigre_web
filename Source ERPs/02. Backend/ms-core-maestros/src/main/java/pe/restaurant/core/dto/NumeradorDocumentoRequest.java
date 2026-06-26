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
public class NumeradorDocumentoRequest {

    @NotBlank
    @Size(max = 128)
    private String nombreTabla;

    @NotNull
    private Long sucursalId;

    @NotNull
    private Short ano;

    private Long ultNro = 1L;

    private String flagEstado = "1";
}
