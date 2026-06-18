package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImpuestoCalculadoResponse {

    private Long tipoImpuestoId;
    private String nombre;
    private BigDecimal tasa;
    private BigDecimal importe;
    private boolean esFiscalizado;
}
