package pe.restaurant.rrhh.dto.request;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class InasistenciaUpdateRequest {

    private Long conceptoPlanillaId;

    private LocalDate fechaDesde;

    private LocalDate fechaHasta;

    private LocalDate fechaMovimiento;

    private BigDecimal diasInasistencia;

    private String flagVacacionesAdelantadas;

    private BigDecimal importe;

    private String flagEstado;
}
