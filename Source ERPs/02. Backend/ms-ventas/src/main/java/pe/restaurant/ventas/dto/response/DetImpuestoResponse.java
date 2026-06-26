package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DetImpuestoResponse {

    private Long id;
    private Long tiposImpuestoId;
    private BigDecimal importe;
}
