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
@Table(name = "remuneracion_minima_vital", schema = "rrhh", uniqueConstraints = {
    @UniqueConstraint(name = "uq_rmv_tipo_fecha", columnNames = {"tipo_trabajador_id", "rmv", "fecha_desde"})
})
public class RemuneracionMinimaVital extends BaseEntity {

    @Column(name = "tipo_trabajador_id", nullable = false)
    private Long tipoTrabajadorId;

    @Column(name = "rmv", nullable = false, precision = 13, scale = 2)
    private BigDecimal rmv;

    @Column(name = "fecha_desde", nullable = false)
    private LocalDate fechaDesde;
}
