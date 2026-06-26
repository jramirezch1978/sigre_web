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
public class EntidadContribuyenteRepresentanteRequest {
    @Size(max = 150)
    private String nombre;

    @Size(max = 120)
    private String cargo;

    @Size(max = 20)
    private String telefono;

    @Size(max = 200)
    private String email;
}
