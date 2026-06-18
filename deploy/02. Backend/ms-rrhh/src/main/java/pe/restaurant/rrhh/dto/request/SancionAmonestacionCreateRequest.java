package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class SancionAmonestacionCreateRequest {

    @NotNull private Long trabajadorId;
    @NotNull private Long tipoSancionId;
    @NotNull private LocalDate fecha;
    private String motivo;
    private String documento;
}
