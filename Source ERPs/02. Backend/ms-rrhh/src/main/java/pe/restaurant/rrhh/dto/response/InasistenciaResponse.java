package pe.restaurant.rrhh.dto.response;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
@Builder
public class InasistenciaResponse {

    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private Long conceptoPlanillaId;
    private String conceptoPlanillaCodigo;
    private String conceptoPlanillaNombre;
    private LocalDate fechaDesde;
    private LocalDate fechaHasta;
    private LocalDate fechaMovimiento;
    private BigDecimal diasInasistencia;
    private String flagVacacionesAdelantadas;
    private BigDecimal importe;
    private String flagEstado;
    private Long createdBy;
    private String createdByLogin;
    private OffsetDateTime fecCreacion;
}
