package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartaResponse {
    private Long id;
    private Long sucursalId;
    private String sucursalNombre;
    private String nombre;
    private String descripcion;
    
    // 🎯 CAMPOS DE AUDITORÍA ESTÁNDAR CONTRACTUAL
    private String flagEstado;      // "1" activo, "0" inactivo
    private Long createdBy;         // ID usuario creador
    private String fecCreacion;    // "dd/MM/yyyy HH:mm:ss"
    private Long updatedBy;         // ID usuario modificador (null si no modificado)
    private String fecModificacion; // "dd/MM/yyyy HH:mm:ss" (null si no modificado)
    
    // ❌ Campos a ignorar en mapper (mantener por compatibilidad)
    private Boolean activo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private List<CartaDetResponse> detalles;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartaDetResponse {
        private Long id;
        private Long cartaId;
        private Long articuloId;
        private String articuloCodigo;
        private String articuloNombre;
        private java.math.BigDecimal precio;
        private Integer orden;
        
        // 🎯 CAMPOS DE AUDITORÍA ESTÁNDAR CONTRACTUAL
        private String flagEstado;      // "1" activo, "0" inactivo
        private Long createdBy;         // ID usuario creador
        private String fecCreacion;    // "dd/MM/yyyy HH:mm:ss"
        private Long updatedBy;         // ID usuario modificador (null si no modificado)
        private String fecModificacion; // "dd/MM/yyyy HH:mm:ss" (null si no modificado)
        
        // ❌ Campos a ignorar en mapper (mantener por compatibilidad)
        private Boolean activo;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
    }
}
