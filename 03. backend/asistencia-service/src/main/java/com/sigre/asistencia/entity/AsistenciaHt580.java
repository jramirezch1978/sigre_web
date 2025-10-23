package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;
import java.time.LocalDate;

@Entity
@Table(name = "asistencia_ht580")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "reckey")
public class AsistenciaHt580 {
    
    @Id
    @Column(name = "RECKEY", length = 12)
    private String reckey;
    
    @Column(name = "COD_ORIGEN", length = 2)
    private String codOrigen;
    
    @Column(name = "CODIGO", length = 20, nullable = false)
    private String codigo;
    
    @Column(name = "FLAG_IN_OUT", length = 2, nullable = false)
    private String flagInOut;  // 1=Ingreso, 2=Salida, ..., 10=REGRESO_CENAR
    
    @Column(name = "FEC_REGISTRO", nullable = false)
    private LocalDateTime fechaRegistro;
    
    @Column(name = "FEC_MOVIMIENTO", nullable = false)
    private LocalDate fechaMovimiento;  // ✅ DATE sin hora (índice único)
    
    @Column(name = "COD_USR", length = 6, nullable = false)
    private String codUsuario;
    
    @Column(name = "DIRECCION_IP", length = 20)
    private String direccionIp;
    
    @Column(name = "FLAG_VERIFY_TYPE", length = 1, nullable = false)
    private String flagVerifyType;
    
    @Column(name = "TURNO", length = 4, nullable = false)
    private String turno; // FK hacia tabla turno
    
    @Column(name = "LECTURA_PDA", length = 3000)
    private String lecturaPda;
    
    @Column(name = "TIPO_MARCACION", length = 10, nullable=false)
    private String tipoMarcacion; // Tipo de marcación
    
    @Column(name = "OBSERVACIONES", length = 200)
    private String observaciones;
    
    @Column(name = "FLAG_ESTADO", length = 1, nullable = false)
    @Builder.Default
    private String flagEstado = "1";
    
    // ===== CAMPOS DE SINCRONIZACIÓN =====
    
    @Column(name = "FECHA_SYNC")
    private LocalDateTime fechaSync;
    
    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error
    
    @Column(name = "INTENTOS_SYNC")
    @Builder.Default
    private Integer intentosSync = 0;
    
    // ===== RELACIONES JPA =====
    
    /**
     * Relación con el turno (FK hacia tabla turno con padding correcto)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TURNO", referencedColumnName = "TURNO", insertable = false, updatable = false)
    private Turno turnoEntity;
    
    /**
     * Configurar campos de sincronización antes de guardar
     */
    @PrePersist
    public void prePersist() {
        System.out.println("🔍 DEBUG @PrePersist ejecutado para RECKEY: " + reckey);
        
        // Marcar como pendiente de sincronización para que sync-service lo procese
        if (estadoSync == null) {
            estadoSync = "P"; // P = Pendiente
            System.out.println("🔍 DEBUG estadoSync seteado a 'P'");
        }
        if (intentosSync == null) {
            intentosSync = 0;
            System.out.println("🔍 DEBUG intentosSync seteado a 0");
        }
        
        System.out.println("🔍 DEBUG @PrePersist FINAL - estadoSync: '" + estadoSync + "', intentosSync: " + intentosSync);
    }
}