package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Respuesta estándar para ConceptoFinanciero siguiendo el patrón de ms-ventas
 * Campos contractuales: id, codigo, nombre, flagEstado, activo
 * Campos de auditoría: createdBy, fecCreacion, updatedBy, fecModificacion (formateados)
 * Campos ignorados: createdAt, updatedAt (no contractuales)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoFinancieroResponse {
    // 🎯 Campos de negocio
    private Long id;
    private String codigo;
    private String nombre;
    private Long matrizContableId;
    
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
