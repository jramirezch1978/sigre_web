package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_sub_categ", schema = "core")
public class ArticuloSubCateg extends BaseEntity {

    @Column(name = "cod_sub_cat", nullable = false, unique = true, length = 10)
    private String codSubCat;

    @Column(name = "desc_subcateg", nullable = false, length = 200)
    private String descSubcateg;

    @Column(name = "articulo_categ_id", nullable = false)
    private Long articuloCategId;
}
