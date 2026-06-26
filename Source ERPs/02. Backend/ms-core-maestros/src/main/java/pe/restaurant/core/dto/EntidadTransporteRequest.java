package pe.restaurant.core.dto;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadTransporteRequest {
    @Size(max = 20)
    private String placa;

    @Size(max = 30)
    private String licencia;

    @Size(max = 30)
    private String mtc;

    @Size(max = 150)
    private String chofer;
}
