package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PropinaResponse {
    private Long id;
    private Long fsFacturaSimplId;
    private Long trabajadorId;
    private BigDecimal monto;
    private LocalDate fecha;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
