package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartaMenuListItemResponse {
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
    
    // ❌ NO INCLUYE:
    // - Boolean activo
    // - LocalDateTime createdAt/updatedAt
    // - List<CartaDetResponse> detalles (solo en endpoint de detalle)
}
