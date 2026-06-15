package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PuntoVentaResponse {
    private Long id;
    private Long sucursalId;
    private String sucursalNombre;
    private Long almacenId;
    private String almacenNombre;
    private String codigo;
    private String nombre;
    private String serieBoleta;
    private String serieFactura;
    private String tipoImpresora;
    
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
