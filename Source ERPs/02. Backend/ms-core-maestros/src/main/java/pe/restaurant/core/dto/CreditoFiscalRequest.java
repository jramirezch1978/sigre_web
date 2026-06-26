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
public class CreditoFiscalRequest {

    @NotBlank
    @Size(max = 2)
    private String codigo;

    @Size(max = 50)
    private String descripcion;

    @Size(max = 2)
    private String codSunat;

    @NotBlank
    @Size(max = 1)
    private String flagTipoAdquisicion = "3";

    @NotBlank
    @Size(max = 1)
    private String flagCxpCxc = "P";

    @Size(max = 2)
    private String tipoAfectacionIgv;

    private String flagEstado = "1";
}
