package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MatrizContableRequest {

    @NotNull
    private Long grupoMatrizCntblId;

    @NotBlank
    @Size(max = 10)
    private String codigo;

    @Size(max = 3000)
    private String descripcion;

    @Size(max = 1)
    private String flagEstado;
}
