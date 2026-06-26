package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ServicioCatalogoRequest {

    @NotBlank
    @Size(max = 6)
    private String servicio;

    @Size(max = 1)
    private String flagEstado;

    private Long articuloSubCategId;

    @Size(max = 200)
    private String descripcion;

    private BigDecimal tarifaEstd;

    private Long unidadMedidaId;
}
