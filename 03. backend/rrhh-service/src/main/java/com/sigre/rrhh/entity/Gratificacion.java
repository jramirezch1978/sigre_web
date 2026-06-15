package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.AuditOnlyMappedEntity;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "gratificacion", schema = "rrhh",
       uniqueConstraints = @UniqueConstraint(columnNames = {"trabajador_id", "anio", "periodo_gratificacion_id"}))
public class Gratificacion extends AuditOnlyMappedEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "periodo_gratificacion_id", nullable = false)
    private Long periodoGratificacionId;

    @Column(name = "remuneracion_computable", nullable = false, precision = 18, scale = 4)
    private BigDecimal remuneracionComputable;

    @Column(name = "meses_laborados", nullable = false)
    private Integer mesesLaborados;

    @Column(name = "monto_gratificacion", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoGratificacion;

    @Column(name = "bonificacion_extraordinaria", precision = 18, scale = 4)
    private BigDecimal bonificacionExtraordinaria;

    @Column(name = "total", nullable = false, precision = 18, scale = 4)
    private BigDecimal total;
}
