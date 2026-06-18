package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class CerrarPeriodoRequest {
    @NotNull
    private LocalDate fechaDesde;
    @NotNull
    private LocalDate fechaHasta;
}
