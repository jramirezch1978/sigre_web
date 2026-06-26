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
@Table(name = "operaciones_det", schema = "produccion")
public class OperacionesDet extends BaseEntity {

    @Column(name = "operacion_id", nullable = false)
    private Long operacionId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "cantidad_requerida", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadRequerida;
}
