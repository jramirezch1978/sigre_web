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
@Table(name = "articulo_clase", schema = "core")
public class ArticuloClase extends BaseEntity {

    @Column(name = "cod_clase", nullable = false, unique = true, length = 10)
    private String codClase;

    @Column(name = "desc_clase", nullable = false, length = 120)
    private String descClase;
}
