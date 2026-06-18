package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EjecutarMovimientoResponse {

    private Long id;
    private LocalDate fechaEjecucion;
    private Long cntblAsientoId;
    private String flagEstado;
    private Long updatedBy;
    private Instant fecModificacion;
}
