package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Vista de solo lectura sobre {@code core.articulo}.
 */
@Getter
@NoArgsConstructor
@Entity
@Table(name = "articulo", schema = "core")
public class ArticuloRef {

    @Id
    private Long id;

    @Column(name = "codigo", length = 30)
    private String codigo;

    @Column(name = "nombre", length = 220)
    private String nombre;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;

    @Column(name = "articulo_sub_categ_id")
    private Long articuloSubCategId;
}
