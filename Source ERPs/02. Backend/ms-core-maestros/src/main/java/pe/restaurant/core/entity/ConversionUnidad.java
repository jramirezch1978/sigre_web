package pe.restaurant.core.entity;

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
@Table(name = "conversion_unidad", schema = "core")
public class ConversionUnidad extends BaseEntity {

    @Column(name = "unidad_origen_id", nullable = false)
    private Long umOrigenId;

    @Column(name = "unidad_destino_id", nullable = false)
    private Long umDestinoId;

    @Column(name = "factor_conversion", nullable = false, precision = 18, scale = 6)
    private BigDecimal factorConversion;

    @Transient
    private Long articuloId;
}
