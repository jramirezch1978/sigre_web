package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "seccion", schema = "rrhh", uniqueConstraints = {
    @UniqueConstraint(name = "uq_seccion_area_codigo", columnNames = {"area_id", "codigo"})
})
public class Seccion extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;

    @Column(name = "area_id", nullable = false)
    private Long areaId;

    @Column(name = "porc_sctr_onp", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcSctrOnp = BigDecimal.ZERO;
}
