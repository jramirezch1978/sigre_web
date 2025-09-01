package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO de respuesta inmediata para solicitudes de marcación
 * Devuelve un ticket que se procesará de forma asíncrona
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarcacionResponse {
    
    /**
     * ID del ticket generado
     */
    private Long ticketId;
    
    /**
     * Código de seguimiento para el ticket
     */
    private String codigoSeguimiento;
    
    /**
     * Estado del ticket
     */
    private String estado; // "PENDIENTE", "PROCESANDO", "COMPLETADO", "ERROR"
    
    /**
     * Mensaje para mostrar al usuario
     */
    private String mensaje;
    
    /**
     * Nombre del trabajador validado
     */
    private String nombreTrabajador;
    
    /**
     * Código del trabajador validado
     */
    private String codigoTrabajador;
    
    /**
     * Fecha de creación del ticket
     */
    private LocalDateTime fechaCreacion;
    
    /**
     * Indica si hubo error en la validación inicial
     */
    private boolean error;
    
    /**
     * Mensaje de error (si aplica)
     */
    private String mensajeError;
    
    /**
     * Tiempo estimado de procesamiento en segundos
     */
    @Builder.Default
    private Integer tiempoEstimadoSegundos = 5;
    
    /**
     * Factory method para respuesta exitosa
     */
    public static MarcacionResponse exitoso(Long ticketId, String nombreTrabajador, String codigoTrabajador) {
        return MarcacionResponse.builder()
                .ticketId(ticketId)
                .codigoSeguimiento(generarCodigoSeguimiento(ticketId))
                .estado("PENDIENTE")
                .mensaje("Datos recibidos correctamente. Ticket generado.")
                .nombreTrabajador(nombreTrabajador)
                .codigoTrabajador(codigoTrabajador)
                .fechaCreacion(LocalDateTime.now())
                .error(false)
                .tiempoEstimadoSegundos(5)
                .build();
    }
    
    /**
     * Factory method para respuesta de error
     */
    public static MarcacionResponse error(String mensajeError, String codigoInput) {
        return MarcacionResponse.builder()
                .ticketId(null)
                .codigoSeguimiento(null)
                .estado("ERROR")
                .mensaje("Error en validación inicial")
                .nombreTrabajador(null)
                .codigoTrabajador(null)
                .fechaCreacion(LocalDateTime.now())
                .error(true)
                .mensajeError(mensajeError)
                .tiempoEstimadoSegundos(0)
                .build();
    }
    
    /**
     * Generar código de seguimiento único
     */
    private static String generarCodigoSeguimiento(Long ticketId) {
        return String.format("TKT-%06d-%d", ticketId, System.currentTimeMillis() % 10000);
    }
}
