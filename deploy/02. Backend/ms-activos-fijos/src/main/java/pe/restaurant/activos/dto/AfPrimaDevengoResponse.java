package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfPrimaDevengoResponse {
    private Long id;
    private Long afPolizaSeguroId;
    private Integer anio;
    private Integer mes;
    private BigDecimal importeDevengado;
    private Integer mesesVigenciaPoliza;
    private Long cntblAsientoId;
    private String flagEstado;
}
