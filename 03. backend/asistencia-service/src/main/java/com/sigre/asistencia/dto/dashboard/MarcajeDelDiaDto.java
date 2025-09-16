package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para representar un marcaje del día
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarcajeDelDiaDto {
    
    private String reckey;
    private String codigoTrabajador;
    private String nombreTrabajador;
    private String tipoMarcaje;           // 1=puerta-principal, 2=area-produccion, 3=comedor
    private String tipoMovimiento;        // 1=INGRESO, 2=SALIDA, etc.
    private String descripcionMovimiento; // Descripción legible del movimiento
    private LocalDateTime fechaMovimiento;
    private String centroCosto;           // Extraído del código del trabajador
    private String turno;
    private String direccionIp;
    private String estadoSincronizacion;  // "LOCAL", "REMOTO", "SINCRONIZADO"
}
