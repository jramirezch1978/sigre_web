package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "impuesto_renta_tramos", schema = "rrhh", uniqueConstraints = {
    @UniqueConstraint(name = "uq_impuesto_renta_vig_sec", columnNames = {"fecha_vig_ini", "secuencia"})
})
public class ImpuestoRentaTramo extends BaseEntity {

    @Column(name = "secuencia", nullable = false)
    private Integer secuencia;

    @Column(name = "tasa", nullable = false, precision = 5, scale = 2)
    private BigDecimal tasa;

    @Column(name = "tope_ini", nullable = false, precision = 13, scale = 2)
    private BigDecimal topeIni = BigDecimal.ZERO;

    @Column(name = "tope_fin", nullable = false, precision = 13, scale = 2)
    private BigDecimal topeFin = BigDecimal.ZERO;

    @Column(name = "fecha_vig_ini", nullable = false)
    private LocalDate fechaVigIni;

    @Column(name = "fecha_vig_fin")
    private LocalDate fechaVigFin;

    @Column(name = "cod_usr", length = 6)
    private String codUsr;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";
}
