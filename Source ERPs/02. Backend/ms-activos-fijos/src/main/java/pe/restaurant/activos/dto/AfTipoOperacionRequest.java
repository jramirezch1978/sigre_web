package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class AfTipoOperacionRequest {

    @NotBlank
    @Size(max = 10)
    private String codigo;

    @NotBlank
    @Size(max = 150)
    private String descripcion;

    @NotBlank
    @Size(max = 20)
    private String naturaleza;

    @NotBlank
    @Size(max = 30)
    private String tipoCalculo;

    private Long cuentaContableId;
    private Long centroCostoId;

    @NotNull
    private Boolean afectaContabilidad;

    @Size(max = 30)
    private String metodoCalculo;

    @Size(max = 500)
    private String observaciones;
}
