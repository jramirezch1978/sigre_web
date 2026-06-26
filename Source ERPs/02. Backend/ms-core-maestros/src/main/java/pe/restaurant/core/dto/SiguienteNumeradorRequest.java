package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SiguienteNumeradorRequest {

    @NotBlank
    private String codigoNumerador;

    private Long sucursalId;
}
