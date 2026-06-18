package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CosteoProduccionResponse {

    private Long id;

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;

    private Integer anio;
    private Integer mes;

    private BigDecimal costoMateriaPrima;
    private BigDecimal costoManoObra;
    private BigDecimal costoIndirecto;
    private BigDecimal costoTotal;
    private BigDecimal costoUnitario;
    private BigDecimal rendimientoReal;
    private BigDecimal porcentajeMermaReal;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
