package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "af_adaptacion_dep", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfAdaptacionDep extends BaseEntity {

    @Column(name = "af_adaptacion_id", nullable = false)
    private Long afAdaptacionId;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "depreciacion_periodo", precision = 18, scale = 4, nullable = false)
    private BigDecimal depreciacionPeriodo;

    @Column(name = "depreciacion_acumulada", precision = 18, scale = 4, nullable = false)
    private BigDecimal depreciacionAcumulada;
}
