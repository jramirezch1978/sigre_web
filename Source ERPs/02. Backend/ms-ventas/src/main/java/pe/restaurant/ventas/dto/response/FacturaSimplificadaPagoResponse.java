package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaPagoResponse {
    private Long id;
    private Long formaPagoId;
    private String formaPagoNombre;
    private BigDecimal monto;
    private String referencia;
    private Instant fechaPago;
    
    // 🎯 CAMPOS DE AUDITORÍA ESTÁNDAR CONTRACTUAL
    private String flagEstado;      // "1" activo, "0" inactivo
    private Long createdBy;         // ID usuario creador
    private String fecCreacion;    // "dd/MM/yyyy HH:mm:ss"
    private Long updatedBy;         // ID usuario modificador (null si no modificado)
    private String fecModificacion; // "dd/MM/yyyy HH:mm:ss" (null si no modificado)
    
    // ❌ Campos a ignorar en mapper (mantener por compatibilidad)
    private Boolean activo;
    private Instant createdAt;
    private Instant updatedAt;
}
