package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;

@Entity
@Table(name = "rrhh_asigna_trjt_reloj")
@IdClass(RrhhAsignaTrjtRelojRemoteId.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = {"codTrabajador", "codTarjeta"})
public class RrhhAsignaTrjtRelojRemote {
    
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
}
