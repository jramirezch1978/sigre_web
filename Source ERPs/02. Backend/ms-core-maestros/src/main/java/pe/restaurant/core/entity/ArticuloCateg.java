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
@Table(name = "articulo_categ", schema = "core")
public class ArticuloCateg extends BaseEntity {

    @Column(name = "cat_art", nullable = false, unique = true, length = 10)
    private String catArt;

    @Column(name = "desc_categ", nullable = false, length = 200)
    private String descCateg;
}
