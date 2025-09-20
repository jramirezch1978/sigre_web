package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO para recibir solicitudes de marcación desde el frontend
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarcacionRequest {
    
    /**
     * Código ingresado por el trabajador (DNI, código trabajador o código tarjeta)
     */
    private String codigoInput;
    
    /**
     * Código de origen del dispositivo/ubicación (WE, MO, KI, etc.)
     */
    private String codOrigen;
    
    /**
     * Tipo de marcaje seleccionado
     */
    private String tipoMarcaje; // "puerta-principal", "area-produccion", "comedor"
    
    /**
     * Tipo de movimiento/asistencia seleccionado
     */
    private String tipoMovimiento; // "INGRESO_PLANTA", "SALIDA_PLANTA", etc.
    
    /**
     * IP del dispositivo marcador (tablet, celular, etc.)
     */
    private String direccionIp;
    
    /**
     * Fecha y hora de la marcación (formato: dd/MM/yyyy HH:mm:ss)
     * Se recibe como String para evitar problemas de zona horaria y conversión UTC
     */
    private String fechaMarcacion;
    
    /**
     * Raciones seleccionadas (si aplica)
     */
    private List<RacionSeleccionada> racionesSeleccionadas;
    
    /**
     * DTO interno para raciones seleccionadas
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class RacionSeleccionada {
        private String tipoRacion; // "A" = Almuerzo, "C" = Cena, "D" = Desayuno
        private String codigoRacion;
        private String nombreRacion;
        private String fechaServicio; // Fecha en formato ISO String desde frontend
    }
}
