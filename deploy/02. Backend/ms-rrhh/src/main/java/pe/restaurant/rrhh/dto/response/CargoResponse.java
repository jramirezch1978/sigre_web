package pe.restaurant.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

/**
 * DTO de salida para representar un cargo organizacional.
 * Incluye información de banda salarial y datos de auditoría.
 */
@Data
public class CargoResponse {
    
    private Long id;
    private String nombre;
    private String nivel;
    private BigDecimal sueldoMinimo;
    private BigDecimal sueldoMaximo;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
