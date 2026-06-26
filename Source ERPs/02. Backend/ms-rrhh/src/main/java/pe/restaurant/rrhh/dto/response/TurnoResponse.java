package pe.restaurant.rrhh.dto.response;

import lombok.*;
import java.time.LocalTime;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TurnoResponse {
    private Long id;
    private String nombre;
    private LocalTime horaEntrada;
    private LocalTime horaSalida;
    private Integer minutosTolerancia;
    private Boolean aplicaLunes;
    private Boolean aplicaMartes;
    private Boolean aplicaMiercoles;
    private Boolean aplicaJueves;
    private Boolean aplicaViernes;
    private Boolean aplicaSabado;
    private Boolean aplicaDomingo;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
