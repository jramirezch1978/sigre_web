package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CerrarConciliacionResponse {

    private Long conciliacionId;
    private BigDecimal diferencia;
    private String mensaje;
}
