package pe.restaurant.rrhh.dto.request;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PrestamoUpdateRequest {
    private BigDecimal montoTotal;
    private Integer cuotas;
    private String flagEstado;
}
