package pe.restaurant.rrhh.dto.request;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteUpdateRequest {
    private LocalDate fechaApertura;
    private BigDecimal saldoInicial;
    private String flagEstado;
}
