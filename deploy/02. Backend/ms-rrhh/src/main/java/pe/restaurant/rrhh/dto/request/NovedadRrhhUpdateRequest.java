package pe.restaurant.rrhh.dto.request;

import lombok.Data;
import java.time.LocalDate;

@Data
public class NovedadRrhhUpdateRequest {
    private Long tipoNovedadRrhhId;
    private String citt;
    private LocalDate fechaIni;
    private LocalDate fechaFin;
    private Integer diasTeoricos;
    private Integer diasReales;
    private String flagEstado;
}
