package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Respuesta estándar para GrupoCodigoFlujoCaja siguiendo el patrón de ms-ventas
 * Campos contractuales: id, codigo, nombre, flagReporte, factor, orden, actividadFlujoCajaId,
 * flagEstado, activo
 * Campos de auditoría: createdBy, fecCreacion, updatedBy, fecModificacion (formateados)
 * Campos ignorados: createdAt, updatedAt (no contractuales)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GrupoCodigoFlujoCajaResponse {
    // 🎯 Campos de negocio
    private Long id;
    private String codigo;
    private String nombre;
    private String flagReporte;
    private String factor;
    private Integer orden;
    private Long actividadFlujoCajaId;
    
    // 🎯 Campos de estado contractuales
    private String flagEstado;
    private Boolean activo;
    
    // 🎯 Campos de auditoría contractuales (formateados como String)
    private String createdBy;
    private String fecCreacion;
    private String updatedBy;
    private String fecModificacion;
    
    // 🎯 Campos no contractuales (para ignorar en mapper)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
