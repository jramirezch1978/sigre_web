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
     * Número de ticket generado (PK hexadecimal)
     */
    private String numeroTicket;
    
    /**
     * Código de seguimiento para el ticket
     */
    private String codigoSeguimiento;
    
    /**
     * Estado del ticket
     */
    private String estado; // "P"=Pendiente, "R"=Procesando, "C"=Completado, "E"=Error
    
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
    public static MarcacionResponse exitoso(String numeroTicket, String nombreTrabajador, String codigoTrabajador) {
        return MarcacionResponse.builder()
                .numeroTicket(numeroTicket)
                .codigoSeguimiento(numeroTicket) // El número de ticket hexadecimal ES el código de seguimiento
                .estado("P") // P = Pendiente
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
                .numeroTicket(null)
                .codigoSeguimiento(null)
                .estado("E") // E = Error
                .mensaje("Error en validación inicial")
                .nombreTrabajador(null)
                .codigoTrabajador(null)
                .fechaCreacion(LocalDateTime.now())
                .error(true)
                .mensajeError(mensajeError)
                .tiempoEstimadoSegundos(0)
                .build();
    }
}
