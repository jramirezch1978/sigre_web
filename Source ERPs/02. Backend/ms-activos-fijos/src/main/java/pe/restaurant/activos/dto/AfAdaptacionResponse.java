package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionResponse {

    private Long id;
    private Long afMaestroId;
    private LocalDate fecha;
    private String descripcion;
    private BigDecimal montoTotal;
    private String flagEstado;
}
