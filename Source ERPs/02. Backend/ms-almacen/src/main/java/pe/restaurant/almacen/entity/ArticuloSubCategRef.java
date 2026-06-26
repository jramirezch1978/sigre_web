package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Vista de solo lectura sobre {@code core.articulo_sub_categ} para resolución de matriz contable.
 */
@Getter
@NoArgsConstructor
@Entity
@Table(name = "articulo_sub_categ", schema = "core")
public class ArticuloSubCategRef {

    @Id
    private Long id;

    @Column(name = "cod_sub_cat", nullable = false, length = 10)
    private String codSubCat;
}
