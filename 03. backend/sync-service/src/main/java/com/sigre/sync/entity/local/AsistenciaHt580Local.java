package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "asistencia_ht580")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "reckey")
public class AsistenciaHt580Local {
    
    @Id
    @Column(name = "RECKEY", length = 12) // ID PostgreSQL
    private String reckey;
    
    @Column(name = "EXTERNAL_ID", length = 12, unique = true)
    private String externalId; // ID único de Oracle (único)
    
    @Column(name = "COD_ORIGEN", length = 2)
    private String codOrigen;
    
    @Column(name = "CODIGO", length = 20, nullable = false)
    private String codigo;
    
    @Column(name = "FLAG_IN_OUT", length = 2, nullable = false)
    private String flagInOut; // 1=Ingreso, 2=Salida, ..., 10=REGRESO_CENAR
    
    @Column(name = "FEC_REGISTRO", nullable = false)
    private LocalDateTime fechaRegistro;
    
    @Column(name = "FEC_MOVIMIENTO", nullable = false)
    private LocalDate fechaMovimiento;  // ✅ DATE sin hora (índice único)

    @Column(name = "FEC_UPDATE", nullable = true)
    private LocalDateTime fechaUpdate;
    
    @Column(name = "COD_USR", length = 6, nullable = false)
    private String codUsuario;
    
    @Column(name = "DIRECCION_IP", length = 20)
    private String direccionIp;
    
    @Column(name = "FLAG_VERIFY_TYPE", length = 1, nullable = false)
    private String flagVerifyType;
    
    @Column(name = "TURNO", length = 4, nullable = false)
    private String turno;
    
    @Column(name = "LECTURA_PDA", length = 3000)
    private String lecturaPda;
    
    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDateTime fechaSync;
    
    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error
    
    @Column(name = "INTENTOS_SYNC")
    @Builder.Default
    private Integer intentosSync = 0;
    
    @PrePersist
    public void prePersist() {
        if (reckey == null || reckey.isEmpty()) {
            // Generar UUID único que no colisione con Oracle
            reckey = "LOCAL-" + UUID.randomUUID().toString().substring(0, 29);
        }
        if (estadoSync == null) {
            estadoSync = "P";
        }
        if (intentosSync == null) {
            intentosSync = 0;
        }
    }
}