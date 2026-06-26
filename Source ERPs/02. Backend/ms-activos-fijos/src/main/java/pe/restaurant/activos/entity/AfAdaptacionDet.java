package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "af_adaptacion_det", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfAdaptacionDet extends BaseEntity {

    @Column(name = "af_adaptacion_id", nullable = false)
    private Long afAdaptacionId;

    @Column(name = "descripcion", nullable = false, length = 300)
    private String descripcion;

    @Column(name = "monto", precision = 18, scale = 4, nullable = false)
    private BigDecimal monto;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;
}
