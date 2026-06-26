package pe.restaurant.core.dto.request;

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
public class ProvisionSucursalRequest {

    @NotBlank
    @Size(min = 2, max = 2)
    private String codigo;

    @NotBlank
    @Size(max = 150)
    private String nombre;

    @Size(max = 300)
    private String direccion;

    @Size(max = 120)
    private String ciudad;

    private Long monedaDefultId;

    private Long paisId;

    private Long departamentoId;

    private Long provinciaId;

    private Long distritoId;

    @Size(max = 12)
    private String ubigeo;
}
