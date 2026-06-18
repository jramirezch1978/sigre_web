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
public class EntidadContribuyenteTelefonoRequest {
    @Size(max = 60)
    private String descripcion;

    @Size(max = 5)
    private String codigoPais;

    @Size(max = 5)
    private String codigoCiudad;

    @Size(max = 20)
    private String numero;

    @Size(max = 1)
    private String flagFax;
}
