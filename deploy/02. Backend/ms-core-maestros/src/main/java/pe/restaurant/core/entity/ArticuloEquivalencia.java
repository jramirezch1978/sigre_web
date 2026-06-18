package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@Entity
@Table(name = "articulo_equivalencias", schema = "core")
public class ArticuloEquivalencia extends BaseEntity {

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "articulo_equivalente_id", nullable = false)
    private Long articuloEquivalenteId;

    @Column(nullable = false, precision = 18, scale = 6)
    private BigDecimal factor = BigDecimal.ONE;
}
