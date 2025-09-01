package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * Entidad para manejo de cola de asistencia de alta concurrencia
 * Funciona como buffer para procesar registros de forma asíncrona
 */
@Entity
@Table(name = "tickets_asistencia")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TicketAsistencia {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ticket_id")
    private Long ticketId;
    
    @Column(name = "codigo_input", nullable = false, length = 20)
    private String codigoInput; // DNI, código trabajador o código tarjeta
    
    @Column(name = "tipo_input", nullable = false, length = 20)
    private String tipoInput; // "DNI", "CODIGO_TRABAJADOR", "CODIGO_TARJETA"
    
    @Column(name = "cod_trabajador", nullable = false, length = 6)
    private String codTrabajador; // Código del trabajador encontrado
    
    @Column(name = "nombre_trabajador", nullable = false, length = 200)
    private String nombreTrabajador;
    
    @Column(name = "tipo_marcaje", nullable = false, length = 50)
    private String tipoMarcaje; // "puerta-principal", "area-produccion", "comedor"
    
    @Column(name = "tipo_movimiento", nullable = false, length = 50)
    private String tipoMovimiento; // "INGRESO_PLANTA", "SALIDA_PLANTA", etc.
    
    @Column(name = "direccion_ip", nullable = false, length = 45)
    private String direccionIp; // IP del dispositivo marcador
    
    @Column(name = "raciones_seleccionadas", columnDefinition = "TEXT")
    private String racionesSeleccionadas; // JSON con las raciones seleccionadas
    
    @Column(name = "fecha_marcacion", nullable = false)
    private LocalDateTime fechaMarcacion;
    
    @Column(name = "estado_procesamiento", nullable = false, length = 20)
    @Builder.Default
    private String estadoProcesamiento = "PENDIENTE"; // PENDIENTE, PROCESANDO, COMPLETADO, ERROR
    
    @Column(name = "id_asistencia_generado", length = 12)
    private String idAsistenciaGenerado; // RECKEY de asistencia_ht580 generado
    
    @Column(name = "ids_raciones_generados", columnDefinition = "TEXT")
    private String idsRacionesGenerados; // IDs de raciones_seleccionadas generados (JSON)
    
    @Column(name = "mensaje_error", columnDefinition = "TEXT")
    private String mensajeError; // Detalle del error si el procesamiento falla
    
    @Column(name = "intentos_procesamiento")
    @Builder.Default
    private Integer intentosProcesamiento = 0;
    
    @Column(name = "usuario_sistema", nullable = false, length = 20)
    @Builder.Default
    private String usuarioSistema = "work"; // Usuario para integraciones externas
    
    @CreationTimestamp
    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion;
    
    @UpdateTimestamp
    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;
    
    @Column(name = "fecha_procesamiento")
    private LocalDateTime fechaProcesamiento;
    
    // Métodos helper
    public boolean isPendiente() {
        return "PENDIENTE".equals(estadoProcesamiento);
    }
    
    public boolean isProcesando() {
        return "PROCESANDO".equals(estadoProcesamiento);
    }
    
    public boolean isCompletado() {
        return "COMPLETADO".equals(estadoProcesamiento);
    }
    
    public boolean isError() {
        return "ERROR".equals(estadoProcesamiento);
    }
    
    public void marcarComoProcesando() {
        this.estadoProcesamiento = "PROCESANDO";
        this.fechaProcesamiento = LocalDateTime.now();
    }
    
    public void marcarComoCompletado(String idAsistencia, String idsRaciones) {
        this.estadoProcesamiento = "COMPLETADO";
        this.idAsistenciaGenerado = idAsistencia;
        this.idsRacionesGenerados = idsRaciones;
        this.fechaProcesamiento = LocalDateTime.now();
    }
    
    public void marcarComoError(String error) {
        this.estadoProcesamiento = "ERROR";
        this.mensajeError = error;
        this.intentosProcesamiento++;
        this.fechaProcesamiento = LocalDateTime.now();
    }
}
