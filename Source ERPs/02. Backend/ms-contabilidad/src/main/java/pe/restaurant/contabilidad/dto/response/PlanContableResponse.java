package pe.restaurant.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlanContableResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private Integer anio;
    private LocalDate effectiveFrom;
    private String flagEstado;
}
