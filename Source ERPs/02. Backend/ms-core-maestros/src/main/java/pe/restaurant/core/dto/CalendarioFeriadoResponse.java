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
public class CalendarioFeriadoResponse {
    private Long id;
    private LocalDate fecha;
    private String descripcion;
    private Long sucursalId;
    private String flagEstado;
}
