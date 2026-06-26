package pe.restaurant.rrhh.dto.response;

import lombok.Data;

import java.time.OffsetDateTime;

/**
 * DTO de salida para representar un área organizacional.
 */
@Data
public class AreaResponse {
    
    private Long id;
    private String nombre;
    private Long padreId;
    private Long responsableId;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
