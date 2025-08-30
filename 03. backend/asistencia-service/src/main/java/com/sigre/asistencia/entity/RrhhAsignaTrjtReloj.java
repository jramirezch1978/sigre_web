package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import java.time.LocalDate;

@Entity
@Table(name = "rrhh_asigna_trjt_reloj")
@IdClass(RrhhAsignaTrjtRelojId.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = {"codTrabajador", "codTarjeta"})
@ToString(exclude = "trabajador")
public class RrhhAsignaTrjtReloj {
    
    @Id
    @Column(name = "COD_TRABAJADOR", length = 8)
    private String codTrabajador;
    
    @Id
    @Column(name = "COD_TARJETA", length = 14)
    private String codTarjeta;
    
    @Column(name = "FECHA_INICIO")
    private LocalDate fechaInicio;
    
    @Column(name = "FECHA_FIN")
    private LocalDate fechaFin;
    
    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";
    
    // Relación muchos a uno con Maestro
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_TRABAJADOR", referencedColumnName = "COD_TRABAJADOR", insertable = false, updatable = false)
    private Maestro trabajador;
    
    // Método helper para verificar si la tarjeta está vigente
    public boolean isVigente() {
        LocalDate hoy = LocalDate.now();
        return isVigenteEnFecha(hoy);
    }
    
    // Método helper para verificar si la tarjeta está vigente en una fecha específica
    public boolean isVigenteEnFecha(LocalDate fecha) {
        return "1".equals(flagEstado) && 
               (fechaInicio == null || !fecha.isBefore(fechaInicio)) &&
               (fechaFin == null || !fecha.isAfter(fechaFin));
    }
    
    // Método helper para verificar si la tarjeta está activa (flag_estado = '1')
    public boolean isActiva() {
        return "1".equals(flagEstado);
    }
    
    // Método helper para obtener información de la tarjeta
    public String getInfoTarjeta() {
        return String.format("Tarjeta: %s - Trabajador: %s - Estado: %s - Vigencia: %s a %s", 
                           codTarjeta, codTrabajador, 
                           isActiva() ? "ACTIVA" : "INACTIVA",
                           fechaInicio != null ? fechaInicio.toString() : "Sin fecha inicio",
                           fechaFin != null ? fechaFin.toString() : "Sin fecha fin");
    }
}