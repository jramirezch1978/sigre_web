package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfCalculoCntblResponse {

    private Long id;
    private Long afMaestroId;
    private Integer anio;
    private Integer mes;
    private BigDecimal depreciacionPeriodo;
    private BigDecimal depreciacionAcumulada;
    private BigDecimal valorNeto;
    private Long cntblAsientoId;
    private String flagEstado;
}
