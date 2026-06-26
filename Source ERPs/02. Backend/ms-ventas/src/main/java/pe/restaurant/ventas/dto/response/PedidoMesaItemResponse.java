package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PedidoMesaItemResponse {
    private Long id;
    private Long articuloId;
    private String articuloNombre;
    private BigDecimal cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal;
    private String observacion;
    
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
