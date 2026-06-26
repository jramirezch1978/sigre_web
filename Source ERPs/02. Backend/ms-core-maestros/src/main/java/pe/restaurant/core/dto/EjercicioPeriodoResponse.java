package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EjercicioPeriodoResponse {
    private Long id;
    private Integer anio;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String flagEstado;
}
