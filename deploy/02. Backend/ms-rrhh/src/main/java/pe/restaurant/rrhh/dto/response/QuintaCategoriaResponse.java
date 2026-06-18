package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para los cálculos de retención de quinta categoría.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuintaCategoriaResponse {

    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private Integer anio;
    private Integer mes;
    private BigDecimal rentaBrutaAcumulada;
    private BigDecimal rentaBrutaProyectada;
    private BigDecimal deduccion7uit;
    private BigDecimal rentaNeta;
    private BigDecimal impuestoAnualProyectado;
    private BigDecimal retencionMensual;
    private BigDecimal retencionAcumulada;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
