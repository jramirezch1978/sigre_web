package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para un registro de ganancia/descuento variable.
 * Incluye campos derivados: trabajadorNombres y conceptoNombre.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDescVariableResponse {

    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private String fecMovim;
    private Long conceptoId;
    private String conceptoNombre;
    private String nroDoc;
    private BigDecimal impVar;
    private Long centrosCostoId;
    private String centrosCostoDescripcion;
    private BigDecimal cantLabor;
    private BigDecimal nroDias;
    private BigDecimal nroHoras;
    private Integer nroCuotas;
    private Long tipoPlanillaId;
    private String tipoPlanillaNombre;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
