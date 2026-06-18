package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "af_calculo_cntbl", schema = "activos",
        uniqueConstraints = @UniqueConstraint(columnNames = {"af_maestro_id", "anio", "mes"}))
public class AfCalculoCntbl extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "af_tipo_operacion_id")
    private Long afTipoOperacionId;

    @Column(nullable = false)
    private Integer anio;

    @Column(nullable = false)
    private Integer mes;

    @Column(name = "depreciacion_periodo", nullable = false, precision = 18, scale = 4)
    private BigDecimal depreciacionPeriodo;

    @Column(name = "depreciacion_acumulada", nullable = false, precision = 18, scale = 4)
    private BigDecimal depreciacionAcumulada = BigDecimal.ZERO;

    @Column(name = "valor_neto", nullable = false, precision = 18, scale = 4)
    private BigDecimal valorNeto;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;
}
