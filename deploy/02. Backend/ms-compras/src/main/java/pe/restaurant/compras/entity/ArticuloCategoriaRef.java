package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "articulo_categ", schema = "core")
public class ArticuloCategoriaRef {

    @Id
    private Long id;

    @Column(name = "cat_art", length = 20)
    private String catArt;
}
