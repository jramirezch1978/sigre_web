package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class PrestamoResponse {
    private Long id;
    private Long trabajadorId;
    private BigDecimal montoTotal;
    private Integer cuotas;
    private BigDecimal cuotaMensual;
    private BigDecimal saldo;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
