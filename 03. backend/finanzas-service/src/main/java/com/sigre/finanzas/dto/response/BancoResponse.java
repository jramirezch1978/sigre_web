package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Respuesta estándar para Banco siguiendo el patrón de comercializacion-service
 * Campos contractuales: id, codBanco, nomBanco, proveedor, 
 * codBancoRtps, direccion, swift, codBancoSunat, flagEstado, activo
 * Campos de auditoría: createdBy, fecCreacion, updatedBy, fecModificacion (formateados)
 * Campos ignorados: createdAt, updatedAt (no contractuales)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BancoResponse {
    // 🎯 Campos de negocio
    private Long id;
    private String codBanco;
    private String nomBanco;
    private String proveedor;
    private String codBancoRtps;
    private String direccion;
    private String swift;
    private String codBancoSunat;
    
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
