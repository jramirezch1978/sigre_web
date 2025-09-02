package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

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
    
    @Column(name = "FLAG_IN_OUT", length = 1, nullable = false)
    private String flagInOut;
    
    @Column(name = "FEC_REGISTRO", nullable = false)
    private LocalDateTime fechaRegistro;
    
    @Column(name = "FEC_MOVIMIENTO", nullable = false)
    private LocalDateTime fechaMovimiento;
    
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
    
    // ===== RELACIONES JPA =====
    
    /**
     * Relación con el turno (FK hacia tabla turno con padding correcto)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TURNO", referencedColumnName = "TURNO", insertable = false, updatable = false)
    private Turno turnoEntity;
}