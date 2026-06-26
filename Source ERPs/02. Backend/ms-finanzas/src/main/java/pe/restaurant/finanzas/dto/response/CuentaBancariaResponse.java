package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Respuesta estándar para CuentaBancaria siguiendo el patrón de ms-ventas
 * Campos contractuales: id, codigo, planContableDetId, bancoId, tipoCtaBco, descripcion, 
 * correlativoCheque, monedaId, saldoContable, nroCci, nroCuenta, flagEstado, activo
 * Campos de auditoría: createdBy, fecCreacion, updatedBy, fecModificacion (formateados)
 * Campos ignorados: createdAt, updatedAt (no contractuales)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CuentaBancariaResponse {
    // 🎯 Campos de negocio
    private Long id;
    private String codigo;
    private Long planContableDetId;
    private Long bancoId;
    private String tipoCtaBco;
    private String descripcion;
    private Integer correlativoCheque;
    private Long monedaId;
    private BigDecimal saldoContable;
    private String nroCci;
    private String nroCuenta;
    private Long sucursalId;

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
