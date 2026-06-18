package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionDepResponse {

    private Long id;
    private Long afAdaptacionId;
    private Integer anio;
    private Integer mes;
    private BigDecimal depreciacionPeriodo;
    private BigDecimal depreciacionAcumulada;
    private String flagEstado;
}
