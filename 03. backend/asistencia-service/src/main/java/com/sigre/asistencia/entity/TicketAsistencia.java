package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;

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
    @Column(name = "numero_ticket", length = 10, nullable = false)
    private String numeroTicket; // PK - Número de ticket hexadecimal (formato: [cod_origen][padding][secuencial_hex])
    
    @Column(name = "codigo_input", nullable = false, length = 20)
    private String codigoInput; // DNI, código trabajador o código tarjeta
    
    @Column(name = "tipo_input", nullable = false, length = 20)
    private String tipoInput; // "DNI", "CODIGO_TRABAJADOR", "CODIGO_TARJETA"
    
    @Column(name = "cod_origen", nullable = false, length = 2)
    private String codOrigen; // Código de origen del dispositivo/ubicación (del frontend)
    
    @Column(name = "cod_trabajador", nullable = false, length = 8)
    private String codTrabajador; // Código del trabajador encontrado - FK hacia Maestro
    
    @Column(name = "nombre_trabajador", nullable = false, length = 200)
    private String nombreTrabajador;
    
    @Column(name = "tipo_marcaje", nullable = false, length = 50)
    private String tipoMarcaje; // "puerta-principal", "area-produccion", "comedor"
    
    @Column(name = "tipo_movimiento", nullable = false, length = 50)
    private String tipoMovimiento; // "INGRESO_PLANTA", "SALIDA_PLANTA", etc.
    
    @Column(name = "direccion_ip", nullable = false, length = 20)
    private String direccionIp; // IP del dispositivo marcador
    
    @Column(name = "raciones_seleccionadas", columnDefinition = "TEXT")
    private String racionesSeleccionadas; // JSON con las raciones seleccionadas
    
    @Column(name = "fecha_marcacion", nullable = false)
    private LocalDateTime fechaMarcacion;
    
    @Column(name = "estado_procesamiento", nullable = false, length = 1)
    @Builder.Default
    private String estadoProcesamiento = "P"; // P=Pendiente, R=Procesando, C=Completado, E=Error
    
    @Column(name = "id_asistencia_generado", length = 12)
    private String idAsistenciaGenerado; // RECKEY de asistencia_ht580 generado
    
    // Campo eliminado: se usa tabla intermedia ticket_raciones_generadas
    
    @Column(name = "mensaje_error", columnDefinition = "TEXT")
    private String mensajeError; // Detalle del error si el procesamiento falla
    
    @Column(name = "intentos_procesamiento")
    @Builder.Default
    private Integer intentosProcesamiento = 0;
    
    @Column(name = "usuario_sistema", nullable = false, length = 20)
    @Builder.Default
    private String usuarioSistema = "work"; // Usuario para integraciones externas
    
    @CreationTimestamp
    @Builder.Default
    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion = LocalDateTime.now();
    
    @UpdateTimestamp
    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;
    
    @Column(name = "fecha_procesamiento")
    private LocalDateTime fechaProcesamiento;
    
    // ===== RELACIONES JPA =====
    
    /**
     * Relación con el trabajador (FK hacia Maestro)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cod_trabajador", referencedColumnName = "COD_TRABAJADOR", insertable = false, updatable = false)
    private Maestro trabajador;
    
    /**
     * Relación con el registro de asistencia generado (FK hacia AsistenciaHt580)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_asistencia_generado", referencedColumnName = "RECKEY", insertable = false, updatable = false)
    private AsistenciaHt580 asistenciaGenerada;
    
    /**
     * Relación con las raciones generadas (via tabla intermedia)
     */
    @OneToMany(mappedBy = "ticket", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<TicketRacionGenerada> racionesGeneradas;
    
    // Métodos helper (usando códigos de 1 letra)
    public boolean isPendiente() {
        return "P".equals(estadoProcesamiento);
    }
    
    public boolean isProcesando() {
        return "R".equals(estadoProcesamiento);
    }
    
    public boolean isCompletado() {
        return "C".equals(estadoProcesamiento);
    }
    
    public boolean isError() {
        return "E".equals(estadoProcesamiento);
    }
    
    public void marcarComoProcesando() {
        this.estadoProcesamiento = "R"; // R = Procesando
        this.fechaProcesamiento = LocalDateTime.now();
    }
    
    public void marcarComoCompletado(String idAsistencia) {
        this.estadoProcesamiento = "C"; // C = Completado
        this.idAsistenciaGenerado = idAsistencia;
        this.fechaProcesamiento = LocalDateTime.now();
        // Las raciones se asocian via tabla intermedia ticket_raciones_generadas
    }
    
    public void marcarComoError(String error) {
        this.estadoProcesamiento = "E"; // E = Error
        this.mensajeError = error;
        this.intentosProcesamiento++;
        this.fechaProcesamiento = LocalDateTime.now();
    }
}
