package pe.restaurant.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
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
@Table(name = "parte_produccion_producido", schema = "produccion")
public class ParteProduccionProducido extends BaseEntity {

    @Column(name = "parte_produccion_id", nullable = false)
    private Long parteProduccionId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;

    @Column(name = "cantidad_producida", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadProducida;
}
