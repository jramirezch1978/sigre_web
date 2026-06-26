package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfTrasladoResponse {

    private Long id;
    private Long afMaestroId;
    private Long ubicacionOrigenId;
    private Long ubicacionDestinoId;
    private Long solicitanteId;
    private Long aprobadorId;
    private LocalDate fechaSolicitud;
    private LocalDate fechaEjecucion;
    private String motivo;
}
