package pe.restaurant.rrhh.dto.request;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteUpdateRequest {
    private LocalDate fecPrestamo;
    private LocalDate fechaInicioDescuento;
    private Short nroCuotas;
    private BigDecimal montoOriginal;
    private BigDecimal montoCuota;
    private Long monedaId;
    private Long entidadContribuyenteId;
    private String flagEstado;
}
