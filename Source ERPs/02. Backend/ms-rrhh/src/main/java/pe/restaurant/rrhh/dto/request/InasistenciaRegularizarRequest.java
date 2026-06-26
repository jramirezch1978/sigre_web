package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class InasistenciaRegularizarRequest {

    @NotBlank(message = "El motivo es obligatorio.")
    private String motivo;

    private LocalDate fechaHasta;

    private BigDecimal diasInasistencia;

    private String flagEstado;
}
