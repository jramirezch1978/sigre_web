package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "gan_desct_fijo", schema = "rrhh")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GanDescFijo extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    @Column(name = "imp_gan_desc", precision = 18, scale = 4)
    private BigDecimal impGanDesc;

    @Column(name = "porcentaje", precision = 8, scale = 4)
    private BigDecimal porcentaje;

    @Column(name = "imp_max_gan_desc", precision = 18, scale = 4)
    private BigDecimal impMaxGanDesc;
}
