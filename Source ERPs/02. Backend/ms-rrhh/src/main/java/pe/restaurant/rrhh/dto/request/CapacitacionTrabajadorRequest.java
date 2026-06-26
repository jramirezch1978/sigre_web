package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CapacitacionTrabajadorRequest {

    @NotNull
    private Long trabajadorId;

    private Boolean asistio;
    private BigDecimal calificacion;
    private Boolean certificado;
}
