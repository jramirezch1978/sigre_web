package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class NovedadRrhhCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Long tipoNovedadRrhhId;
    private String citt;
    @NotNull private LocalDate fechaIni;
    @NotNull private LocalDate fechaFin;
    private Integer diasTeoricos;
    private Integer diasReales;
}
