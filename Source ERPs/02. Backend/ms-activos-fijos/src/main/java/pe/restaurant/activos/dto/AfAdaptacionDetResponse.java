package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionDetResponse {

    private Long id;
    private Long afAdaptacionId;
    private String descripcion;
    private BigDecimal monto;
    private Long unidadMedidaId;
    private String flagEstado;
}
