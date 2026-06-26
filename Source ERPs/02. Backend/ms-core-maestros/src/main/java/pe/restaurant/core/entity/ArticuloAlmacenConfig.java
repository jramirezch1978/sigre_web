package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_almacen", schema = "almacen")
public class ArticuloAlmacenConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "cantidad_reservada")
    private BigDecimal stockMin;

    @Column(name = "cantidad_disponible")
    private BigDecimal stockMax;
}
