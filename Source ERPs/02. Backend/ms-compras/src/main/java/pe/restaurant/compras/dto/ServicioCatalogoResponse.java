package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ServicioCatalogoResponse {

    private Long id;
    private String servicio;
    private String flagEstado;
    private Long articuloSubCategId;
    private String descripcion;
    private BigDecimal tarifaEstd;
    private Long unidadMedidaId;
}
