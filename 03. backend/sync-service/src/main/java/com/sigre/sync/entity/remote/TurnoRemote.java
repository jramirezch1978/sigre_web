package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Entidad para tabla turno en BD remota (Oracle)
 */
@Entity
@Table(name = "turno")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TurnoRemote {
    
    @Id
    @Column(name = "TURNO", length = 4)
    private String turno;
    
    @Column(name = "HORA_INICIO_NORM")
    private LocalDateTime horaInicioNorm;
    
    @Column(name = "HORA_FINAL_NORM")
    private LocalDateTime horaFinalNorm;
    
    @Column(name = "REFRIG_INICIO_NORM")
    private LocalDateTime refrigInicioNorm;
    
    @Column(name = "REFRIG_FINAL_NORM")
    private LocalDateTime refrigFinalNorm;
    
    @Column(name = "HORA_INICIO_SAB")
    private LocalDateTime horaInicioSab;
    
    @Column(name = "HORA_FINAL_SAB")
    private LocalDateTime horaFinalSab;
    
    @Column(name = "REFRIG_INICIO_SAB")
    private LocalDateTime refrigInicioSab;
    
    @Column(name = "REFRIG_FINAL_SAB")
    private LocalDateTime refrigFinalSab;
    
    @Column(name = "HORA_INICIO_DOM")
    private LocalDateTime horaInicioDom;
    
    @Column(name = "HORA_FINAL_DOM")
    private LocalDateTime horaFinalDom;
    
    @Column(name = "HORA_INI_CMPS_NORM")
    private LocalDateTime horaIniCmpsNorm;
    
    @Column(name = "HORA_FIN_CMPS_NORM")
    private LocalDateTime horaFinCmpsNorm;
    
    @Column(name = "HORA_INI_CMPS_SAB")
    private LocalDateTime horaIniCmpsSab;
    
    @Column(name = "HORA_FIN_CMPS_SAB")
    private LocalDateTime horaFinCmpsSab;
    
    @Column(name = "HORA_INI_CMPS_DOM")
    private LocalDateTime horaIniCmpsDom;
    
    @Column(name = "HORA_FIN_CMPS_DOM")
    private LocalDateTime horaFinCmpsDom;
    
    @Column(name = "MARC_DIARIA_NORM", precision = 1)
    private Integer marcDiariaNorm;
    
    @Column(name = "MARC_DIARIA_SAB", precision = 1)
    private Integer marcDiariaSab;
    
    @Column(name = "MARC_DIARIA_DOM", precision = 1)
    private Integer marcDiariaDom;
    
    @Column(name = "TOLERANCIA", precision = 2)
    private Integer tolerancia;
    
    @Column(name = "TIPO_TURNO", length = 1)
    private String tipoTurno;
    
    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;
    
    @Column(name = "DESCRIPCION", length = 40)
    private String descripcion;
    
    @Column(name = "COD_USR", length = 6)
    private String codUsuario;
    
    @Column(name = "FLAG_REPLICACION", length = 1)
    private String flagReplicacion;
}
